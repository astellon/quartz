module Quartz
  # Initialize Quartz module.
  #
  # Quartz is **AUTOMATICALLY** initialized when you include this module, so you don't need to call this.
  def self.init
    Suppressor.suppress Process::ORIGINAL_STDERR, LibPortAudio.init
    at_exit { LibPortAudio.terminate }
  end

  # Print out the version of internal PortAudio library.
  def self.pa_version(io = STDOUT)
    io.puts String.new(LibPortAudio.get_version_text)
  end

  # exec PortAudio function and handle PaError.
  #
  # Use for functions that return PaError.
  macro except(code)
    ( errno = {{code}} ) < 0 ? raise String.new(LibPortAudio.get_error_text(errno)) : errno
  end

  # type to pa format
  #
  # ```
  # format(Int32) # => 2
  # ```
  macro format(type)
    LibPortAudio::Pa{{type}}
  end
end
