lib LibC
  fun dup(oldfd : LibC::Int) : LibC::Int
end

module Quartz
  # Output suppressor.
  module Suppressor
    # suppress outputs via file descriptor
    #
    # ```
    # supress STDOUT, puts "suppressed"
    # ```
    macro suppress(io, code)
      # redirecting
      closing = {{io}}.close_on_exec?
      begin
        o, i = IO.pipe
        dup = LibC.dup({{io}}.fd)
        {{io}}.reopen(i)
        {{code}}
        LibC.dup2(dup, {{io}}.fd)
        {{io}}.close_on_exec = closing
  
      # close
      ensure
        o.close if o
        i.flush if i
        i.close if i
      end
    end
  end
end
