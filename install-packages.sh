#!/bin/sh

###
# Environment ${INSTALL_VERSION} pass from Dockerfile
###

INSTALL="autossh openssh-client"

BUILD_DEPS=""

echo "###"
echo "# Will install"
echo "###"
echo ""
echo $INSTALL
echo ""
echo "###"
echo "# Will install build tool"
echo "###"
echo ""
echo $BUILD_DEPS
echo ""

echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories

apk add --virtual .build-deps $BUILD_DEPS && apk add $INSTALL

#/* put your install code here */#

apk del -f .build-deps && rm -rf /var/cache/apk/* || exit 1

exit 0
