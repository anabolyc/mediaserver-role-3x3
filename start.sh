# generate playlist
echo "Generating playlist..."
playlist_gen /media > /vlc/playlist.conf
echo $(sed '/^$/d' /vlc/playlist.conf | wc -l) " items in playlist"

echo "Patching xupnp config"
# patch config

if [ ! -f /xupnpd/src/.xupnpd.lua.patched ]; then
	sed -e "s/UPnP-IPTV/${FRONTEND_NAME}/" -e "s/4044/${FRONTEND_PORT}/" -e "s/60bd2fb3-dabe-cb14-c766-0e319b54c29a/${BACKEND_GUID}/" -i /xupnpd/src/xupnpd.lua 
	sed -e "s/playlists_update_interval=60/playlists_update_interval=0/" -e "s/cfg\.group=true/cfg\.group=false/" -e "s/cfg\.debug=1/cfg\.debug=0/" -i /xupnpd/src/xupnpd.lua
	sed -e "s/xupnpd/${BACKEND_GUID}/" -i /xupnpd/src/www/dev.xml
	touch /xupnpd/src/.xupnpd.lua.patched
else
	echo "Config file appears to be patched already"
fi

echo "Starting vls stream..."
vlc -Ihttp --log-verbose=1 --vlm-conf /vlc/vlm.conf --random --loop --network-caching 1000 --sout-mux-caching 2000 --clock-jitter 0 &

echo "#EXTINF:-1 group-title="TV" tvg-name="3x3" tvg-id="" tvg-logo="",3x3\nhttp://${VLC_IP}:5000/live" > /xupnpd/src/playlists/list.m3u 

echo "Starting xupnp server"
/xupnpd/src/xupnpd


