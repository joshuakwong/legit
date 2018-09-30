#!/bin/sh

# test 04 
# legit status 2


echo "Test 04 - legit status 2 (deleted files)"
echo "--------------------------------------------------\n"

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "touch a b c d e f g"
touch a b c d e f g

echo "$ ./legit.pl add a b c e"
./legit.pl add a b c e
echo "$ ./legit.pl commit -m "first commit""
./legit.pl commit -m "first commit"
echo "$ ./legit.pl add d g"
./legit.pl add d g

echo "$ rm b"
rm b
echo "$ ./legit.pl rm c"
./legit.pl rm c
echo "$ rm d"
rm d
echo "$ ./legit.pl rm --cached e"
./legit.pl rm --cached e

echo "$ ./legit.pl status"
./legit.pl status

rm a e f g &2>/dev/null