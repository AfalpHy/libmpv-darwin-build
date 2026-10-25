{
  pkgs ? import ../../utils/default/pkgs.nix,
  os ? import ../../utils/default/os.nix,
  arch ? pkgs.callPackage ../../utils/default/arch.nix { },
}:

let
  name = "libplacebo";
  packageLock = (import ../../../packages.lock.nix).${name};
  inherit (packageLock) version;

  callPackage = pkgs.lib.callPackageWith { inherit pkgs os arch; };
  nativeFile = callPackage ../../utils/native-file/default.nix { };
  crossFile = callPackage ../../utils/cross-file/default.nix { };

  # The source must be fetched with submodules: the build runs python tools
  # (glsl_preproc) that require the bundled jinja/markupsafe/glad/fast_float
  # in 3rdparty/, which are not part of the auto-generated release archives.
  src = pkgs.fetchFromGitHub {
    inherit (packageLock) owner repo rev sha256;
    fetchSubmodules = true;
  };

  pname = import ../../utils/name/package.nix name;

  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.pkg-config
    pkgs.python3
  ];
in

pkgs.stdenvNoCC.mkDerivation {
  name = "${pname}-${os}-${arch}-${version}";
  pname = pname;
  inherit version src;
  dontUnpack = true;
  enableParallelBuilding = true;
  inherit nativeBuildInputs;
  configurePhase = ''
    meson setup build $src \
      --native-file ${nativeFile} \
      --cross-file ${crossFile} \
      --prefix=$out \
      -Ddefault_library=static \
      -Dvulkan=disabled \
      -Dopengl=disabled \
      -Dshaderc=disabled \
      -Dglslang=disabled \
      -Dlcms=disabled \
      -Ddovi=disabled \
      -Dd3d11=disabled \
      -Dunwind=disabled \
      -Dxxhash=disabled \
      -Ddemos=false \
      -Dtests=false \
      -Dbench=false \
      -Dfuzz=false |
      tee configure.log
  '';
  buildPhase = ''
    meson compile -vC build
  '';
  installPhase = ''
    meson install -C build

    # copy configure.log
    mkdir -p $out/share/libplacebo
    cp configure.log $out/share/libplacebo/
  '';
}
