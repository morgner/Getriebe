#! /usr/bin/env bash

set +x

# all files "*[0-9].mp4" to menu e.g:
# good       : gear-v1.mp4
# bad        : gear-v1m.mp4
# menuentries: "${FN} +"
# ffmpeg -i kurve-8.mp4 2>&1|sed -n /Duration/p|sed -r 's@(^.*Duration: .{11}). .*$@\1@'
set +x

MENU=()
for E in `ls -Rt *[0-9].mp4`
  do
  MENU=(${MENU[@]} "${E}" `ffmpeg -i "$E" 2>&1|sed -n /Duration/p|sed -r 's@^.*Duration: (.{11}). .*$@\1@'`)
  done

FN=`dialog --menu "Multiply video" 0 0 13 ${MENU[@]} 3>&1 1>&2 2>&3 3>&-`

if [ $? -eq 0 ]
  then

  # $RC times (repeat count)
  RC=6

  # concat          concatinate
  # safe 0          the file name safety is not to be discussed
  # filesecriptor   contains a 'flying file' with $RC times "file ${PWD}/${FN}"
  # copy            the output filename (*.mp4 => *m.mp4)
  FD=${PWD}/`echo ${FN} | sed -r 's/(\.mp4)/m\1/'`
  ffmpeg -f concat \
	 -safe 0 \
	 -i <(for N in $(seq 1 ${RC}); do echo "file ${PWD}/${FN}"; done) \
	 -c copy $FD

  vlc --play-and-exit "$FD"
  echo "--------------"
  echo "Result: $FD"
  fi
