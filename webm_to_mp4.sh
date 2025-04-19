#!/bin/bash

F_DIR="$HOME/Downloads"
L_DIR="$HOME/VIDEO"
SCRIPT_PATH="$(realpath "$0")"
PROFILE_PATH="$HOME/.profile"

setup_autostart() {
    if ! grep -qF "$SCRIPT_PATH" "PROFILE_PATH"; then
        echo -e "\n# WebmToMp4\n/bin/bash $SCRIPT_PATH" >> "$PROFILE_PATH"
    fi
}
webm_to_mp4() {

    if command -v ffmpeg &>/dev/null; then
        echo "install ffmpeg pls"
        return 1
    fi

    for file_webm in *.webm; do
        if [[ -f "$file_webm" ]]; then
            file_mp4="${file_webm%.webm}.mp4"
            ffmpeg -i $file $file_mp4 && rm $file_webm
        fi
    done
}

mp4_to_dir() {

    mkdir -p $L_DIR

    for file_mp4 in *.mp4; do
        if [[ -f "$file_mp4" ]]; then
            mv $file_mp4 $L_DIR
        fi
   done
}

main() {
    cd $F_DIR 2>/dev/null || { echo "Ошибка: Директория ~/$F_DIR не найдена!"; exit 1; }
    setup_autostart
    webm_to_mp4
    mp4_to_dir
    echo "Webm to mp4 and move to ${L_DIR}"
}

main
