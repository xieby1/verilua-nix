#!/usr/bin/env bash
TMPDIR=$(mktemp -d)
cd $TMPDIR
cp -rs "$VERILUA_HOME"/* .
find . -type d -exec chmod +w {} +
xmake run test
