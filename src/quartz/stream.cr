module Quartz
  class AudioStream
    property ptr : Pointer(Void)
    property input : Int32
    property output : Int32
    property sample_rate : Float64
    property size : UInt64

    def initialize(@input, @output, @sample_rate, @size)
      @ptr = Pointer(LibPortAudio::PaStream).malloc(0)
    end

    def start(callback : (Void*, Void*, UInt64, LibPortAudio::PaStreamCallbackTimeInfo*, LibPortAudio::PaStreamCallbackFlags, Void*)->Int32, user_data)
      ptrptr = pointerof(@ptr)
      @boxed = Box.box(user_data)
      except LibPortAudio.open_default_stream(ptrptr, @input, @output, format(Float32), sample_rate, @size, callback, @boxed)
      except LibPortAudio.start_stream(@ptr)
    end

    def start(user_data, &block : (Void*, Void*, UInt64, LibPortAudio::PaStreamCallbackTimeInfo*, LibPortAudio::PaStreamCallbackFlags, Void*)->Int32)
      callback = block
      ptrptr = pointerof(@ptr)
      @boxed = Box.box(user_data)
      except LibPortAudio.open_default_stream(ptrptr, @input, @output, format(Float32), sample_rate, @size, callback, @boxed)
      except LibPortAudio.start_stream(@ptr)
    end
  end
end
