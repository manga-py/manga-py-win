# This script compiles manga-py from the source and creates a release archive.

# These dependencies need to be installed prior to running this script
# python 3.9, virtualenv

$ErrorActionPreference = 'Stop'
$currdir = Get-Location
$version = "1.33.0"
$mangaPyDir = "$currdir\manga-py-$version"

# Modules in these folders will be passed to pyinstaller as --hidden-import https://pyinstaller.readthedocs.io/en/stable/usage.html#cmdoption-hidden-import
$hiddenModulesFolders = @("$mangaPyDir\manga_py\providers", 
                          "$mangaPyDir\manga_py\providers\helpers",
                          "$mangaPyDir\manga_py\crypt")

# This variable will accumulate all --hidden-import
$hiddenModulesParameters = ""

. "$currdir\utils.ps1"

Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/manga-py/manga-py/archive/refs/tags/$version.zip" -OutFile "$currdir\$version.zip"
Expand-Archive "$currdir\$version.zip" -DestinationPath $currdir -Force
virtualenv `"$mangaPyDir\venv`"
& "$mangaPyDir\venv\Scripts\activate.ps1"
pip install -r `"$mangaPyDir\requirements.txt`"
pip install `"pyinstaller==4.5.1`" # use 4.5.1 otherwise virus scanners go frenzy

for($i = 0; $i -lt $hiddenModulesFolders.Length; $i++) {

    # C:\Users\user\Desktop\manga-py-1.32.0\manga_py\providers --> manga_py.providers (module namespace)
    $prefix = $hiddenModulesFolders[$i].Replace('\', '.')
    $prefix = $prefix.Substring($prefix.IndexOf('manga_py'))

    # Gets names of all modules in given directory -Directory and prefixes them with -NamespacePrefix
    $hiddenModulesParameters += Get-HiddenImportParameters -Directory $hiddenModulesFolders[$i] -NamespacePrefix $prefix
    $hiddenModulesParameters += ' '
}

Start-Process `
    -FilePath 'pyinstaller' `
    -ArgumentList '-F', "`"$mangaPyDir\manga.py`"", '--specpath', "`"$mangaPyDir\spec`"", '--distpath', "`"$mangaPyDir\dist`"", '--workpath', "`"$mangaPyDir\build`"", $hiddenModulesParameters `
    -WorkingDirectory "$currdir" `
    -Wait `
    -NoNewWindow

Move-Item `
    -Path "$mangaPyDir\dist\manga.exe" `
    -Destination "$currdir\manga-py.exe" `
    -Force

Remove-Item "$version.zip" `
    -Force `
    -ErrorAction SilentlyContinue

Move-Item `
    -Path "$mangaPyDir\LICENSE" `
    -Destination $currdir `
    -Force

& 'deactivate'

Remove-Item $mangaPyDir `
    -Recurse -Force `
    -ErrorAction SilentlyContinue

Compress-Archive `
    -Path "$currdir\LICENSE", "$currdir\manga-py.exe" `
    -Destination "$currdir\manga_py-$version-win-x64.zip" `
    -CompressionLevel Optimal `
    -Force

Remove-Item `
    -Path "$currdir\manga-py.exe", "$currdir\LICENSE" `
    -Force `
    -ErrorAction SilentlyContinue