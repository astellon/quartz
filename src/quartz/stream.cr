module Quartz
  # Audio Stream class for sound IO.
  class AudioStream
    getter ptr : Pointer(Void)
    getter input : Int32
    getter output : Int32
    getter sample_rate : Float64
    getter size : UInt64

    def initialize(@input, @output, @sample_rate, @size)
      @ptr = Pointer(LibPortAudio::PaStream).malloc(0)
    end

    # Start this stream by using Proc
    def start(callback : (Void*, Void*, UInt64, LibPortAudio::PaStreamCallbackTimeInfo*, LibPortAudio::PaStreamCallbackFlags, Void*) -> Int32, user_data)
      ptrptr = pointerof(@ptr)
      @boxed = Box.box(user_data)
      except LibPortAudio.open_default_stream(ptrptr, @input, @output, format(Float32), sample_rate, @size, callback, @boxed)
      except LibPortAudio.start_stream(@ptr)
    end

    # Start this stream by using block
    def start(user_data, &block : (Void*, Void*, UInt64, LibPortAudio::PaStreamCallbackTimeInfo*, LibPortAudio::PaStreamCallbackFlags, Void*) -> Int32)
      callback = block
      start(callback, user_data)
    end

    # Start this stream by using class `T` that has `T#callback`
    def start(callbacker : T) forall T
      cb = ->(input : Void*, output : Void*, frame_count : UInt64, time_info : LibPortAudio::PaStreamCallbackTimeInfo*, status_flags : LibPortAudio::PaStreamCallbackFlags, user_data : Void*) {
        p = Box(T).unbox(user_data)
        in_buf = Pointer(Float32).new(input.address)
        out_buf = Pointer(Float32).new(output.address)
        p.callback(in_buf, out_buf, frame_count)
        0
      }
      start(cb, callbacker)
    end

    def stop
      except LibPortAudio.StopStream @ptr
    end

    def cpu_load
      LibPortAudio.get_stream_cpu_load @ptr
    end

    def is_stopped
      errno = except LibPortAudio.is_stream_stopped @ptr
      return errno == 1
    end

    def is_active
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
      io << @size << ", "
      io << cpu_load * 100 << "%, "
      io << (is_active ? "active" : (is_stopped ? "stopped" : "not start"))
      io << ">"
    end

    def to_unsafe : Pointer(LibPortAudio::PaStream)
      @ptr
    end
  end
end
