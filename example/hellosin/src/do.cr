require "../../../src/quartz.cr" # for debug
# require "quartz"

p LibPortAudio::PaErrorCode::PaInvalidDevice.to_i

phase = 0.0_f32

stream = Quartz::AudioStream(Float32).new(2, 2, 44100.0, 256_u64, true)
stream.start(phase) do |input, output, frame_count, time_info, status_flags, user_data|
  # reinterpret casting
  p = user_data.as(Pointer(Float32))
  out_buf = output.as(Pointer(Float32))
  delta_p = 2 * Math::PI * 440 / 44100
  (0..frame_count - 1).each do |i|
    out_buf[2*i] = out_buf[2*i + 1] = Math.sin(p.value)
    p.value += delta_p.to_f32
  end
  0
end

(0..5).each do |_|
  sleep(1)
  puts("#{stream.cpu_load*100} %")
end
