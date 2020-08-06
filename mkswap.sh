#!/bin/bash

SWAPFILE=/swapfile
MEMSIZE=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')

if [[ ${MEMSIZE} -lt 2097152 ]]; then
  SIZE="$((${MEMSIZE} * 2))k"
elif [[ ${MEMSIZE} -lt 8388608 ]]; then
  SIZE="${MEMSIZE}k"
elif [ ${MEMSIZE} -lt 67108864]; then
  SIZE="$((${MEMSIZE}  / 2))k"
else
  SIZE="4194304k"
fi

if [[ -e ${SWAPFILE} ]]; then
  CURRENTSIZE=$(du ${SWAPFILE} | awk '{print $1}')
else
  CURRENTSIZE=0
fi

if [[ ${SIZE} -ne ${CURRENTSIZE} ]]; then
  dd if=/dev/zero out=${SWAPFILE} count ${SIZE} bs=1k
  chmod 600 ${SWAPFILE}
  mkswap ${SWAPFILE}
  swapon ${SWAPFILE}
else
  swapon ${SWAPFILE}
fi

echo ${MEMSIZE}
echo $((${MEMSIZE} * 2))
