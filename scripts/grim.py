#!/usr/bin/env python3
from argparse import ArgumentParser
import os
from datetime import datetime

screenshot_dir = "~/Pictures/screenshots"
screenshot_cmd = "grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
screenclip_cmd = """grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)\""""

parser = ArgumentParser()
parser.add_argument("--rect", action="store_true")
parser.add_argument("--clipboard", action="store_true")
args = parser.parse_args()

cmd = screenclip_cmd if args.rect else screenshot_cmd
if args.clipboard:
    cmd += " - | wl-copy"
else:
    os.makedirs(os.path.expanduser(screenshot_dir), exist_ok=True)
    current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    cmd += f" {screenshot_dir}/{current_time}"
os.system(cmd)
