#!/bin/bash

# Detect user's home directory and construct the wallpaper path
home_dir="$HOME"
wallpaper_filename="macguyver_wallpaper_deer_dark.jpg"
wallpaper_path="$home_dir/Pictures/$wallpaper_filename"

# Use osascript to set the desktop picture using the constructed path
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$wallpaper_path\""
