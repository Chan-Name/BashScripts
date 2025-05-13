#!/bin/bash

INITIAL_DIR="$HOME/Downloads"
VIDEOS_DIR="$HOME/Video"
MUSIC_DIR="$HOME/Music"
DOCUMENTS_DIR="$HOME/Documents"
FOLDERS=("$INITIAL_DIR" "$VIDEOS_DIR" "$MUSIC_DIR" "$DOCUMENTS_DIR")

SCRIPT_PATH="$(realpath "$0")"
PROFILE_PATH="$HOME/.profile"
SLEEP_TIME=3000

declare -A DIR_MAP=(
    ["mp4"]="$VIDEOS_DIR"
    ["mp3"]="$MUSIC_DIR"
    ["ogg"]="$MUSIC_DIR"
    ["flac"]="$MUSIC_DIR"
    ["wav"]="$MUSIC_DIR"
    ["pdf"]="$DOCUMENTS_DIR"
    ["doc"]="$DOCUMENTS_DIR"
)

shopt -u nullglob

#systemd юниты для пидоров
setup_autostart() {
    if ! grep -qF "$SCRIPT_PATH" "$PROFILE_PATH"; then
        echo -e "\n# FilesToDirs\n/bin/bash "$SCRIPT_PATH" " >> "$PROFILE_PATH"
    fi
}

convert() {
    if ! command -v ffmpeg &>/dev/null; then
        echo "install ffmpeg pls"
        return 1
    fi

    for file_webm in *.webm; do
        if [[ -f "$file_webm" ]]; then
            file_mp4="${file_webm%.webm}.mp4"
            ffmpeg -i "$file_webm" "$file_mp4" && rm "$file_webm"
        fi
    done
}

files_to_dir() {
    for dir in "${FOLDERS[@]}"; do
        mkdir -p "$dir"
    done

    #Проход по расширениям из ассоциативного массива
    #Указание директорий в зависимости от расширения
    #Раскидка файлов по директориям в зависимости от расширения
    #Которые указаны в ассоциативном массиве
    for ext in "${!DIR_MAP[@]}"; do
        target_dir="${DIR_MAP[$ext]}"
        for file in *."$ext"; do
            if [[ -f "$file" ]]; then
                mv "$file" "$target_dir"
            fi
        done
    done
}

main() {
    cd "$INITIAL_DIR" 2>/dev/null || { echo " "$INITIAL_DIR" не существует"; exit 1; }
    setup_autostart
    while true; do
        convert
        files_to_dir
        sleep $SLEEP_TIME
    done
}

main
