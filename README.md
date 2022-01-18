# Windows builds for manga-py
This repository offers build scripts and Windows executables for [manga-py](https://github.com/manga-py/manga-py).

## Installation
You can either build the executable yourself (see [Building](#Building)) or download a prepared one.
### Package manager
* [Chocolatey](https://community.chocolatey.org/packages/manga-py)
    ```
    choco install manga-py
    ```
### Manual
Grab [the latest release](https://github.com/manga-py/manga-py-win/releases) and put it somewhere on your computer.
## Building
1. Install Python 3.9 and virtualenv
1. Put [make.ps1](make.ps1) and [utils.ps1](utils.ps1) in to the same directory
1. Execute `.\make.ps1` (ExecutionPolicy must be set to `Bypass` or `Unrestricted`)

manga_py-`VERSION`-win-x64.zip containing `manga-py.exe` and `LICENSE` will be created.