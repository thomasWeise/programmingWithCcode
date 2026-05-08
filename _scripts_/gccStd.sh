#!/bin/bash -

# This script prints the versions of the dependencies and software environment under which the book was built.
# It uses the basic dependency versions given in bookbase and adds python tool information.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

error="$(gcc --std=c23 --version 2>&1 >/dev/null || true)"
if [ -n "$error" ]; then
    error="$(gcc --std=c2x --version 2>&1 >/dev/null || true)"
    if [ -n "$error" ]; then
        echo "GCC does not support C23."
        exit 1
    else
        echo "c2x"
    fi
else
    echo "c23"
fi
