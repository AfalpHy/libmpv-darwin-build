{
  pkgs ? import ../default/pkgs.nix,
}:

# mpv locates swiftc by running `xcrun -find swiftc`. Recent Xcode bundles no
# longer ship their own xcrun binary, so this shim resolves developer tools
# directly from the Xcode bundle that the cross-files also point at. Any other
# invocation falls back to the system xcrun.
pkgs.runCommand "mk-xctoolchain-xcrun" { } ''
  mkdir -p $out/bin
  cat > $out/bin/xcrun <<'EOF'
  #!/bin/sh
  xcode="@xcode@/Contents/Developer"
  if [ "$1" = "-find" ] && [ -n "$2" ]; then
    for dir in "$xcode/Toolchains/XcodeDefault.xctoolchain/usr/bin" "$xcode/usr/bin"; do
      if [ -x "$dir/$2" ]; then
        echo "$dir/$2"
        exit 0
      fi
    done
    echo "xcrun: tool $2 not found in $xcode" >&2
    exit 1
  fi
  exec /usr/bin/xcrun "$@"
  EOF
  sed -i "s|@xcode@|${pkgs.darwin.xcode}|" $out/bin/xcrun
  chmod +x $out/bin/xcrun
''
