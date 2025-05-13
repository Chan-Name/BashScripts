#!/bin/bash

F_DIR="$HOME/Downloads"
V_DIR="$HOME/Video"
M_DIR="$HOME/Music"
P_DIR="$HOME/Documents"
FOLDERS=("$F_DIR" "$V_DIR" "$M_DIR" "$P_DIR")

SCRIPT_PATH="$(realpath "$0")"
PROFILE_PATH="$HOME/.profile"
SLEEP_TIME=3000

declare -A DIR_MAP=(
    ["mp4"]="$V_DIR"
    ["mp3"]="$M_DIR"
    ["ogg"]="$M_DIR"
    ["flac"]="$M_DIR"
    ["wav"]="$M_DIR"
    ["pdf"]="$P_DIR"
    ["doc"]="$P_DIR"
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
    cd "$F_DIR" 2>/dev/null || { echo "Ошибка: Директория $F_DIR не найдена!"; exit 1; }
    setup_autostart
    while true; do
        convert
        files_to_dir
        sleep $SLEEP_TIME
    done
}

main
