#! /usr/bin/env bash

set +x

# all files "*[0-9].mp4" to menu e.g:
# good       : gear-v1.mp4
# bad        : gear-v1m.mp4
# menuentries: "${FN} +"
MENU="`ls -Rt1 *[0-9].mp4 | sed '-e s/^\(.*\)$/\1 +/'`"
FN=`dialog --menu "Multiply video" 0 0 13 ${MENU} 3>&1 1>&2 2>&3 3>&-`

if [ $? -eq 0 ]
  then

  # $RC times (repeat count)
  RC=6

  # concat          concatinate
  # safe 0          the file name safety is not to be discussed
  # filesecriptor   contains a 'flying file' with $RC times "file ${PWD}/${FN}"
  # copy            the output filename (*.mp4 => *m.mp4)
  ffmpeg -f concat \
	 -safe 0 \
	 -i <(for N in $(seq 1 ${RC}); do echo "file ${PWD}/${FN}"; done) \
	 -c copy "${PWD}/`echo ${FN} | sed -e 's/\(\.mp4\)$/m\1/'`"
  fi
