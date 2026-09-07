#!/usr/bin/env bash
# 智能多媒体控制脚本：解决 Linux QQ 音乐等客户端 PlayPause 接口残废导致的“暂停秒播放”问题

ACTION="${1:-toggle}"

case "$ACTION" in
    toggle|play-pause)
        if busctl --user status org.mpris.MediaPlayer2.qqmusic >/dev/null 2>&1; then
            STATUS=$(busctl --user get-property org.mpris.MediaPlayer2.qqmusic /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player PlaybackStatus 2>/dev/null | tr -d 's "' || true)
            if [ "$STATUS" = "Playing" ]; then
                busctl --user call org.mpris.MediaPlayer2.qqmusic /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Pause >/dev/null 2>&1
            else
                busctl --user call org.mpris.MediaPlayer2.qqmusic /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Play >/dev/null 2>&1
            fi
        else
            playerctl play-pause 2>/dev/null || noctalia msg media toggle >/dev/null 2>&1 || true
        fi
        ;;
    next)
        if busctl --user status org.mpris.MediaPlayer2.qqmusic >/dev/null 2>&1; then
            busctl --user call org.mpris.MediaPlayer2.qqmusic /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Next >/dev/null 2>&1
        fi
        playerctl next 2>/dev/null || noctalia msg media next >/dev/null 2>&1 || true
        ;;
    previous|prev)
        if busctl --user status org.mpris.MediaPlayer2.qqmusic >/dev/null 2>&1; then
            busctl --user call org.mpris.MediaPlayer2.qqmusic /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Previous >/dev/null 2>&1
        fi
        playerctl previous 2>/dev/null || noctalia msg media previous >/dev/null 2>&1 || true
        ;;
esac
