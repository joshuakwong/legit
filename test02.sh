#!/bin/sh

# test 02
# adding non existing file
# removing file from staging area by deleting file from curr dir


echo "Test 02 - adding non existing file"
echo "          update file then add and commit"
echo "          removing file from staging area by deleting file from curr dir"
echo "--------------------------------------------------\n"

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "$ echo hello >a"
echo hello >a
echo "$ echo hello >b"
echo world >b

echo "$ ./legit.pl add a b c"
./legit.pl add a b c
echo "$ ./legit.pl commit -m \"first commit\""
./legit.pl commit -m "first commit"

echo "$ ./legit.pl show :a"
./legit.pl show :a
echo "$ ./legit.pl show :b"
./legit.pl show :b

echo "$ rm a"
rm a
echo "$ echo world world world >>b"
echo world world world >>b


echo "$ ./legit.pl add a b"
./legit.pl add a b
echo "$ ./legit.pl commit -m "second""
./legit.pl commit -m "second"

echo "$ ./legit.pl log"
./legit.pl log

echo "$ ./legit.pl show 0:a"
./legit.pl show 0:a
echo "$ ./legit.pl show 0:b"
./legit.pl show 0:b
echo "$ ./legit.pl show 1:a"
./legit.pl show 1:a
echo "$ ./legit.pl show 1:b"
./legit.pl show 1:b
echo "$ ./legit.pl show :a"
./legit.pl show :a
echo "$ ./legit.pl show :b"
./legit.pl show :b

rm b &2>/dev/null