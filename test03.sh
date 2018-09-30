#!/bin/sh

# test 03 
# legit status (deleted files)



echo "Test 03 - legit status (deleted files)"
echo "--------------------------------------------------\n"

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

touch a b c d e f g
echo "$ echo 1 >x"
echo 1 >x
echo "$ echo 2 >y"
echo 2 >y
echo "$ echo 3 >z"
echo 3 >z


echo "$ ./legit.pl add a b c e x y z"
./legit.pl add a b c e x y z
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

echo "$ echo 4 >x"
echo 4 >x
echo "$ echo 5 >y"
echo 5 >y

echo "$ ./legit.pl add x y"
./legit.pl add x y

echo "$ echo 6 >x"
echo 6 >x

echo "$ ./legit.pl status"
./legit.pl status

rm a e f g x y z &2>/dev/null
