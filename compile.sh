#!/bin/bash

sourceImage=`./sourceImage.sh`
targetImage=`./targetImage.sh`

tag(){
  tag=$1
  if [ -z $tag ]; then
    tag=latest
  fi
  echo "* <!-- Start to tag"
  echo $tag
  docker tag $sourceImage ${targetImage}:$tag
  docker images | head -10 
  echo "* Finish tag -->"
}

push(){
  echo "* <!-- Start to push"
  docker login
  docker push ${targetImage}
  echo "* Finish to push -->"
}

build(){
  docker-compose -f build.yml build --no-cache
}

case "$1" in
  p)
    push $2 
    ;;
  t)
    tag $2 
    ;;
  *)
    build
    exit
esac

exit $?
