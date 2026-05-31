# https://mesonbuild.com/External-Project-module.html

project('ffmpeg', 'c', 'cpp', 'objc')

mod = import('unstable-external_project')

# build binaries
c = meson.get_compiler('c')
cpp = meson.get_compiler('cpp')
objc = meson.get_compiler('objc')
nm = find_program('nm')
ar = find_program('ar')
strip = find_program('strip')
pkg_config = find_program('pkg-config')

# build options
c_args = get_option('c_args')
cpp_args = get_option('cpp_args')
objc_args = get_option('objc_args')
c_link_args = get_option('c_link_args')

# parameters
variant = get_option('variant')
flavor = get_option('flavor')

# options
disable_all_options = [
    '--disable-autodetect',
    '--disable-all',
    '--disable-x86asm',
    '--disable-runtime-cpudetect',
    '--disable-debug',
    '--disable-stripping',
    '--disable-optimizations',
    '--disable-static',
    '--disable-shared',
    '--disable-pthreads',
    '--disable-safe-bitstream-reader',

    '--disable-mbedtls',
    '--disable-gnutls',
    '--disable-openssl',

    '--disable-gpl',
    '--disable-version3',
    '--disable-nonfree',
]

common_options = [
    '--prefix=@PREFIX@',
    '--enable-small', # reduce libs size
    '--enable-optimizations',
    '--enable-shared',
    '--enable-network',
    '--enable-pthreads',
    '--enable-pic',
    '--enable-securetransport',
    '--enable-safe-bitstream-reader',
    '--enable-stripping',
    '--enable-avcodec',
    '--enable-avformat',
    '--enable-swresample',
    '--enable-swscale',
    '--enable-avfilter',
]

audio_common_options = [
    '--enable-zlib', # rasc support
    '--enable-audiotoolbox',
]

# https://github.com/media-kit/libmpv-android-audio-build/blob/260666c0fef8c154971b5faf3f78da27c2bf2c40/buildscripts/flavors/default.sh
audio_default_options = [
    # decoders
    '--enable-decoder=aac*',
    '--enable-decoder=ac3',
    '--enable-decoder=alac',
    '--enable-decoder=als',
    '--enable-decoder=ape',
    '--enable-decoder=atrac*',
    '--enable-decoder=eac3',
    '--enable-decoder=flac',
    '--enable-decoder=gsm*',
    '--enable-decoder=mp1*',
    '--enable-decoder=mp2*',
    '--enable-decoder=mp3*',
    '--enable-decoder=mpc*',
    '--enable-decoder=opus',
    '--enable-decoder=ra*',
    '--enable-decoder=ralf',
    '--enable-decoder=shorten',
    '--enable-decoder=tak',
    '--enable-decoder=tta',
    '--enable-decoder=vorbis',
    '--enable-decoder=wavpack',
    '--enable-decoder=wma*',
    '--enable-decoder=pcm*',
    '--enable-decoder=dsd*',
    '--enable-decoder=dca', # required by dts

    # parsers   
    '--enable-parser=aac*',
    '--enable-parser=ac3',
    '--enable-parser=cook',
    '--enable-parser=dca',
    '--enable-parser=flac',
    '--enable-parser=gsm',
    '--enable-parser=mpegaudio',
    '--enable-parser=tak',
    '--enable-parser=vorbis',

    # demuxers
    '--enable-demuxer=aac',
    '--enable-demuxer=ac3',
    '--enable-demuxer=aiff',
    '--enable-demuxer=ape',
    '--enable-demuxer=asf',
    '--enable-demuxer=au',
    '--enable-demuxer=avi',
    '--enable-demuxer=flac',
    '--enable-demuxer=flv',
    '--enable-demuxer=matroska',
    '--enable-demuxer=mov',
    '--enable-demuxer=m4v',
    '--enable-demuxer=mp3',
    '--enable-demuxer=mpc*',
    '--enable-demuxer=ogg',
    '--enable-demuxer=pcm*',
    '--enable-demuxer=rm',
    '--enable-demuxer=shorten',
    '--enable-demuxer=tak',
    '--enable-demuxer=tta',
    '--enable-demuxer=wav',
    '--enable-demuxer=wv',
    '--enable-demuxer=xwma',
    '--enable-demuxer=dsf',
    '--enable-demuxer=dts',
    '--enable-demuxer=truehd',

    # protocols
    '--enable-protocol=async',
    '--enable-protocol=cache',
    '--enable-protocol=crypto',
    '--enable-protocol=data',
    '--enable-protocol=ffrtmphttp',
    '--enable-protocol=file',
    '--enable-protocol=ftp',
    '--enable-protocol=hls',
    '--enable-protocol=http',
    '--enable-protocol=httpproxy',
    '--enable-protocol=https',
    '--enable-protocol=pipe',
    '--enable-protocol=rtmp',
    '--enable-protocol=rtmps',
    '--enable-protocol=rtmpt',
    '--enable-protocol=rtmpts',
    '--enable-protocol=rtp',
    '--enable-protocol=subfile',
    '--enable-protocol=tcp',
    '--enable-protocol=tls',
    # '--enable-protocol=srt', # WARNING: Option --enable-protocol=srt did not match anything

    # filters
    '--enable-filter=overlay',
    '--enable-filter=equalizer',
    '--enable-filter=superequalizer',
    '--enable-filter=aresample',
    '--enable-filter=aformat',
    '--enable-filter=volume',
    '--enable-filter=anull'
]


# disable all option
options = disable_all_options

# common
options += common_options
options += audio_common_options

# components
if flavor == 'default'
    options += audio_default_options
endif

p = mod.add_project('configure',
    configure_options : options,
    cross_configure_options: [
        '--enable-cross-compile',
        '--target-os=@0@'.format(host_machine.system()),
        '--arch=@0@'.format(host_machine.cpu_family()),

        '--nm=@0@'.format(nm.path()),
        '--ar=@0@'.format(ar.path()),
        '--as=@0@'.format(''.join(c.cmd_array())),
        '--strip=@0@'.format(strip.path()),
        '--cc=@0@'.format(''.join(c.cmd_array())),
        '--cxx=@0@'.format(''.join(cpp.cmd_array())),
        '--objcc=@0@'.format(''.join(objc.cmd_array())),
        '--ld=@0@'.format(''.join(c.cmd_array())),
        '--pkg-config=@0@'.format(pkg_config.path()),

        '--host-cc=@0@'.format(''.join(c.cmd_array())),
        '--host-ld=@0@'.format(''.join(c.cmd_array())),

        '--extra-cflags=@0@'.format(' '.join(c_args)),
        '--extra-cxxflags=@0@'.format(' '.join(cpp_args)),
        '--extra-objcflags=@0@'.format(' '.join(objc_args)),
        '--extra-ldflags=@0@'.format(' '.join(c_link_args)),
    ],
    verbose: true,
)

libavfilter_dep = p.dependency('avfilter')
libswscale_dep = p.dependency('swscale')
libavcodec_dep = p.dependency('avcodec')
libavformat_dep = p.dependency('avformat')
libavutil_dep = p.dependency('avutil')
libswresample_dep = p.dependency('swresample')

meson.override_dependency('libavfilter', libavfilter_dep)
meson.override_dependency('libswscale', libswscale_dep)
meson.override_dependency('libavcodec', libavcodec_dep)
meson.override_dependency('libavformat', libavformat_dep)
meson.override_dependency('libavutil', libavutil_dep)
meson.override_dependency('libswresample', libswresample_dep)
