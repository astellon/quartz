require "../src/quartz.cr"

include Quartz

Quartz.init

puts Quartz.pa_version
puts Device.devices.each { |dev| puts dev }
