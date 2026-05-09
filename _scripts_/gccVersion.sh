#!/bin/bash -

# This script prints the versions of GCC.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

scriptDir="$(readlink -fe "$0")"
scriptDir="$(dirname "$scriptDir")"
scriptDir="$(realpath -eP "$scriptDir")"

gccStd="$($scriptDir/gccStd.sh)"
gccVersion="$(gcc --std=$gccStd --version)"
gccVersion="$(grep "^gcc" <<< "$gccVersion")"
gccVersion="$(sed -E 's/.*\s+([0-9]+(\.[0-9]+)*)$/\1/' <<< "$gccVersion")"
echo "$gccVersion"
