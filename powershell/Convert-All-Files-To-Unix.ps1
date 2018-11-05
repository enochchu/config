$files = Get-ChildItem -Path ./ -Recurse

foreach ($file in $files) {
    dos2unix.exe $file
}