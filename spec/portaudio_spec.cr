require "./spec_helper"

describe Quartz do
  describe "PortAudio" do
    it "make_version_number" do
      # this example is given in http://portaudio.com/docs/v19-doxydocs/portaudio_8h.html#a66da08bcf908e0849c62a6b47f50d7b4
      PortAudio.make_version_number(19, 5, 1).should eq 0x00130501
    end

    it "except" do
      PortAudio.except(0) # no error
      expect_raises(Exception) do
        PortAudio.except(-1000)
      end
    end

    it "pa_version" do
      mem = IO::Memory.new
      PortAudio.pa_version(mem)
      mem.to_s.should contain "PortAudio"
      mem.to_s.should contain "V19."
    end
  
    it "format" do
      {% for type in {Float32, Int32, Int16, Int8, UInt8} %}
        PortAudio.format({{type}}).should eq LibPortAudio::Pa{{type}}
      {% end %}
    end
  end
end
