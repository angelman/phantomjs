#!/usr/bin/env bash

#
# usage: just run this script (after having run build.sh)
#        and deploy the created tarball to your target machine.
#
# It creates a phantomjs-$version folder and copies the binary,
# example, license etc. together with all shared library dependencies
# to that folder. Furthermore brandelf is used to make the lib
# and binary compatible with older unix/linux machines that don't
# know the new Linux ELF ABI.
#

cd $(dirname $0)

if [[ ! -f ../bin/phantomjs ]]; then
    echo "phantomjs was not built yet, please run build.sh first"
    exit 1
fi

version=$(sed -n 's/#define PHANTOMJS_VERSION_STRING[[:space:]]*//p' ../src/consts.h | sed 's/"//g')
src=..

echo "packaging phantomjs $version"

if [[ $OSTYPE = darwin* ]]; then
    dest="phantomjs-$version-macosx"
else
    dest="phantomjs-$version-linux-$(uname -m)"
fi

rm -Rf $dest{.tar.bz2,} &> /dev/null
mkdir -p $dest/bin

echo

echo -n "copying files..."
cp $src/bin/phantomjs $dest/bin
cp -r $src/{ChangeLog,examples,LICENSE.BSD,third-party.txt,README.md} $dest/
echo "done"
echo

phantomjs=$dest/bin/phantomjs

echo -n "compressing binary..."
if type upx >/dev/null 2>&1; then
    upx -qqq -9 $phantomjs
    echo "done"
else
    echo "upx not found"
fi
echo

echo -n "creating archive..."
if [[ $OSTYPE = darwin* ]]; then
    zip -r $dest.zip $dest
else
    tar -cjf $dest{.tar.bz2,}
fi
echo "done"
echo
