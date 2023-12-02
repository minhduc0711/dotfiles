#!/bin/sh

export PATH="/home/minhduc0711/.local/bin/:$PATH"

# Session
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway
export XDG_CURRENT_DESKTOP=sway

# Wayland stuff
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT4_IM_MODULE=ibus
export CLUTTER_IM_MODULE=ibus
export GLFW_IM_MODULE=ibus

# Firefox
export MOZ_DISABLE_RDD_SANDBOX=1  # to enable VA-API
export MOZ_ALLOW_DOWNGRADE=1

# VA-API
export LIBVA_DRIVER_NAME=i965

# QT
export QT_SCALE_FACTOR=1.25

# Run virsh as non-root
export LIBVIRT_DEFAULT_URI=qemu:///system

exec sway $@
