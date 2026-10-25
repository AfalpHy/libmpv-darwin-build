{
  pkgs ? import ../../utils/default/pkgs.nix,
  os ? import ../../utils/default/os.nix,
  arch ? pkgs.callPackage ../../utils/default/arch.nix { },
  variant ? import ../../utils/default/variant.nix,
}:

let
  name = "mpv";
  packageLock = (import ../../../packages.lock.nix).${name};
  inherit (packageLock) version;

  variants = import ../../utils/constants/variants.nix;
  oses = import ../../utils/constants/oses.nix;
  callPackage = pkgs.lib.callPackageWith {
    inherit
      pkgs
      os
      arch
      variant
      ;
  };
  nativeFile = callPackage ../../utils/native-file/default.nix { };
  crossFile = callPackage ../../utils/cross-file/default.nix { };
  xctoolchainLipo = callPackage ../../utils/xctoolchain/lipo.nix { };
  xctoolchainXcrun = callPackage ../../utils/xctoolchain/xcrun.nix { };
  ffmpeg = callPackage ../mk-pkg-ffmpeg/default.nix { };
  libass = callPackage ../mk-pkg-libass/default.nix { };
  libplacebo = callPackage ../mk-pkg-libplacebo/default.nix { };

  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.pkg-config
    pkgs.python3
    xctoolchainLipo
    xctoolchainXcrun
  ];

  pname = import ../../utils/name/package.nix name;
  src = callPackage ../../utils/fetch-tarball/default.nix {
    name = "${pname}-source-${version}";
    inherit (packageLock) url sha256;
  };
  fixedSource = callPackage ../../utils/patch-shebangs/default.nix {
    name = "${pname}-fixed-source-${variant}-${version}";
    inherit src;
    inherit nativeBuildInputs;
  };
in

pkgs.stdenvNoCC.mkDerivation {
  name = "${pname}-${os}-${arch}-${variant}-${version}";
  pname = pname;
  inherit version;
  src = fixedSource;
  dontUnpack = true;
  enableParallelBuilding = true;
  inherit nativeBuildInputs;
  buildInputs = [ ffmpeg libass libplacebo ];
  configurePhase = ''
    # mpv locates swiftc via `xcrun -find swiftc`; make sure the real xcrun
    # from the Xcode bundle wins over the xcbuild shim on PATH
    export PATH=${xctoolchainXcrun}/bin:$PATH

    # mpv detects the macOS SDK via TOOLS/macos-sdk-version.py (which prefers
    # these env vars over calling xcrun) and only registers the objc language
    # when the detection succeeds. The cross-file sysroot always takes
    # precedence over the SDK flags mpv appends for iOS targets.
    export MACOS_SDK=${pkgs.darwin.xcode}/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    export MACOS_SDK_VERSION=15.0

    DISABLE_ALL_OPTIONS=(
      `# booleans`
      -Dgpl=false `# GPL (version 2 or later) build`
      -Dcplayer=false `# mpv CLI player`
      -Dlibmpv=false `# libmpv library`
      -Dbuild-date=false `# whether to include binary compile time`
      -Dtests=false `# unit tests (development only)`
      -Dfuzzers=false `# fuzzer binaries`

      `# misc features`
      -Dcdda=disabled `# cdda support (libcdio)`
      -Dcplugins=disabled `# C plugins`
      -Ddvbin=disabled `# DVB input module`
      -Ddvdnav=disabled `# dvdnav support`
      -Diconv=disabled `# iconv`
      -Djavascript=disabled `# Javascript (MuJS backend)`
      -Djpeg=disabled `# libjpeg image writer`
      -Dlcms2=disabled `# LCMS2 support`
      -Dlibarchive=disabled `# libarchive wrapper for reading zip files and more`
      -Dlibavdevice=disabled `# libavdevice`
      -Dlibbluray=disabled `# Bluray support`
      -Dlua=disabled `# Lua`
      -Dpthread-debug=disabled `# pthread runtime debugging wrappers`
      -Drubberband=disabled `# librubberband support`
      -Dsdl2-gamepad=disabled `# SDL2 gamepad input`
      -Duchardet=disabled `# uchardet support`
      -Duwp=disabled `# Universal Windows Platform`
      -Dvapoursynth=disabled `# VapourSynth filter bridge`
      -Dvector=disabled `# GCC vector instructions`
      -Dwin32-threads=disabled `# win32 native threading`
      -Dx11-clipboard=disabled `# X11 clipboard backend`
      -Dzimg=disabled `# libzimg support (high quality software scaler)`
      -Dzlib=disabled `# zlib`

      `# audio output features`
      -Dalsa=disabled `# ALSA audio output`
      -Daudiounit=disabled `# AudioUnit output for iOS`
      -Dcoreaudio=disabled `# CoreAudio audio output`
      -Davfoundation=disabled `# AVFoundation audio output`
      -Djack=disabled `# JACK audio output`
      -Dopenal=disabled `# OpenAL audio output`
      -Daudiotrack=disabled `# Android AudioTrack audio output`
      -Daaudio=disabled `# Android AAudio audio output`
      -Dopensles=disabled `# OpenSL ES audio output`
      -Doss-audio=disabled `# OSSv4 audio output`
      -Dpipewire=disabled `# PipeWire audio output`
      -Dpulse=disabled `# PulseAudio audio output`
      -Dsdl2-audio=disabled `# SDL2 audio output`
      -Dsndio=disabled `# sndio audio output`
      -Dwasapi=disabled `# WASAPI audio output`

      `# video output features`
      -Dcaca=disabled `# CACA`
      -Dcocoa=disabled `# Cocoa`
      -Dd3d11=disabled `# Direct3D 11 video output`
      -Ddirect3d=disabled `# Direct3D support`
      -Ddmabuf-wayland=disabled `# dmabuf-wayland video output`
      -Ddrm=disabled `# DRM`
      -Degl=disabled `# EGL 1.4`
      -Degl-android=disabled `# Android EGL support`
      -Degl-angle=disabled `# OpenGL ANGLE headers`
      -Degl-angle-lib=disabled `# OpenGL Win32 ANGLE library`
      -Degl-angle-win32=disabled `# OpenGL Win32 ANGLE Backend`
      -Degl-drm=disabled `# OpenGL DRM EGL Backend`
      -Degl-wayland=disabled `# OpenGL Wayland Backend`
      -Degl-x11=disabled `# OpenGL X11 EGL Backend`
      -Dgbm=disabled `# GBM`
      -Dgl=disabled `# OpenGL context support`
      -Dgl-cocoa=disabled `# gl-cocoa`
      -Dgl-dxinterop=disabled `# OpenGL/DirectX Interop Backend`
      -Dgl-win32=disabled `# OpenGL Win32 Backend`
      -Dgl-x11=disabled `# OpenGL X11/GLX (deprecated/legacy)`
      -Dsdl2-video=disabled `# SDL2 video output`
      -Dshaderc=disabled `# libshaderc SPIR-V compiler`
      -Dsixel=disabled `# Sixel`
      -Dspirv-cross=disabled `# SPIRV-Cross SPIR-V shader converter`
      -Dplain-gl=disabled `# OpenGL without platform-specific code (e.g. for libmpv)`
      -Dvdpau=disabled `# VDPAU acceleration`
      -Dvdpau-gl-x11=disabled `# VDPAU with OpenGl/X11`
      -Dvaapi=disabled `# VAAPI acceleration`
      -Dvaapi-drm=disabled `# VAAPI (DRM/EGL support)`
      -Dvaapi-wayland=disabled `# VAAPI (Wayland support)`
      -Dvaapi-win32=disabled `# VAAPI (Windows support)`
      -Dvaapi-x11=disabled `# VAAPI (X11 support)`
      -Dvulkan=disabled `# Vulkan context support`
      -Dwayland=disabled `# Wayland`
      -Dx11=disabled `# X11`
      -Dxv=disabled `# Xv video output`

      `# hwaccel features`
      -Dandroid-media-ndk=disabled `# Android Media APIs`
      -Dcuda-hwaccel=disabled `# CUDA acceleration`
      -Dcuda-interop=disabled `# CUDA with graphics interop`
      -Dd3d-hwaccel=disabled `# D3D11VA hwaccel`
      -Dd3d9-hwaccel=disabled `# DXVA2 hwaccel`
      -Dgl-dxinterop-d3d9=disabled `# OpenGL/DirectX Interop Backend DXVA2 interop`
      -Dios-gl=disabled `# iOS OpenGL ES hardware decoding interop support`
      -Dvideotoolbox-gl=disabled `# Videotoolbox with OpenGL`
      -Dvideotoolbox-pl=disabled `# Videotoolbox with libplacebo`

      `# macOS features`
      -Dmacos-10-15-4-features=disabled `# macOS 10.15.4 SDK Features`
      -Dmacos-11-features=disabled `# macOS 11 SDK Features`
      -Dmacos-11-3-features=disabled `# macOS 11.3 SDK Features`
      -Dmacos-12-features=disabled `# macOS 12 SDK Features`
      -Dmacos-cocoa-cb=disabled `# macOS libmpv backend`
      -Dmacos-media-player=disabled `# macOS Media Player support`
      -Dmacos-touchbar=disabled `# macOS Touch Bar support`
      `# NOTE: swift-build stays auto: with cocoa enabled it is required,`
      `# since player/clipboard/clipboard-mac.m includes the swift-generated`
      `# osdep/mac/swift.h. It is auto-disabled for iOS targets (no cocoa).`

      `# Windows features`
      -Dwin32-smtc=disabled `# Windows Media Control support`

      `# manpages`
      -Dhtml-build=disabled `# html manual generation`
      -Dmanpage-build=disabled `# manpage generation`
      -Dpdf-build=disabled `# pdf manual generation`
    )

    COMMON_OPTIONS=(
      `# booleans`
      -Dlibmpv=true `# libmpv library`
      -Dbuild-date=true `# whether to include binary compile time`

      `# misc features`
      -Diconv=enabled `# iconv`
    )

    MACOS_OPTIONS=(
      `# audio output features`
      -Dcoreaudio=enabled `# CoreAudio audio output`

      `# video output features`
      -Dcocoa=enabled `# Cocoa` `# BUG: required in audio mode since v0.36.0`

      `# swift`
      `# writable module cache dir for swiftc inside the build environment`
      `# (HOME is not writable there); same workaround as in utils/xctoolchain.`
      `# swiftc has no -mmacosx-version-min flag, so the deployment target is`
      `# set via an explicit -target triple (clamped by the swift toolchain`
      `# floor, e.g. macOS 11 for Swift 6.4+).`
      '-Dswift-flags=-module-cache-path ./cache -target ${
        if arch == "amd64" then "x86_64-apple-macos13.0" else "arm64-apple-macos13.0"
      }'
    )

    IOS_OPTIONS=(
      `# audio output features`
      -Daudiounit=enabled `# AudioUnit output for iOS`
    )

    OPTIONS=("''${DISABLE_ALL_OPTIONS[@]}")

    OPTIONS+=("''${COMMON_OPTIONS[@]}")

    if [ "${os}" == "${oses.macos}" ]; then
      OPTIONS+=("''${MACOS_OPTIONS[@]}")
    elif [ "${os}" == "${oses.ios}" ]; then
      OPTIONS+=("''${IOS_OPTIONS[@]}")
    fi

    meson setup build $src \
      --native-file ${nativeFile} \
      --cross-file ${crossFile} \
      --prefix=$out \
      "''${OPTIONS[@]}" |
      tee configure.log
  '';
  buildPhase = ''
    meson compile -vC build
  '';
  installPhase = ''
    meson install -C build

    # copy configure.log
    mkdir -p $out/share/mpv
    cp configure.log $out/share/mpv/
  '';
}
