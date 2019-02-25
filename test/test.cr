require "../src/quartz.cr"

include Quartz

phase = 0.0_f32

cb = ->(input : Void*, output : Void*, frame_count : UInt64, time_info : LibPortAudio::PaStreamCallbackTimeInfo*, status_flags : LibPortAudio::PaStreamCallbackFlags, user_data : Void*) {
  # reinterpret casting
  p = Pointer(Float32).new(user_data.address)
  out_buf = Pointer(Float32).new(output.address)
  delta_p = 2 * Math::PI * 440 / 44100
  (0..frame_count - 1).each do |i|
    out_buf[2*i] = out_buf[2*i + 1] = Math.sin(p.value)
    p.value += delta_p.to_f32
  end
  0
}

stream = AudioStream.new(2, 2, 44100.0, 256_u64)
stream.start(phase) do |input, output, frame_count, time_info, status_flags, user_data|
  # reinterpret casting
  p = Pointer(Float32).new(user_data.address)
  out_buf = Pointer(Float32).new(output.address)
  delta_p = 2 * Math::PI * 440 / 44100
  (0..frame_count - 1).each do |i|
    out_buf[2*i] = out_buf[2*i + 1] = Math.sin(p.value)
    p.value += delta_p.to_f32
  end
  0
end

sleep(1)
puts LibPortAudio.get_stream_cpu_load(stream.ptr)
sleep(1)
puts LibPortAudio.get_stream_cpu_load(stream.ptr)
sleep(1)
puts LibPortAudio.get_stream_cpu_load(stream.ptr)
