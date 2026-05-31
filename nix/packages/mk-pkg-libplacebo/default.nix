{
  pkgs ? import ../../utils/default/pkgs.nix,
  os ? import ../../utils/default/os.nix,
  arch ? pkgs.callPackage ../../utils/default/arch.nix { },
}:

let
  name = "libplacebo";

  version = "7.360.1";

  callPackage = pkgs.lib.callPackageWith { inherit pkgs os arch; };
  nativeFile = callPackage ../../utils/native-file/default.nix { };
  crossFile = callPackage ../../utils/cross-file/default.nix { };

  pname = import ../../utils/name/package.nix name;

  src = pkgs.fetchFromGitHub {
    owner = "haasn";
    repo = "libplacebo";
    rev = "v${version}";
    sha256 = "sha256-2F3eUKjvAveahvqKuJFwHvIem9g156hCeKbeYBPovLk=";
    fetchSubmodules = true;
  };
in

pkgs.stdenvNoCC.mkDerivation {
  name = "${pname}-${os}-${arch}-${version}";
  pname = pname;
  inherit version src;

  nativeBuildInputs = [
    pkgs.meson
    pkgs.ninja
    pkgs.pkg-config
  ];

  configurePhase = ''
    meson setup build . \
      --native-file ${nativeFile} \
      --cross-file ${crossFile} \
      --prefix=$out \
      -Ddefault_library=static \
      -Dvulkan=disabled \
      -Dopengl=disabled \
      -Dshaderc=disabled \
      -Dlcms=disabled \
      -Ddemos=false \
      -Dglslang=disabled \
      -Dxxhash=disabled \
      | tee configure.log
  '';

  buildPhase = ''
    meson compile -vC build
  '';

  installPhase = ''
    meson install -C build
  '';
}