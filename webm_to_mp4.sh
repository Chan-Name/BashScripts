#!/bin/bash

F_DIR="~/Downloads"
L_DIR="~/VIDEO"

webm_to_mp4() {

    if ! command -v ffmpeg &>/dev/null; then
        echo "Pls install ffmpeg"
    else
        for file_webm in *.webm; do
            if [[ -f "$file_webm" ]]; then
                file_mp4 = "${file_webm%.webm}.mp4"
                ffmpeg -i $file $file_mp4 && rm $file_webm
            fi
        done
    fi
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
    webm_to_mp4
    mp4_to_dir
    echo "Webm to mp4 and move to ${L_DIR}"
}
