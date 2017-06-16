#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# reduce clips
for f in ** ; do
    if  [[ $f == *.MXF || $f == *.mov ]];then
        echo "producing $f"
        name=$(basename "${f%.*}_")
        ffmpeg -ss 0  -i "$f" -s 1280x720 -vf yadif -b 1500000 "${name}.mp4"
        namelist_darwin+="${name}.mp4|"
        namelist_linux+="${name}.mp4 "
    fi
done

# combine clips
case "$(uname -s)" in
  Darwin)
    namelist=$(echo ${namelist_darwin} | rev | cut -c 2- | rev)
    ffmpeg -i ""concat:${namelist}"" -c copy output.mp4;
    ;;

  Linux)
    ls  ${namelist_linux} | perl -ne 'print "file $_"' | ./ffmpeg -f concat -i  - -c copy output.mp4;
    ;;
esac

