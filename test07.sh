#!/bin/sh

# test 07 - legit rm --cached
# curr dir, index and commit all different files


echo "test 07 - legit rm --cached"
echo "          curr dir, index and commit all different files"
echo "--------------------------------------------------\n"

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "$ echo 1 >a"
echo 1 >a
echo "$ echo 1 >b"
echo 1 >b
echo "$ echo 1 >e"
echo 1 >e
echo "$ echo 1 >f"
echo 1 >f

echo "$ ./legit.pl add a b e f"
./legit.pl add a b e f
echo "$ ./legit.pl commit -m \"first commit\""
./legit.pl commit -m "first commit"

echo "$ echo 2 >a"
echo 2 >a
echo "$ echo 2 >c"
echo 2 >c
echo "$ echo 2 >e"
echo 2 >e
echo "$ echo 2 >g"
echo 2 >g
echo "$ rm b"
rm b
echo "$ rm f"
rm f

echo "$ ./legit.pl add a b c e f g"
./legit.pl add a b c e f g


echo "$ echo 3 >a"
echo 3 >a
echo "$ echo 3 >d"
echo 3 >d
echo "$ echo 3 >f"
echo 3 >f
echo "$ echo 3 >g"
echo 3 >g
echo "$ rm c e"
rm c e 

echo "$ ./legit.pl rm --cached a"
./legit.pl rm --cached a
echo "$ ./legit.pl rm --cached b"
./legit.pl rm --cached b
echo "$ ./legit.pl rm --cached c"
./legit.pl rm --cached c
echo "$ ./legit.pl rm --cached d"
./legit.pl rm --cached d
echo "$ ./legit.pl rm --cached e"
./legit.pl rm --cached e
echo "$ ./legit.pl rm --cached f"
./legit.pl rm --cached f
echo "$ ./legit.pl rm --cached g"
./legit.pl rm --cached g
#./legit.pl status 

rm a d f g &2>/dev/null

###########################################################
