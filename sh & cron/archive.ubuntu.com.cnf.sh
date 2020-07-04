#!/bin/bash

for p in "${1:-focal}"{,-{security,updates,proposed,backports}}/{main,restricted,universe,multiverse}; do
        >&2 echo "${p}"
        wget -q -c -r -np -R "index.html*" "http://archive.ubuntu.com/ubuntu/dists/${p}/cnf/"
done
