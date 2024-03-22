#! /bin/bash

if [ -z "${STREAM_URL}" ];then
    echo "Please provide an RTMP or RTMPS URL for streaming"
    exit 1
fi

#  check if /data/has_config exists
if [ -f /data/has_config ]; then
    echo "Resuming playback with existing config..."
else
    echo "Creating new config file"
    echo -e "$STREAM_URL" >> /data/config_transcode.yml
    echo -e "$STREAM_URL" >> /data/config_passthrough.yml
    touch /data/has_config
fi

if [ -n "${PASSTHROUGH}" ];then
    echo "Starting passthrough playback to $STREAM_URL"
    ffplayout -c /data/config_passthrough.yml
else 

if [ -z "${RESOLUTION}" ];then
    echo "Using default resolution of 1280x720"
    export RESOLUTION="1280x720"
    RESOLUTION=$(echo $RESOLUTION | sed 's/x/:/')
fi

if [ -z "${FRAME_RATE}" ];then
    echo "Using default frame rate of 30fps"
    export FRAME_RATE=30
fi

if [ -z "${KEYFRAME_INTERVAL}" ];then
    echo "Using default keyframe interval of 2x frame rate"
    export KEYFRAME_INTERVAL=$(($FRAME_RATE * 2))
fi

if [ -z "${VIDEO_BITRATE}" ];then
    echo "Using default bitrate of 2000kbps"
    export VIDEO_BITRATE="2000"
fi

if [ -z "${SAMPLE_RATE}" ];then
    echo "Using default sample rate of 44100"
    export SAMPLE_RATE="44100"
fi

if [ -z "${AUDIO_BITRATE}" ];then
    echo "Using default audio bitrate of 128kbps"
    export AUDIO_BITRATE="128"
fi

# BUFSIZE is set to 2x the bitrate
export BUFSIZE=$(($VIDEO_BITRATE * 2))

sed -i "s/-RESOLUTION-/$RESOLUTION/;" /data/config_transcode.yml
sed -i "s/-FRAMERATE-/$FRAME_RATE/;" /data/config_transcode.yml
sed -i "s/-KEYINT-/$KEYFRAME_INTERVAL/g;" /data/config_transcode.yml
sed -i "s/-BITRATE-/$VIDEO_BITRATE/;" /data/config_transcode.yml
sed -i "s/-BUFSIZE-/$BUFSIZE/;" /data/config_transcode.yml
sed -i "s/-SAMPLERATE-/$SAMPLE_RATE/;" /data/config_transcode.yml
sed -i "s/-AUDIO_BITRATE-/$AUDIO_BITRATE/;" /data/config_transcode.yml

echo "$ESCAPED_STREAM_URL"
echo "Starting transcoding to $STREAM_URL"
ffplayout -c /data/config_transcode.yml

fi


