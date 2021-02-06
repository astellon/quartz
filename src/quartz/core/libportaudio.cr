@[Link(ldflags: "#{__DIR__}/../../../dep/libportaudio.a -lrt -lm -lasound -ljack -pthread")]
lib LibPortAudio
  # api data structures
  struct PaVersionInfo
    version_major : Int32
    version_minor : Int32
    version_sub_minor : Int32
    version_control_revision : UInt8*
    version_text : UInt8*
  end

  struct PaHostApiInfo
    struct_version : Int32
    type : PaHostApiTypeId
    name : UInt8*
    device_count : Int32
    default_input_device : PaDeviceIndex
    default_output_device : PaDeviceIndex
  end

  struct PaHostErrorInfo
    host_api_type : PaHostApiTypeId
    error_code : Int64
    error_text : UInt8*
  end

  struct PaDeviceInfo
    struct_version : Int32
    name : UInt8*
    host_api : PaHostApiIndex
    max_input_channels : Int32
    max_output_channels : Int32
    default_low_input_latency : PaTime
    default_low_output_latency : PaTime
    default_high_input_latency : PaTime
    default_high_output_latency : PaTime
    default_sample_rate : Float64
  end

  struct PaStreamParameters
    device : PaDeviceIndex
    channel_count : Int32
    sample_format : PaSampleFormat
    suggested_laency : PaTime
    host_api_specific_stream_info : Void*
  end

  struct PaStreamCallbackTimeInfo
    input_buffer_adc_time : PaTime
    current_time : PaTime
    output_buffer_dac_time : PaTime
  end

  struct PaStreamInfo
    struct_version : Int32
    input_latency : PaTime
    output_latency : PaTime
    sample_rate : Float64
  end

  struct PaUtilRingBuffer
    buffer_size : RingBufferSizeT
    write_index : RingBufferSizeT
    read_index : RingBufferSizeT
    big_mask : RingBufferSizeT
    small_mask : RingBufferSizeT
    element_size_byte : RingBufferSizeT
    buffer : Void*
  end

  # api constant values (Macros in C)
  PaNoDevice                              = PaDeviceIndex.new(-1)
  PaUseHostApiSpecificDeviceSpecification = PaDeviceIndex.new(-2)

  PaFloat32        = PaSampleFormat.new(0x00000001)
  PaInt32          = PaSampleFormat.new(0x00000002)
  PaInt24          = PaSampleFormat.new(0x00000004)
  PaInt16          = PaSampleFormat.new(0x00000008)
  PaInt8           = PaSampleFormat.new(0x00000010)
  PaUInt8          = PaSampleFormat.new(0x00000020)
  PaCustomFormat   = PaSampleFormat.new(0x00010000)
  PaNonInterleaved = PaSampleFormat.new(0x80000000)

  PaFormatIsSupported          = 0
  PaFramesPerBufferUnspecified = 0

  PaNoFlag                                = PaStreamFlags.new(0)
  PaClipOff                               = PaStreamFlags.new(0x00000001)
  PaDitherOff                             = PaStreamFlags.new(0x00000002)
  PaNeverDropInput                        = PaStreamFlags.new(0x00000004)
  PaPrimeOutputBuffersUsingStreamCallback = PaStreamFlags.new(0x00000008)
  PaPlatformSpecificFlags                 = PaStreamFlags.new(0xFFFF0000)

  PaInputUnderflow  = PaStreamCallbackFlags.new(0x00000001)
  PaInputOverflow   = PaStreamCallbackFlags.new(0x00000002)
  PaOutputUnderflow = PaStreamCallbackFlags.new(0x00000004)
  PaOutputOverflow  = PaStreamCallbackFlags.new(0x00000008)
  PaPrimingOutput   = PaStreamCallbackFlags.new(0x00000010)

  # api aliases
  alias PaError = Int32
  alias PaDeviceIndex = Int32
  alias PaHostApiIndex = Int32
  alias PaTime = Float64
  alias PaSampleFormat = UInt64
  alias PaStream = Void
  alias PaStreamFlags = UInt64
  alias PaStreamCallbackFlags = UInt64
  alias RingBufferSizeT = Int64

  # C Function pointer is `Proc` in Crystal
  # DO NOT USE `PaStreamCallback*`, USE `PaStreamCallback`
  alias PaStreamCallback = (Void*, Void*, UInt64, PaStreamCallbackTimeInfo*, PaStreamCallbackFlags, Void*) -> Int32
  alias PaStreamFinishedCallback = Void

  # api enums
  enum PaErrorCode
    PaNoError                               =      0
    PaNotInitialized                        = -10000
    PaUnanticipatedHostError
    PaInvalidChannelCount
    PaInvalidSampleRate
    PaInvalidDevice
    PaInvalidFlag
    PaSampleFormatNotSupported
    PaBadIODeviceCombination
    PaInsufficientMemory
    PaBufferTooBig
    PaBufferTooSmall
    PaNullCallback
    PaBadStreamPtr
    PaTimedOut
    PaInternalError
    PaDeviceUnavailable
    PaIncompatibleHostApiSpecificStreamInfo
    PaStreamIsStopped
    PaStreamIsNotStopped
    PaInputOverflowed
    PaOutputUnderflowed
    PaHostApiNotFound
    PaInvalidHostApi
    PaCanNotReadFromACallbackStream
    PaCanNotWriteToACallbackStream
    PaCanNotReadFromAnOutputOnlyStream
    PaCanNotWriteToAnInputOnlyStream
    PaIncompatibleStreamHostApi
    PaBadBufferPtr
  end

  enum PaHostApiTypeId
    PaInDevelopment   =  0
    PaDirectSound     =  1
    PaMME             =  2
    PaASIO            =  3
    PaSoundManager    =  4
    PaCoreAudio       =  5
    PaOSS             =  7
    PaALSA            =  8
    PaAL              =  9
    PaBeOS            = 10
    PaWDMKS           = 11
    PaJACK            = 12
    PaWASAPI          = 13
    PaAudioScienceHPI = 14
  end

  # api functions
  fun get_version = Pa_GetVersion : Int32
  fun get_version_text = Pa_GetVersionText : UInt8*
  fun get_version_info = Pa_GetVersionInfo : PaVersionInfo*
  fun get_error_text = Pa_GetErrorText(error_code : Int32) : UInt8*
  fun init = Pa_Initialize : PaError
  fun terminate = Pa_Terminate : PaError
  fun get_host_api_count = Pa_GetHostApiCount : PaHostApiIndex
  fun get_default_host_api = Pa_GetDefaultHostApi : PaHostApiIndex
  fun get_host_api_info = Pa_GetHostApiInfo(host_api : PaHostApiIndex) : PaHostApiInfo*
  fun host_api_type_id_to_host_api_index = Pa_HostApiTypeIdToHostApiIndex(type : PaHostApiTypeId) : PaHostApiIndex
  fun host_api_device_index_to_device_index = Pa_HostApiDeviceIndexToDeviceIndex(host_api : PaHostApiIndex, host_Api_device_index : Int32) : PaDeviceIndex
  fun get_last_host_error_info = Pa_GetLastHostErrorInfo : PaHostErrorInfo*
  fun get_device_count = Pa_GetDeviceCount : PaDeviceIndex
  fun get_default_input_device = Pa_GetDefaultInputDevice : PaDeviceIndex
  fun get_default_output_device = Pa_GetDefaultOutputDevice : PaDeviceIndex
  fun get_device_info = Pa_GetDeviceInfo(device : PaDeviceIndex) : PaDeviceInfo*
  fun is_format_supported = Pa_IsFormatSupported(input_parameters : PaStreamParameters*, output_parameters : PaStreamParameters*, sample_rate : Float64) : PaError
  fun open_stream = Pa_OpenStream(stream : PaStream**, input_parameters : PaStreamParameters*, output_parameters : PaStreamParameters*, sample_rate : Float64, frames_per_buffer : UInt64, stream_flag : PaStreamFlags, stream_callback : PaStreamCallback, user_data : Void*) : PaError
  fun open_default_stream = Pa_OpenDefaultStream(stream : PaStream**, num_input_channels : Int32, num_output_channels : Int32, sample_format : PaSampleFormat, sample_rate : Float64, frames_per_buffer : UInt64, stream_callback : PaStreamCallback, user_data : Void*) : PaError
  fun cloase_stream = Pa_CloseStream(stream : PaStream*) : PaError
  fun set_stream_finished_callback = Pa_SetStreamFinishedCallback(stream : PaStream*, stream_finished_callback : PaStreamFinishedCallback*) : PaError
  @[Raises] # raises from callback
  fun start_stream = Pa_StartStream(stream : PaStream*) : PaError
  fun stop_stream = Pa_StopStream(stream : PaStream*) : PaError
  fun abort_stream = Pa_AbortStream(stream : PaStream*) : PaError
  fun is_stream_stopped = Pa_IsStreamStopped(stream : PaStream*) : PaError
  fun is_stream_active = Pa_IsStreamActive(stream : PaStream*) : PaError
  fun get_stream_info = Pa_GetStreamInfo(stream : PaStream*) : PaStreamInfo*
  fun get_stream_time = Pa_GetStreamTime(stream : PaStream*) : PaTime
  fun get_stream_cpu_load = Pa_GetStreamCpuLoad(stream : PaStream*) : Float64
  fun read_stream = Pa_ReadStream(stream : PaStream*, buffer : Void*, frames : UInt64) : PaError
  fun write_stream = Pa_WriteStream(stream : PaStream*, buffer : Void*, frames : UInt64) : PaError
  fun get_stream_read_available = Pa_GetStreamReadAvailable(stream : PaStream*) : Int64
  fun get_stream_write_available = Pa_GetStreamWriteAvailable(stream : PaStream*) : Int64
  fun get_sample_size = Pa_GetSampleSize(format : PaSampleFormat) : PaError
  fun sleep = Pa_Sleep(msec : Int64) : Void

  # pa_ringbuffer.h
  fun initialize_ring_buffer = PaUtil_InitializeRingBuffer(rbuf : PaUtilRingBuffer*, element_size_bytes : RingBufferSizeT, element_count : RingBufferSizeT, data_ptr : Void*)
  fun flush_ring_buffer = PaUtil_FlushRingBuffer(rbuf : PaUtilRingBuffer*) : Void
  fun get_ring_buffer_write_available = PaUtil_GetRingBufferWriteAvailable(rbuf : PaUtilRingBuffer*) : RingBufferSizeT
  fun get_ring_buffer_read_available = PaUtil_GetRingBufferReadAvailable(rbuf : PaUtilRingBuffer*) : RingBufferSizeT
  fun write_ring_buffer = PaUtil_WriteRingBuffer(rbuf : PaUtilRingBuffer*, data : Void*, element_count : RingBufferSizeT) : RingBufferSizeT
  fun read_ring_buffer = PaUtil_ReadRingBuffer(rbuf : PaUtilRingBuffer*, data : Void*, element_count : RingBufferSizeT) : RingBufferSizeT
end

module PortAudio
  extend self

  # Make the version hash form numbers
  def self.make_version_number(major, minor, subminor)
    (((major) & 0xFF) << 16 | ((minor) & 0xFF) << 8 | ((subminor) & 0xFF))
  end

  # Print out the version of internal PortAudio library.
  def pa_version(io = STDOUT)
    io.puts String.new(LibPortAudio.get_version_text)
  end

  # Initialize Quartz module.
  #
  # PortAudio context is **AUTOMATICALLY** initialized when you include this module, so you don't need to call this.
  def init
    Quartz::Suppressor.suppress IO::FileDescriptor.new(2, blocking: true), LibPortAudio.init
    at_exit { LibPortAudio.terminate }
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
  {% for type in {UInt8, Int8, Int16, Int32, Float32} %}
  def format(t : {{type}}.class)
    LibPortAudio::Pa{{type}}
  end
  {% end %}

  def format(type)
    raise "Invalid Type for PaFormat"
  end
end
