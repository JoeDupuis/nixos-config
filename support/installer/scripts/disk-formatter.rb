#!/usr/bin/env nix-shell
#!nix-shell -p ruby -i ruby

# Thanks Sam!
# https://gitlab.com/samueldr/nixos-configuration

# NOTE: this script is mostly borrowed from Mobile NixOS.
# Effort has been taken to make it more easily diffable against it.


require "fileutils"
require "shellwords"
require "json"

MOUNT_POINT = "/mnt"

at_exit do
  system("stty", "echo")
end

# {{{

def ask_passphrase()
  puts ":: rootfs LUKS volume passphrase"

  system("stty", "-echo")

  print "Passphrase: "
  password = $stdin.gets.chomp
  print "\n"

  print "Passphrase (verification): "
  password_verification = $stdin.gets.chomp
  print "\n"
  print "\n"

  system("stty", "echo")

  if password_verification != password then
    $stderr.puts "Passphrase input does not match... Nothing was done."
    exit 1
  end

  password
end

# }}}

# {{{

module Runner
  def prettify_command(*args)
    args = args.dup
    # Removes the environment hash, if present.
    args.shift if args.first.is_a?(Hash)
    if args.length == 1
      args.first
    else
      args.shelljoin
    end
  end

  # Runs and pretty-prints a command. Parameters and shelling-out have the same
  # meaning as with +Kernel#spawn+; one parameter is shelling-out, multiple is
  # direct +exec+.
  #
  # @param args [Array<String>] Command and parameters
  # @raise [Exception] on exit status 127, commonly used for command not found.
  # @raise [Exception] on any other exit status.
  def run(*args, verbose: true)
    pretty_command = prettify_command(*args)
    puts(" $ #{pretty_command}") if verbose
    unless system(*args)
      raise Exception.new("Could not execute `#{pretty_command}`, status nil") if $?.nil?
      status = $?.exitstatus
      if status == 127
        raise Exception.new("Command not found... `#{pretty_command}` (#{status})")
      else
        raise Exception.new("Command failed... `#{pretty_command}` (#{status})")
      end
    end
  end

  def capture2(*args, verbose: true)
    pretty_command = prettify_command(*args)
    puts(" $ #{pretty_command}") if verbose
    Open3.capture2(*args)
  end
end

# }}}

# {{{

module Helpers
  include Runner
  extend self

  class Base
    class << self
      include Runner
    end

    def self.mount(source, target)
      run("mount", source, target)
    end
  end
end

# }}}

# {{{

module Helpers
  class FAT < Base
    def self.format(path, volume_id:, label:)
      cmd = ["mkfs.fat"]
      cmd.concat(["-F", "32"])
      cmd.concat(["-n", label])
      cmd.concat(["-i", volume_id])
      cmd << path
      run(*cmd)
    end
  end

  class Ext4 < Base
    def self.format(path, uuid:, label:)
      cmd = ["mkfs.ext4"]
      cmd << "-F"
      cmd << path
      cmd.concat(["-L", label])
      cmd.concat(["-U", uuid])
      run(*cmd)
    end
  end

  class LUKS < Base
    def self.format(path, uuid:, passphrase:, label: nil)
      cmd = ["cryptsetup"]
      cmd << "luksFormat"
      cmd << path
      cmd.concat(["--uuid", uuid.shellescape])
      cmd.concat(["--key-file", "-"])
      puts " $ #{prettify_command(*cmd)}"
      # FIXME: use proper input redirection, this leaks the passphrase in process list
      # (Which is fine enough with this implementation given it's on an ephemeral installation system)
      cmd = ["echo", "-n", passphrase.shellescape, "|"].concat(cmd)
      run(cmd.join(" "), verbose: false)
    end

    def self.mount(*args)
      raise "No LUKS.mount; see LUKS.open"
    end

    def self.open(path, mapper, passphrase:)
      cmd = ["cryptsetup"]
      cmd << "luksOpen"
      cmd << path
      cmd << mapper
      cmd.concat(["--key-file", "-"])
      puts " $ #{prettify_command(*cmd)}"
      # FIXME: use proper input redirection, this leaks the passphrase in process list
      # (Which is fine enough with this implementation given it's on an ephemeral installation system)
      cmd = ["echo", "-n", passphrase.shellescape, "|"].concat(cmd)
      run(cmd.join(" "), verbose: false)
    end
  end

  def self.wipefs(path)
    cmd = ["wipefs", "--all", "--force", path]
    run(*cmd)
  end
end

# }}}

# {{{
module Helpers
  class GPT < Base
    def self.sfdisk_script(disk, script, *args)
      # TODO: move to proper input redirection instead of shelling-out when possible.
      run("echo #{script.shellescape} | sfdisk --quiet #{disk.shellescape} #{args.shelljoin}")
    end

    def self.format!(path)
      sfdisk_script(path, "label: gpt")
    end

    def self.add_partition(path, size: nil, type:, partlabel: nil, uuid: nil, bootable: false)
      script = []
      if size
        # Unit is in sectors of 512 bytes
        size = (size/512.0).ceil
        script << ["size", size].join("=")
      end
      script << ["type", type].join("=")
      script << ["name", partlabel].join("=") if partlabel
      script << ["uuid", uuid].join("=") if uuid

      attributes = []
      attributes << "LegacyBIOSBootable" if bootable

      script << ["attrs", attributes.join(",").inspect].join("=") unless attributes.empty?

      sfdisk_script(
          path,
          script.join(", "),
          "--append",
          "--wipe", "always",
          "--wipe-partitions", "always",
        )
    end
  end
end
# }}}

# {{{

module Helpers
  module Part
    extend self
    def part(disk, number)
      if disk.match(%r{^/dev/mmcblk}) || disk.match(%r{^/dev/nvme\d+n\d+}) then
        [disk, "p", number].join()
      elsif disk.match(%r{^/dev/sd[a-z]}) then
        [disk, number].join()
      else
        raise "Partition numbering scheme for this disk type (for '#{disk}') not implemented."
      end
    end
  end
end

# }}}


# Split `-*` and other arguments
# This does not handle pairs, and is by design for simplicity at this stage.
# We only have boolean-style parametsr.
begin
  params, ARGV_POSITIONAL = ARGV.partition{|arg|arg.match(/^-/)}
  ARGV_PARAMETERS = params.map{|arg| [arg, true]}.to_h
end

if ARGV_POSITIONAL.length != 2 then
$stderr.puts <<EOF
Usage: #{$0} [--skip-partitioning|--skip-formatting] <disk> <configuration.json>
  --skip-partitioning  The target system will not be partitioned
  --skip-formatting    The target system partitions will not be formatted
                       NOTE: skipping formatting must request to skip partitioning.
EOF
  exit 1
end

# Request to skip formatting, but do partitioning are invalid.
if ARGV_PARAMETERS["--skip-formatting"] && !ARGV_PARAMETERS["--skip-partitioning"] then
$stderr.puts <<EOF
ABORTING: Use --skip-partitioning with --skip-formatting
          It is invalid to do partitioning but no formatting.
EOF
  exit 1
end

puts "==========================================="
puts "= ???????????? installer — disk formatter ="
puts "==========================================="
puts

disk_param = ARGV_POSITIONAL.shift
disk = File.realpath(disk_param)
configuration = JSON.parse(File.read(ARGV_POSITIONAL.shift))
# Will partition if the argument is not given
do_partitioning = !ARGV_PARAMETERS["--skip-partitioning"]
# Will format if the partition is neither arguments are given
do_formatting = !ARGV_PARAMETERS["--skip-formatting"] || do_partitioning

if configuration["fde"]["enable"] && configuration["fde"]["passphrase"] == nil then
  configuration["fde"]["passphrase"] = ask_passphrase
end

puts "Working on '#{disk_param}' → '#{disk}'"

#
# Disk layout
#

# Partition count, to track the location of the last one, the rootfs.
partition_count = 5

if do_partitioning then
  puts ""
  puts "Partitionning..."
  puts ""

  Helpers::wipefs(disk)
  Helpers::GPT.format!(disk)

  # ESP for UEFI
  Helpers::GPT.add_partition(disk, size: configuration["filesystems"]["boot"]["size"], partlabel: "ESP", type: "C12A7328-F81F-11D2-BA4B-00A0C93EC93B")

  # Rootfs partition, will be formatted and mounted as needed
  Helpers::GPT.add_partition(disk, partlabel: "rootfs",  type: "0FC63DAF-8483-4772-8E79-3D69D8477DE4")
end

puts "Waiting for target partitions to show up..."

# Wait up to a minute
(1..600).each do |i|
  print "."
  # Assumes they're all present if the last is present
  break if File.exists?(Helpers::Part.part(disk, partition_count))
  sleep(0.1)
end
# two dots such that if it's instant we get a proper length ellipsis!
print ".. present!\n"

# The ESP is the first partition
esp_partition = Helpers::Part.part(disk, 1)
# The rootfs is the last partition
rootfs_partition = Helpers::Part.part(disk, partition_count)
mapper_name = "installer-rootfs"

#
# Rootfs formatting
#

if configuration["fde"]["enable"] then
  if do_formatting then
    puts ""
    puts "Making new LUKS volume..."
    puts ""
    Helpers::LUKS.format(
      rootfs_partition,
      uuid: configuration["filesystems"]["luks"]["uuid"],
      passphrase: configuration["fde"]["passphrase"]
    )
  end

  puts ""
  puts "Opening LUKS volume..."
  puts ""

  # We don't need to care about the mapper name here; we are not
  # using the NixOS config generator.
  Helpers::LUKS.open(
    rootfs_partition,
    mapper_name,
    passphrase: configuration["fde"]["passphrase"]
  )
  mapper_name = File.join("/dev/mapper", mapper_name)
  puts ":: NOTE: rootfs block device changed from '#{rootfs_partition}' to '#{mapper_name}'"
  rootfs_partition = mapper_name
end

if do_formatting
  puts ""
  puts "Formatting ESP..."
  puts ""

  Helpers::FAT.format(
    esp_partition,
    volume_id: configuration["filesystems"]["boot"]["uuid"],
    label: configuration["filesystems"]["boot"]["label"]
  )

  puts ""
  puts "Formatting rootfs..."
  puts ""

  Helpers::Ext4.format(
    rootfs_partition,
    uuid: configuration["filesystems"]["rootfs"]["uuid"],
    label: configuration["filesystems"]["rootfs"]["label"]
  )
end

Dir.mkdir(MOUNT_POINT) unless Dir.exist?(MOUNT_POINT)
Helpers::Ext4.mount(rootfs_partition, MOUNT_POINT)
boot_mount = File.join(MOUNT_POINT, "boot")
Dir.mkdir(boot_mount) unless Dir.exist?(boot_mount)
Helpers::FAT.mount(esp_partition, boot_mount)
