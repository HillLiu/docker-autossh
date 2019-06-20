#!/bin/bash

if [ -z "$sourceImage" ]; then
  sourceImage=$(awk -F "=" '/sourceImage/ {print $2}' .env)
fi

echo $sourceImage
