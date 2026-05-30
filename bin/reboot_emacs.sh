#!/usr/bin/env bash

# Emacs を確実に停止 (SIGTERM → 待機 → SIGKILL)
pkill emacs
sleep 1
pkill -9 emacs 2>/dev/null

# 競合する IM を停止して fcitx5 をクリーン起動
# 親指シフト(NICOLA)は fcitx5-mozc の同時打鍵機能で実現
pkill -9 -f fcitx5 2>/dev/null
pkill -9 oyainput 2>/dev/null
pkill -9 uim-xim 2>/dev/null
pkill -9 uim-toolbar-gtk3 2>/dev/null
sleep 1

# fcitx5 を Wayland 無効で起動
# WSLg の Weston は zwp_input_method_v1 のバインドを拒否するため
# wayland addon を有効にすると fcitx5 が起動直後に終了する (検証済 2026-05-28)
fcitx5 --disable=wayland -d

# 表示サーバが使えるまで待機 (WSLg の復旧待ち)
# pgtk Emacs は Wayland or X11 どちらでも動くため両方チェック
display_ready() {
    [ -S "/mnt/wslg/runtime-dir/wayland-0" ] || xdpyinfo >/dev/null 2>&1
}

for i in $(seq 1 10); do
    display_ready && break
    echo "Waiting for display (Wayland/X11)... ($i)"
    sleep 1
done

if ! display_ready; then
    cat >&2 <<'EOF'
Error: WSLg display is not available (Wayland and X11 both down).

WSLg の RDP セッションが切断されています。以下のいずれかで復旧してください:

  1. PowerShell から (推奨・最も確実):
       wsl --shutdown
     その後 WSL を再起動

  2. 現在の distro のみ再起動 (軽量):
       wsl.exe --terminate $WSL_DISTRO_NAME

  3. LxssManager サービス再起動 (管理者権限):
       powershell.exe -Command "Restart-Service LxssManager"
EOF
    exit 1
fi

# Emacs に必要な環境変数を設定 (fcitx5 経由)
# X11 Emacs では GTK IM module と XIM が二重介在しキー食いの原因となるため
# GTK/QT モジュールは空にし、XIM 経路一本に統一
export GTK_IM_MODULE=
export QT_IM_MODULE=
export XMODIFIERS=@im=fcitx

# キーリピート設定
# Wayland (GNOME) 側
gsettings set org.gnome.desktop.peripherals.keyboard delay 200 2>/dev/null
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 12 2>/dev/null
# X11 側 (X11ビルド Emacs 用、delay 200ms / rate 40Hz)
xset r rate 200 40 2>/dev/null

# 入力遅延検証のため一時的にX11(GTK)ビルドを使用
# 問題があれば /usr/bin/emacs-pgtk に戻すこと
/usr/local/bin/emacs &
