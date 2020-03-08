module Quartz
  # Audio Stream class for sound IO.
  class AudioStream(T)
    getter ptr : Pointer(Void)
    getter input_device : Device
    getter output_device : Device
    getter input : Int32
    getter output : Int32
    getter sample_rate : Float64
    getter size : UInt64

    # Open default device
    def initialize(input, output, sample_rate, size, interleave = false)
      @interleave = interleave
      indev = Quartz.default_input
      outdev = Quartz.default_output
      initialize(indev, input, outdev, output, sample_rate, size, interleave)
    end

    # Open given device
    def initialize(@input_device, @input, @output_device, @output, @sample_rate, @size, @interleave = false)
      @ptr = Pointer(LibPortAudio::PaStream).malloc(0)
    end

    # Start this stream by using Proc
    def start(callback : LibPortAudio::PaStreamCallback, user_data)
      format = @interleave ? PortAudio.format(T) : PortAudio.format(T) | LibPortAudio::PaNonInterleaved

      input_parameter = LibPortAudio::PaStreamParameters.new(
        device: @input_device.index,
        channel_count: @input,
        sample_format: format,
        suggested_laency: 0.0,
        host_api_specific_stream_info: Pointer(Void).null
      )

      output_parameter = LibPortAudio::PaStreamParameters.new(
        device: @output_device.index,
        channel_count: @output,
        sample_format: format,
        suggested_laency: 0.0,
        host_api_specific_stream_info: Pointer(Void).null
      )

      ptrptr = pointerof(@ptr)
      @boxed = Box.box(user_data)

      PortAudio.except LibPortAudio.open_stream(
        ptrptr,
        pointerof(input_parameter),
        pointerof(output_parameter),
        @sample_rate,
        @size,
        LibPortAudio::PaNoFlag,
        callback,
        @boxed
      )
      PortAudio.except LibPortAudio.start_stream(@ptr)
    end

    # Start this stream by using block
    def start(user_data, &block : LibPortAudio::PaStreamCallback)
      callback = block
      self.start(callback, user_data)
    end

    # Start this stream by using class `T` that has `T#callback`
    def start(callbacker : AbstractAudioApp)
      cb = ->(input : Void*, output : Void*, frame_count : UInt64, time_info : LibPortAudio::PaStreamCallbackTimeInfo*, status_flags : LibPortAudio::PaStreamCallbackFlags, user_data : Void*) {
        p = Box(AbstractAudioApp).unbox(user_data)
        in_buf = input.as(Pointer(T))
        out_buf = output.as(Pointer(T))
        p.process(in_buf, out_buf, frame_count)
      }
      self.start(cb, callbacker)
    end

    def stop
      PortAudio.except LibPortAudio.stop_stream @ptr
    end

    def cpu_load
      LibPortAudio.get_stream_cpu_load @ptr
    end

    def is_stopped?
      errno = PortAudio.except LibPortAudio.is_stream_stopped @ptr
      return errno == 1
    end

    def is_active?
      errno = PortAudio.except LibPortAudio.is_stream_active @ptr
      return errno == 1
    end

    def inspect(io : IO)
      self.to_s(io)
    end

    def to_s(io : IO)
      io << "AudioStream<"
      io << @input << ", "
      io << @output << ", "
      io << @sample_rate << ", "
      io << @size
      io << ">"
    end

    def to_unsafe : Pointer(LibPortAudio::PaStream)
      @ptr
    end
  end
end
