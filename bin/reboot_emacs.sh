#!/usr/bin/env bash

# Emacs を確実に停止 (SIGTERM → 待機 → SIGKILL)
pkill emacs
sleep 1
pkill -9 emacs 2>/dev/null

# fcitx5 を Wayland 無効で起動し直す
# WSLg + X11 アプリで候補パネルが残留する問題があるため
# 自動起動された fcitx5 (PPID=368) も殺してから起動
pkill -9 -f fcitx5 2>/dev/null
sleep 1
fcitx5 --disable=wayland -d

# X11 ディスプレイが使えるまで待機 (WSLg の復旧待ち)
for i in $(seq 1 10); do
    xdpyinfo >/dev/null 2>&1 && break
    echo "Waiting for X11 display... ($i)"
    sleep 1
done

if ! xdpyinfo >/dev/null 2>&1; then
    echo "Error: X11 display is not available" >&2
    exit 1
fi

# Emacs に必要な環境変数を設定
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# キーリピート設定 (Wayland) — 旧 xset r rate 200 80 相当
gsettings set org.gnome.desktop.peripherals.keyboard delay 200 2>/dev/null
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 12 2>/dev/null

/usr/bin/emacs-pgtk &
