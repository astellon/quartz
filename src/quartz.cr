require "./quartz/libportaudio.cr"
require "./quartz/stream.cr"
require "./quartz/suppressor.cr"
require "./quartz/device.cr"
require "./quartz/util.cr"

# TODO: Write documentation for `Quarz`
module Quartz
  extend self

  VERSION = "0.1.0"
  
  Quartz.init
end
