# PORTABLE PLAYOUT

Legal preamble:
This repo contains a Dockerfile which installs ffplayout and FFmpeg with commerical components included.
That means if you build this image and distribute it publicly (whether for profit or not), you are breaking the law!
To avoid this, you *MUST* build the image directly on each system you intend to use it on. Luckily it only takes a minute.
This comes with zero warranty or promise of support!

## HI THERE

portable-playout is a super simple method of streaming out files from a folder to an RTMP server of your choosing.
It is basically a wrapper for ffplayout - ffplayout.github.io with some preconfigured scripts and flags.
The intention is that once you start it up you can just move files in and out of the play_me folder and it will keep streaming them 24/7.
You can build once and run multiple instances by creating new directories for each 'channel' and duplicating the docker-compose.yml + play_me sidecar folder.

## BUILD ME

Do you have docker and docker-compose installed? Simply run:

```docker build -t portable-playout:latest .```

You'll want to run this on Linux. If you run it on macOS or Windows you can start streaming and add files, but it won't detect renames or deletes, so plan accordingly.

## CONFIGURE ME

Edit the variables in your docker-compose.yml file to customize the output. At a minimum, you need to provide the **STREAM_URL** value.

Uncomment the 'PASSTHROUGH=true' line to stream the encoded video directly. But streamer beware, pre-encoded videos must have a few parameters in common including:

- codec (H264)
- same resolution, frame rate, sample rate
- "main" encoding profile
- keyframe interval of 1 or 2 seconds (aka GOP)
- NO b-frames (these are for flattened content only, not streaming)

The program assumes there is a 'play_me' folder in the same directory you will be starting it up in (using docker-compose.yml). 

You can (in order of difficulty):

- drop video files in the actual folder
- make a softlink to another location (ln -s /your_system/portable-playout/play_me /your_system/path/to/your_videos)
- use 'play_me' as a mount point for cloud-based storage (S3fuse for example) 
- edit the mount in the docker-compose file to mount a different external location to '/play_me' inside the container.

## FIRE ME UP

Everything configured? Got at least one video file in your 'play_me' folder? To start the container run:

```docker-compose up```

... and the stream should begin, otherwise an error message of some kind will spit out and the program will stop.

Once you are happy with your configuration you could change restart to 'always' in the docker-compose.yml file

## NEED HELP?

If something is broken, that's ripe for submitting a github issue along with whatever evidence you can gather.
If you just feel stuck, try a discussion and we'll try to help.
