module Quartz
  # Return the number of the available sound devices.
  def ndevices
    LibPortAudio.get_device_count
  end

  # Return an array of the available sound devices.
  def devices
    devices = Array(LibPortAudio::PaDeviceInfo).new
    (0..ndevices - 1).map { |dev| Device.new(dev) }
  end

  # Return default input device.
  def default_input
    Device.new LibPortAudio.get_default_input_device
  end

  # Return default output device.
  def default_output
    Device.new LibPortAudio.get_default_output_device
  end

  # Store the information of a sound device.
  class Device
    getter index
    getter name
    getter host
    getter input
    getter output
    getter sample_rate

    # Construct from device index.
    def initialize(@index : LibPortAudio::PaDeviceIndex)
      @device = LibPortAudio.get_device_info(index)
      @name = String.new @device.value.name
      @host = @device.value.host_api.as(Int32)
      @input = @device.value.max_input_channels.as(Int32)
      @output = @device.value.max_output_channels.as(Int32)
      @sample_rate = @device.value.default_sample_rate.as(Float64)
    end

    def inspect(io : IO)
      to_s(io)
    end

    def to_s(io : IO)
      io << "Device<" << @index << ", "
      io << @name << ", "
      io << @host << ", "
      io << @input << ", "
      io << @output << ", "
      io << @sample_rate << ">"
    end
  end
end
