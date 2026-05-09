#!/bin/bash -

# This is our script for compiling and running of code.

# We enforce strict error handling, i.e., fail on any unexpected error.
#set -o pipefail  # trace errors through pipes
#set -o errtrace  # trace errors through commands and functions
#set -o nounset   # exit if encountering an uninitialized variable
#set -o errexit   # exit if any statement returns a non-0 return value

scriptDir="$(dirname "${BASH_SOURCE[0]}")"
scriptDir="$(realpath -eP "$scriptDir")"
gccStd="$($scriptDir/gccStd.sh)"
gccVersion="$($scriptDir/gccVersion.sh)"

tempDir="$(mktemp -d)"

cd "$1"
programs=""
for file in "${@:2}"; do
  cp "$file" "$tempDir"
  programs="$programs $(basename "$file")"
done

destFile="$(basename "$2")"
destFile="${destFile%.*}"

cd "$tempDir"


command="gcc -Wall -Wextra -std=$gccStd -pedantic -o $destFile$programs"
cmdReal="gcc -Wall -Wextra -std=$gccStd -fdiagnostics-color=never -pedantic -o $destFile$programs"
echo "\$ $command"  # We print the command line which will be executed.
set +o errexit  # Turn off exit-on-error.
$cmdReal 2>&1
exitCode="$?"  # Store exit code of program in variable exitCode.
set -o errexit  # Turn exit-on-error back on.

[ "$exitCode" -eq 0 ] && exitCodeStr="succeeded" || exitCodeStr="failed"

# Finally, we print the result string.
echo "# gcc $gccVersion $exitCodeStr with exit code $exitCode."
if [ "$exitCode" -ne 0 ]; then
  exit 0
fi

command="./$destFile"
echo "\$ $command"  # We print the command line which will be executed.
set +o errexit  # Turn off exit-on-error.
$command 2>&1
exitCode="$?"  # Store exit code of program in variable exitCode.
set -o errexit  # Turn exit-on-error back on.

[ "$exitCode" -eq 0 ] && exitCodeStr="succeeded" || exitCodeStr="failed"

# Finally, we print the result string.
echo "# $command $exitCodeStr with exit code $exitCode."

rm -rf "$tempDir"
