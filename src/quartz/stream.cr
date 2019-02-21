module Quartz
  class AudioStream
    property input : Int32
    property output : Int32
    property sample_rate : Float64
    property size : UInt64

    def initialize(@input, @output, @sample_rate, @size)
      @stream = Pointer(LibPortAudio::PaStream).malloc(0)
    end

    def start(callback : (Void*, Void*, UInt64, LibPortAudio::PaStreamCallbackTimeInfo*, LibPortAudio::PaStreamCallbackFlags, Void*)->Int32, user_data)
      ptr = pointerof(@stream)
      @boxed = Box.box(user_data)
      errno = LibPortAudio.open_default_stream(ptr, @input, @output, format(Float32), sample_rate, @size, callback, @boxed)
      handle_error(errno)
      errno = LibPortAudio.start_stream(@stream)
      handle_error(errno)
    end
  end
end
