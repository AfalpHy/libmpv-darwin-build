final: prev: {
  darwin = prev.darwin.overrideScope (final: prev: {
    xcode_12_3 = prev.xcode_12_3.overrideAttrs (_: {
      outputHash = "sha256-CYU2fAeT+DWiK/mpRoGv57RjGfseL23BDU57SokPjk8=";
    });

    xcode = final.xcode_12_3;
  });
}