with import <nixpkgs> {}; rec {
  pinpogEnv = stdenv.mkDerivation {
    name = "pinpog-env";
    buildInputs = [ nasm qemu gdb ];
  };
}