#!/bin/bash -

# This is our script for compiling and running of code.

# We enforce strict error handling, i.e., fail on any unexpected error.
#set -o pipefail  # trace errors through pipes
#set -o errtrace  # trace errors through commands and functions
#set -o nounset   # exit if encountering an uninitialized variable
#set -o errexit   # exit if any statement returns a non-0 return value

# Getting base directory for files.
baseDir="$1"
echo "$baseDir"
baseDir="$(realpath -eP "$baseDir")"
echo "$baseDir"

# Getting base directory for scripts.
scriptDir=`dirname "$0"`; scriptDir=`eval "cd \"$scriptDir\" && pwd"`
echo "$scriptDir"
scriptDir="$(realpath -eP "$scriptDir")"
echo "$scriptDir"

# Getting GCC standard and version.
gccStd="$("$scriptDir/gccStd.sh")"
echo "$gccStd"
gccVersion="$("$scriptDir/gccVersion.sh")"
echo "$gccVersion"

tempDir="$(mktemp -d)"

programs=""
cd "$baseDir"
for file in "${@:2}"; do
  file="$(realpath -eP "$file")"
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
