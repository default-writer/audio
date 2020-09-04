# Audo mixer .dockercontainer

## URLs

### webm to mp3

```bash
ffmpeg -i "${FILE}" -vn -ab 128k -ar 44100 -y "${FILE%.webm}.mp3";
```

### convert all webm to mp3

```bash
find . -type f -iname "*.webm" -exec bash -c 'FILE="$1"; ffmpeg -i "${FILE}" -vn -ab 128k -ar 44100 -y "${FILE%.webm}.mp3";' _ '{}' \;
```

### use mp3wrap 

```bash
mp3wrap "${FILE}" *.mp3
```