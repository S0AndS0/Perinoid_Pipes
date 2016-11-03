# Warning

> Scripts under this directory are un-tested and maybe distructive if missused

## Intended use

> Scripts under this directory are intended for hardware compatible with
> [Rubber Ducky](https://github.com/hak5darren/USB-Rubber-Ducky/wiki) HID (Human
> Interface Device) automation/attack methods. Scripts that have a `.ducky`
> suffix **must** be recompiled via the following command prior to being used.

```
java -jar duckencoder.jar -i script.ducky -o /media/microsdcard/inject.bin
```

> Modify the `script.ducky` for the script you wish compiled and modify the
> `/media/microsdcard/` directory path to that of your mounted micro-SD card.

## Listing of scripts contained in this directory

### `Windows_10_64_bit_install_bash.ducky`

[![Status](https://img.shields.io/badge/Status-Untested-yellow.svg)](Windows_10_64_bit_install_bash.ducky)

> This is a simple payload that will *(hopefully)* install Bash and an Ubuntu
> file system inside of the Windows 10 enviroment. A new bash shell is then
> spawned if the install did not error out and commands are sent to it to update
> and install software via `apt-get`... it is ready for testing but the authors
> of this project do not currently have access to related hardware.
