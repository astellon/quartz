require "./spec_helper"

describe Quartz do
  it "init" do
    Quartz.init
  end

  it "pa_version" do
    mem = IO::Memory.new
    Quartz.pa_version(mem)
    mem.to_s.should contain "PortAudio"
    mem.to_s.should contain "V19."
  end

  it "format" do
    {% for type in {Float32, Int32, Int16, Int8, UInt8} %}
      Quartz.format({{type}}).should eq LibPortAudio::Pa{{type}}
    {% end %}
  end
end
