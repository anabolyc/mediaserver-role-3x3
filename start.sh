# generate playlist
echo "Generating playlist..."
playlist_gen /media > /vlc/playlist.conf
echo "done!"

echo "Starting vls stream..."
vlc -Ihttp --log-verbose=1 --vlm-conf /vlc/vlm.conf --random --loop
