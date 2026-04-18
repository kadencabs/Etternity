Etternity is a cross-platform rhythm game similar to [Dance Dance Revolution](https://en.wikipedia.org/wiki/Dance_Dance_Revolution). It started as a fork of [Etterna](https://github.com/etternagame/etterna) (v0.74.4), with a focus on offline keyboard players.
## Table of Contents

- [Installing](#Installing)
  - [Windows and macOS](#Windows-and-macOS)
  - [Linux](#Linux)
- [Special Thanks](#Special-Thanks)

## Installing

### Windows, macOS, and Linux

Head to the [GitHub Releases](https://github.com/kadencabs/etternity/releases) page, and download the relevant file for your operating system.

For Windows, run the installer, and you should be ready to go.

For macOS, first follow the below instructions. *After* doing them, mount the DMG and copy the Etterna folder to a location of your choice. Run the executable, and you are ready to go.

For Linux, there should be no extra steps. If it does not work, try to follow the build instructions to install the necessary dependencies.

### macOS

This macOS binary is not signed, so before it can be installed it must be de-quarantined by executing this command in the same directory (likely your downloads folder) as the Etterna dmg.

`xattr -d com.apple.quarantine ./Etterna*.dmg`

## Special Thanks

- All original SM devs/contributors
- All original Etterna devs/contributors
