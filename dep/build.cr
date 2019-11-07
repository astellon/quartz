PA_VERSION    = "v190600"
PA_BUILT_DATE = "20161030"

TAR_NAME = "pa_stable_#{PA_VERSION}_#{PA_BUILT_DATE}.tgz"

Process.run(
  "curl",
  ["-sSOL", "http://www.portaudio.com/archives/#{TAR_NAME}"],
)

Process.run("tar", ["-xvf", TAR_NAME])

Dir.cd("portaudio") do
  Process.run("./configure")
  Process.run("make")
end

Process.run(
  "cp",
  [File.join(Dir.current, "portaudio", "lib", ".libs", "libportaudio.a"),
   File.join(Dir.current)]
)

Process.run("rm", ["-f", TAR_NAME])
Process.run("rm", ["-rf", File.join(Dir.current, "portaudio")])

libportaudio = File.join(Dir.current, "libportaudio.a")

puts("libportaudio was successfully installed.")
puts("==> #{libportaudio}")

File.open("dep.cr", "w") do |file|
  file.puts "module Quartz"
  file.puts %(  LIBPORTAUDIO_PATH = "#{libportaudio}")
  file.puts "end"
end
