#!/bin/bash

if [ -z "$targetImage" ]; then
  targetImage=$(awk -F "=" '/targetImage/ {print $2}' .env)
fi

echo $targetImage
