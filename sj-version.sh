#!/bin/sh

# Script to print version properties for a given pom-scijava release.

# Examples:
# sj-version.sh 1.70
# sj-version.sh 1.70 1.74

version="$1"
diff="$2"

repo="http://maven.imagej.net/content/repositories/releases"

props() {
	url="$repo/org/scijava/pom-scijava/$1/pom-scijava-$1.pom"
	curl -s $url | \
		grep '\.version' | \
		sed 's/<\/.*//' | \
		sed 's/^	*<\(.*\)>/\1: /' | \
		sort
}

if [ -z "$version" ]
then
  echo "Usage: sj-version.sh version [version-to-diff]"
fi

if [ -n "$diff" ]
then
	# compare two versions
	props $version > $version.tmp
	props $diff > $diff.tmp
	diff -y $version.tmp $diff.tmp
	rm $version.tmp $diff.tmp
else
	# dump props for one version
	props $version
fi