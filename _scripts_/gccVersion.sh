#!/bin/bash -

# This script prints the versions of GCC.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

scriptDir="$(dirname "${BASH_SOURCE[0]}")"
scriptDir="$(realpath -eP "$scriptDir")"
gccStd="$($scriptDir/gccStd.sh)"
gccVersion="$(gcc --std=$gccStd --version)"
gccVersion="$(grep "^gcc" <<< "$gccVersion")"
gccVersion="$(sed -n "s/.*\s//p" <<< "$gccVersion")"
echo "$gccVersion"
