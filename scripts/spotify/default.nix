{writeScriptBin, ruby, xrandr, spotify, ...} :
( writeScriptBin "spotify" ''
    #!${ruby}/bin/ruby
    res =  %x(xrandr --current).lines.select {|l| l.include? '*'}.first.split('x').first.to_i

    scale_param = nil
    scale_param = "--force-device-scale-factor=2" if res > 2000
    exec "${spotify}/bin/spotify", scale_param.to_s, *ARGV
  ''
)
