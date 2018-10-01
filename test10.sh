#!/bin/sh

# test 10 - legit rm
# some files in 2 out of 3 files are the same


echo "test 10 - legit rm"
echo "          some files in 2 out of 3 files are the same"
echo "--------------------------------------------------\n"

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "$ echo 1 >a"
echo 1 >a
echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 2 >c"
echo 2 >c
echo "$ echo 2 >d"
echo 2 >d
echo "$ echo 2 >e"
echo 2 >e
echo "$ echo 2 >f"
echo 2 >f

echo "$ ./legit.pl add a b c e f"
./legit.pl add a b c e f
echo "$ ./legit.pl commit -m \"first commit\""
./legit.pl commit -m "first commit"
echo "$ ./legit.pl add d"
./legit.pl add d

echo "$ echo 2 >a"
echo 2 >a
echo "$ echo 1 >b"
echo 1 >b
echo "$ rm e"
rm e
echo "$ ./legit.pl add a b c e"
./legit.pl add a b c e


echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 1 >c"
echo 1 >c
echo "$ echo 2 >e"
echo 2 >e
echo "$ rm f"
rm f

echo "$ ./legit.pl rm --force --cached a"
./legit.pl rm --force --cached a
echo "$ ./legit.pl rm --force --cached b"
./legit.pl rm --force --cached b
echo "$ ./legit.pl rm --force --cached c"
./legit.pl rm --force --cached c
echo "$ ./legit.pl rm --force --cached d"
./legit.pl rm --force --cached d
echo "$ ./legit.pl rm --force --cached e"
./legit.pl rm --force --cached e
echo "$ ./legit.pl rm --force --cached f"
./legit.pl rm --force --cached f

###########################################################

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "$ echo 1 >a"
echo 1 >a
echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 2 >c"
echo 2 >c
echo "$ echo 2 >d"
echo 2 >d
echo "$ echo 2 >e"
echo 2 >e
echo "$ echo 2 >f"
echo 2 >f

echo "$ ./legit.pl add a b c e f"
./legit.pl add a b c e f
echo "$ ./legit.pl commit -m \"first commit\""
./legit.pl commit -m "first commit"
echo "$ ./legit.pl add d"
./legit.pl add d

echo "$ echo 2 >a"
echo 2 >a
echo "$ echo 1 >b"
echo 1 >b
echo "$ rm e"
rm e
echo "$ ./legit.pl add a b c e"
./legit.pl add a b c e


echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 1 >c"
echo 1 >c
echo "$ echo 2 >e"
echo 2 >e
echo "$ rm f"
rm f

echo "$ ./legit.pl rm --force a"
./legit.pl rm --force a
echo "$ ./legit.pl rm --force b"
./legit.pl rm --force b
echo "$ ./legit.pl rm --force c"
./legit.pl rm --force c
echo "$ ./legit.pl rm --force d"
./legit.pl rm --force d
echo "$ ./legit.pl rm --force e"
./legit.pl rm --force e
echo "$ ./legit.pl rm --force f"
./legit.pl rm --force f

###########################################################

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "$ echo 1 >a"
echo 1 >a
echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 2 >c"
echo 2 >c
echo "$ echo 2 >d"
echo 2 >d
echo "$ echo 2 >e"
echo 2 >e
echo "$ echo 2 >f"
echo 2 >f

echo "$ ./legit.pl add a b c e f"
./legit.pl add a b c e f
echo "$ ./legit.pl commit -m \"first commit\""
./legit.pl commit -m "first commit"
echo "$ ./legit.pl add d"
./legit.pl add d

echo "$ echo 2 >a"
echo 2 >a
echo "$ echo 1 >b"
echo 1 >b
echo "$ rm e"
rm e
echo "$ ./legit.pl add a b c e"
./legit.pl add a b c e


echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 1 >c"
echo 1 >c
echo "$ echo 2 >e"
echo 2 >e
echo "$ rm f"
rm f

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

###########################################################

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "$ echo 1 >a"
echo 1 >a
echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 2 >c"
echo 2 >c
echo "$ echo 2 >d"
echo 2 >d
echo "$ echo 2 >e"
echo 2 >e
echo "$ echo 2 >f"
echo 2 >f

echo "$ ./legit.pl add a b c e f"
./legit.pl add a b c e f
echo "$ ./legit.pl commit -m \"first commit\""
./legit.pl commit -m "first commit"
echo "$ ./legit.pl add d"
./legit.pl add d

echo "$ echo 2 >a"
echo 2 >a
echo "$ echo 1 >b"
echo 1 >b
echo "$ rm e"
rm e
echo "$ ./legit.pl add a b c e"
./legit.pl add a b c e


echo "$ echo 2 >b"
echo 2 >b
echo "$ echo 1 >c"
echo 1 >c
echo "$ echo 2 >e"
echo 2 >e
echo "$ rm f"
rm f

echo "$ ./legit.pl rm a"
./legit.pl rm a
echo "$ ./legit.pl rm b"
./legit.pl rm b
echo "$ ./legit.pl rm c"
./legit.pl rm c
echo "$ ./legit.pl rm d"
./legit.pl rm d
echo "$ ./legit.pl rm e"
./legit.pl rm e
echo "$ ./legit.pl rm f"
./legit.pl rm f

###########################################################
rm a b c d e &2>/dev/null
