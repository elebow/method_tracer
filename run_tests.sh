#!/bin/sh

if [ "$#" -ge 1 ]; then
	name_arg=--name "$*"
else
	name_arg=""
fi

bundle e ruby -Ilib:test "$(find test -name "*_test.rb")" $name_arg
