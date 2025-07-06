#!/bin/bash

# Prompt user for duration
read -p "Enter duration (in seconds): " DURATION

# Prompt user for resolution selection
echo "Select resolution:"
echo "1) 4320p (8K)     - 7680x4320"
echo "2) 2160p (4K)     - 3840x2160"
echo "3) 1440p (2K)     - 2560x1440"
echo "4) 1080p (Full HD)- 1920x1080"
echo "5) 720p (HD)      - 1280x720"
read -p "Enter choice [1-5]: " RES_CHOICE

case "$RES_CHOICE" in
  1) SIZE="7680x4320" ;;
  2) SIZE="3840x2160" ;;
  3) SIZE="2560x1440" ;;
  4) SIZE="1920x1080" ;;
  5) SIZE="1280x720" ;;
  *) echo "Invalid choice. Defaulting to 1080p."; SIZE="1920x1080" ;;
esac

# Extract width and height values from SIZE (format: WxH)
WIDTH="${SIZE%x*}"
HEIGHT="${SIZE#*x}"

# Prompt user for frame rate
read -p "Enter frame rate (default is 30): " FRAMERATE
FRAMERATE=${FRAMERATE:-30}

# Prompt user for codec choice
echo "Select video codec:"
echo "1) libx264 (H.264)"
echo "2) libx265 (H.265)"
echo "3) prores (Apple ProRes)"
read -p "Enter choice [1-3]: " CODEC_CHOICE

case "$CODEC_CHOICE" in
  1)
    VCODEC="libx264"
    EXT="mp4"
    ;;
  2)
    VCODEC="libx265"
    EXT="mp4"
    ;;
  3)
    VCODEC="prores_ks"
    EXT="mov"
    ;;
  *)
    echo "Invalid choice. Defaulting to libx264 (H.264)"
    VCODEC="libx264"
    EXT="mp4"
    ;;
esac

# Desktop path
DESKTOP="$HOME/Desktop"
OUTPUT="$HOME/Documents/scripts/Media-Transfer-Project/MOV-INPUT/moving_smpte_countdown_${SIZE}_${DURATION}s.$EXT"

# Explanation of the filter chain:
# • The SMPTE bars source is generated at the chosen $SIZE.
# • The video is split into two identical streams [v1] and [v2].
# • They are placed side-by-side using hstack (resulting in an image of width = 2 * WIDTH).
# • A crop filter then extracts a window of width = $WIDTH and height = $HEIGHT.
#   The x position is animated over time (using mod(t*20, WIDTH)) to pan horizontally.
# • Finally, drawtext overlays a centered countdown.
#
# Adjust the number 20 in "t*20" to change the pan speed.
# Also, update "fontfile" to point to an appropriate TrueType font on your system.
ffmpeg -f lavfi -i "smptebars=size=$SIZE:rate=$FRAMERATE" \
       -f lavfi -i "sine=frequency=1000:duration=$DURATION" \
       -filter_complex "\
       [0:v]split=2[v1][v2]; \
       [v1][v2]hstack, \
       crop=w=$WIDTH:h=$HEIGHT:x='mod(t*20,$WIDTH)':y=0, \
       drawtext=fontfile=/System/Library/Fonts/Supplemental/Arial.ttf:\
text='%{eif\\:$DURATION-t\\:d}':\
fontcolor=white:fontsize=1200:x=(w-text_w)/2:y=(h-text_h)/2:\
box=1:boxcolor=black@0.5:boxborderw=10 [v]" \
       -map "[v]" -map 1:a \
       -t "$DURATION" \
       -c:v "$VCODEC" -pix_fmt yuv420p -c:a aac -b:a 128k -shortest "$OUTPUT"

echo "✅ Countdown SMPTE video saved to: $OUTPUT"
