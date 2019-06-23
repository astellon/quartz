require "../../../src/quartz.cr" # for debug
# require "quartz"

class CallBacker < Quartz::AbstractAudioApp
  property phase = 0.0_f32

  def process(input, output, nframe)
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

stream = Quartz::AudioStream(Float32).new(2, 2, 44100.0, 256_u64, true)
stream.start(callbacker)

(0..5).each do |_|
  sleep(1)
  puts("#{stream.cpu_load*100} %")
end
