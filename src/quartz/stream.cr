module Quartz
  # Audio Stream class for sound IO.
  class AudioStream(T)
    getter ptr : Pointer(Void)
    getter input_device : Int32
    getter output_device : Int32
    getter input : Int32
    getter output : Int32
    getter sample_rate : Float64
    getter size : UInt64

    # Open default device
    def initialize(input, output, sample_rate, size)
      indev = LibPortAudio.get_default_input_device
      outdev = LibPortAudio.get_default_output_device
      initialize(indev, input, outdev, output, sample_rate, size)
    end

    # Open given device
    def initialize(@input_device, @input, @output_device, @output, @sample_rate, @size)
      @ptr = Pointer(LibPortAudio::PaStream).malloc(0)
    end

    # Start this stream by using Proc
    def start(callback : (Void*, Void*, UInt64, LibPortAudio::PaStreamCallbackTimeInfo*, LibPortAudio::PaStreamCallbackFlags, Void*) -> Int32, user_data)
      input_parameter = LibPortAudio::PaStreamParameters.new(
        device: @input_device,
        channel_count: @input,
        sample_format: format(T),
        suggested_laency: 0.0,
        host_api_specific_stream_info: Pointer(Void).null
      )

      output_parameter = LibPortAudio::PaStreamParameters.new(
        device: @output_device,
        channel_count: @output,
        sample_format: format(T),
        suggested_laency: 0.0,
        host_api_specific_stream_info: Pointer(Void).null
      )
      
      ptrptr = pointerof(@ptr)
      @boxed = Box.box(user_data)
      except LibPortAudio.open_stream(ptrptr, pointerof(input_parameter), pointerof(output_parameter), @sample_rate, @size, LibPortAudio::PaNoFlag, callback, @boxed)
      except LibPortAudio.start_stream(@ptr)
    end

    # Start this stream by using block
    def start(user_data, &block : (Void*, Void*, UInt64, LibPortAudio::PaStreamCallbackTimeInfo*, LibPortAudio::PaStreamCallbackFlags, Void*) -> Int32)
      callback = block
      start(callback, user_data)
    end

    # Start this stream by using class `T` that has `T#callback`
    def start(callbacker : U) forall U
      cb = ->(input : Void*, output : Void*, frame_count : UInt64, time_info : LibPortAudio::PaStreamCallbackTimeInfo*, status_flags : LibPortAudio::PaStreamCallbackFlags, user_data : Void*) {
        p = Box(U).unbox(user_data)
        in_buf = input.as(Pointer(T))
        out_buf = output.as(Pointer(T))
        p.callback(in_buf, out_buf, frame_count)
        0
      }
      start(cb, callbacker)
    end

    def stop
      except LibPortAudio.stop_stream @ptr
    end

    def cpu_load
      LibPortAudio.get_stream_cpu_load @ptr
    end

    def is_stopped?
      errno = except LibPortAudio.is_stream_stopped @ptr
      return errno == 1
    end

    def is_active?
      errno = except LibPortAudio.is_stream_active @ptr
      return errno == 1
    end

    def inspect(io : IO)
      to_s(io)
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
