require "../../../src/quartz.cr" # for debug
# require "quartz"

phase = 0.0_f32

cb = ->(input : Void*, output : Void*, frame_count : UInt64, time_info : LibPortAudio::PaStreamCallbackTimeInfo*, status_flags : LibPortAudio::PaStreamCallbackFlags, user_data : Void*) {
  # reinterpret casting
  p = user_data.as(Pointer(Float32))
  out_buf = output.as(Pointer(Float32))
  delta_p = 2 * Math::PI * 440 / 44100
  (0..frame_count - 1).each do |i|
    out_buf[2*i] = out_buf[2*i + 1] = Math.sin(p.value)
    p.value += delta_p.to_f32
  end
  0
}

stream = Quartz::AudioStream(Float32).new(2, 2, 44100.0, 256_u64, true)
stream.start(cb, phase)

(0..5).each do |_|
  sleep(1)
  puts("#{stream.cpu_load*100} %")
end
