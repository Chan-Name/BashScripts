
#!/bin/bash

F_DIR="$HOME/Downloads"
V_DIR="$HOME/Video"
M_DIR="$HOME/Music"
P_DIR="$HOME/Documents"
SCRIPT_PATH="$(realpath "$0")"
PROFILE_PATH="$HOME/.profile"
SLEEP_TIME=3000

setup_autostart() {
    if ! grep -qF "$SCRIPT_PATH" "$PROFILE_PATH"; then
        echo -e "\n# FilesToDirs\n/bin/bash $SCRIPT_PATH" >> "$PROFILE_PATH"
    fi
}
webm_to_mp4() {

    if ! command -v ffmpeg &>/dev/null; then
        echo "install ffmpeg pls"
        return 1
    fi

    for file_webm in *.webm; do
        if [[ -f "$file_webm" ]]; then
            file_mp4="${file_webm%.webm}.mp4"
            ffmpeg -i $file_webm $file_mp4 && rm $file_webm
        fi
    done
}

files_to_dir() {

    mkdir -p $L_DIR $M_DIR

    for file in *.mp4; do
        if [[ -f "$file_mp4" ]]; then
            mv $file $L_DIR
        fi
    done

    for file in *.mp3 *.ogg *.flac *.wav; do
        if [[ -f "$file" ]]; then
            mv "$file" "$M_DIR"
        fi
    done

    for file in *.pdf *.doc; do
        if [[ -f "$file" ]]; then
            mv "$file" "$P_DIR"
        fi
    done
}

main() {
    cd $F_DIR 2>/dev/null || { echo "Ошибка: Директория ~/$F_DIR не найдена!"; exit 1; }
    setup_autostart
    webm_to_mp4
    while true; do
        files_to_dir
        sleep $SLEEP_TIME
    done
}

main
