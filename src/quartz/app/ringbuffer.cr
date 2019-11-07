require "../core/libportaudio.cr"

module Quartz
  class RingBuffer(T)
    def initialize(@buf : Pointer(LibPortAudio::PaUtilRingBuffer), size : Int64, @data_ptr : Pointer(T))
      LibPortAudio.initialize_ring_buffer(@buf, sizeof(T), size, @data_ptr)
    end

    def initialize(size : Int64)
      @buf = Pointer(LibPortAudio::PaUtilRingBuffer).malloc
      @data_ptr = Pointer(T).malloc(size)
      initialize(@buf, size, @data_ptr)
    end

    def write(value : T)
      LibPortAudio.write_ring_buffer(@buf, pointerof(value), 1)
    end

    def write(values : Array(T))
      LibPortAudio.write_ring_buffer(@buf, values.to_unsafe, values.size)
    end

    def read
      value = Pointer(T).malloc(1)
      LibPortAudio.read_ring_buffer(@buf, value, 1)
      value.value
    end

    def read(size : Int)
      value = Pointer(T).malloc(size)
      LibPortAudio.read_ring_buffer(@buf, value, size)
      value.to_slice(size)
    end

    def readall
      num_read = LibPortAudio.get_ring_buffer_read_available(@buf)
      values = Pointer(T).malloc(num_read)
      LibPortAudio.read_ring_buffer(@buf, values, num_read)
      values.to_slice(num_read)
    end

    def size
      @buf.value.buffer_size
    end
  end
end
