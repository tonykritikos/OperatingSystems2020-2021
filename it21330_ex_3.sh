#! /bin/bash

ls -lh $1 | grep ^d | awk '{print $5, $9}' | sort -hr | head --lines=5