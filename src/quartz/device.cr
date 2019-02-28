module Quartz
  class Device
    def initialize(@index : LibPortAudio::PaDeviceIndex)
      @device = LibPortAudio.get_device_info(index)
      @name = String.new @device.value.name
      @host = @device.value.host_api.as(Int32)
      @input = @device.value.max_input_channels.as(Int32)
      @output = @device.value.max_output_channels.as(Int32)
      @sample_rate = @device.value.default_sample_rate.as(Float64)
    end

    # return the number of the audio devices
    def self.ndevices
      LibPortAudio.get_device_count
    end

    # return an array of the audio devices
    def self.devices
      devices = Array(LibPortAudio::PaDeviceInfo).new
      (0..ndevices - 1).map { |dev| Device.new(dev) }
    end

    # return the index of default input device
    def self.default_input
      Device.new LibPortAudio.get_default_input_device
    end

    # return the index of default output device
    def self.default_output
      Device.new LibPortAudio.get_default_output_device
    end

    def inspect(io : IO)
      to_s()
    end

    def to_s(io : IO)
      io << "[" << @index << "] "
      io << @name << ", "
      io << @host << ", "
      io << "(" << @input << ", " << @output << "), "
      io << "@ " << @sample_rate
    end
  end
end
