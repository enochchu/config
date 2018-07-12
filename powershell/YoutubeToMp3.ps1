$links = @(
    'https://www.youtube.com/watch?v=Fi63FpHCi_s'
)

ForEach ($link in $links) {
    youtube-dl --extract-audio --audio-format mp3 $link
}