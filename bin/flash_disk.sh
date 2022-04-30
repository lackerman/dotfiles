#!/bin/bash

usage() {
	cat <<EOF
$(basename $0) [-d <disk>] [-f <filename] [-h] [-l]

  -f the filename of the image to write to the disk
  -d the disk to write the image to
  -l list the available disks
  -h show the available options
EOF
}

list_disks() {
    echo "--- available disks ---"
    diskutil list | grep "external" | grep "physical"
    exit 0
}

while getopts "d:f:lh" o; do
    case "${o}" in
        f) FILENAME=${OPTARG} ;;
        d) DISK="${OPTARG}" ;;
        l) list_disks ;;
        h) usage && exit 0 ;;
        *) usage && exit 1 ;;
    esac
done

[ -z "$FILENAME" ] && echo "Missing filename" && usage && exit 1
[ -z "$DISK" ] && echo "Missing disk" && usage && exit 1

echo "Are you sure you want to write ${FILENAME} to ${DISK?}? (y|N)"
read answer
[ "$answer" != "y" ] && echo "Selected not to continue. Exiting..." && exit 0

echo "Unmounting ${DISK}..."
sudo diskutil unmountDisk "$DISK"

echo "dd status=progress if=${FILENAME} of=${DISK}"
sudo dd if=${FILENAME} of=${DISK}

