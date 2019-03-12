require "file_utils"

CL = "crystal"
CLFLAGS = ""

PA_VERSION = "stable_v190600_20161030"

DEP_DIR = "dep"
BIN_DIR = "bin"
SRC_DEP = "src"

JOB_STR_MAX = 50

def job(name, &block)
  STDOUT << name << " " * (JOB_STR_MAX - name.size)
  STDOUT.flush
  result = yield
  if result
    STDOUT << "[OK]\n"
  else
    STDOUT << "[FAILD]\n"
    STDERR << "FAILD: \"#{name}\" is failed"
  end
end


def dependencies
  # check if libportaudio.so already exists.
  if File.exists?(DEP_DIR+"/libportaudio.so")
    puts "SUCCESS: libportaudio.so already exists."
    return true
  end

  job("mkdir -p #{DEP_DIR}") do
    FileUtils.mkdir_p(DEP_DIR)
    true
  end

  job("downloading PortAudio library") do
    st = Process.run(command: "curl", args: ["-o", "#{DEP_DIR}/libportaudio.tgz", "http://www.portaudio.com/archives/pa_#{PA_VERSION}.tgz"])
    st.success?
  end
  
  job("tar libportaudio.tgz") do
    st = Process.run(command: "tar", args: ["-xzvf", "#{DEP_DIR}/libportaudio.tgz", "-C", DEP_DIR])
    st.success?
  end

  FileUtils.cd(DEP_DIR+"/portaudio") do
    job("configure to build PortAudio") do
      st = Process.run("./configure")
      st.success?
    end

    job("make PortAudio") do
      st = Process.run("make")
      st.success?
    end
  end

  job("copying .so") do
    FileUtils.cp(DEP_DIR+"/portaudio/lib/.libs/libportaudio.so", DEP_DIR)
    true
  end

  job("cleaning build files") do
    FileUtils.rm(DEP_DIR+"/libportaudio.tgz")
    FileUtils.rm_r(DEP_DIR+"/portaudio")
    true
  end

  puts "SUCESS: finish installing PortAudio"
end

dependencies()