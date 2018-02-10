#!/bin/sh

log=enc-log.txt

echo -----$1 start encoding @$(date +%Y/%m/%d/%H:%M:%S)----- >> $log

cmd="ruby -W0 scripts/encoder.rb '$1' '$2'"
eval $cmd >> $log

exit
