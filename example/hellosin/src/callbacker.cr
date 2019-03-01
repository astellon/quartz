require "Quartz"

include Quartz

class CallBacker
  property phase = 0.0_f32

  def callback(input, output, nframe)
    delta_p = 2 * Math::PI * 440 / 44100
    (0..nframe - 1).each do |i|
      output[2*i] = output[2*i + 1] = Math.sin(@phase)
      @phase += delta_p.to_f32
    end
    @phase.modulo(2 * Math::PI)
    return 0
  end
end

phase = 0.0_f32
callbacker = CallBacker.new

stream = AudioStream.new(2, 2, 44100.0, 256_u64)
stream.start(callbacker)

(0..5).each do |_|
  puts stream.cpu_load
  puts stream.is_stopped
  sleep(1)
end
