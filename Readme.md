# PinPog

Our goal is to write a game that fits into 512 bytes bootloader and
works in 16 bit real mode on any IBM PC compatible machine without any
Operating System.

## Dependencies

First install these programs:

- [nasm]
- [qemu]

## Quick Start

### Build the game

```console
$ nasm pinpog.asm -o pinpog
```

### Run the game in QEMU

```console
$ qemu-system-i386 pinpog
```

[nasm]: https://www.nasm.us/
[qemu]: https://www.qemu.org/
