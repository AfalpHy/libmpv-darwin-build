{
  ffmpeg = {
    version = "8.1.3";
    url = "https://ffmpeg.org/releases/ffmpeg-8.1.3.tar.xz";
    sha256 = "7138d28c96d9d3e3af4ee3d8cad72741f8ffb40da90c1112235dea3ecd3178a3";
  };
  freetype = {
    version = "2.13.2";
    url = "https://downloads.sourceforge.net/project/freetype/freetype2/2.13.2/freetype-2.13.2.tar.xz";
    sha256 = "12991c4e55c506dd7f9b765933e62fd2be2e06d421505d7950a132e4f1bb484d";
  };
  fribidi = {
    version = "1.0.13";
    url = "https://github.com/fribidi/fribidi/releases/download/v1.0.13/fribidi-1.0.13.tar.xz";
    sha256 = "7fa16c80c81bd622f7b198d31356da139cc318a63fc7761217af4130903f54a2";
  };
  harfbuzz = {
    version = "12.3.2";
    url = "https://github.com/harfbuzz/harfbuzz/releases/download/12.3.2/harfbuzz-12.3.2.tar.xz";
    sha256 = "6f6db164359a2da5a84ef826615b448b33e6306067ad829d85d5b0bf936f1bb8";
  };
  libass = {
    version = "0.17.1";
    url = "https://github.com/libass/libass/releases/download/0.17.1/libass-0.17.1.tar.xz";
    sha256 = "f0da0bbfba476c16ae3e1cfd862256d30915911f7abaa1b16ce62ee653192784";
  };
  libogg = {
    version = "1.3.5";
    url = "https://github.com/xiph/ogg/releases/download/v1.3.5/libogg-1.3.5.tar.gz";
    sha256 = "0eb4b4b9420a0f51db142ba3f9c64b333f826532dc0f48c6410ae51f4799b664";
  };
  libvorbis = {
    version = "1.3.7";
    url = "https://github.com/xiph/vorbis/releases/download/v1.3.7/libvorbis-1.3.7.tar.gz";
    sha256 = "0e982409a9c3fc82ee06e08205b1355e5c6aa4c36bca58146ef399621b0ce5ab";
  };
  libplacebo = {
    # Fetched with submodules: the build runs python tools (glsl_preproc) that
    # require the bundled jinja/markupsafe/glad/fast_float in 3rdparty/
    version = "7.360.1";
    owner = "haasn";
    repo = "libplacebo";
    rev = "v7.360.1";
    # NAR hash of the full checkout including submodules (fetchFromGitHub with fetchSubmodules)
    sha256 = "sha256-2F3eUKjvAveahvqKuJFwHvIem9g156hCeKbeYBPovLk=";
  };
  mpv = {
    version = "0.41.0";
    url = "https://github.com/mpv-player/mpv/archive/refs/tags/v0.41.0.tar.gz";
    sha256 = "ee21092a5ee427353392360929dc64645c54479aefdb5babc5cfbb5fad626209";
  };
}
