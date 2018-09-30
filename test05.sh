#!/bin/sh

# test 05
# legit commit with -a flag


echo "Test 04 - legit commit with -a flag"
echo "--------------------------------------------------\n"

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ ./legit.pl init"
./legit.pl init

echo "$ echo a1 >a"
echo a1 >a
echo "$ echo b1 >b"
echo b1 >b
echo "$ echo c1 >c"
echo c1 >c

echo "$ ./legit.pl add a b c"
./legit.pl add a b c
echo "$ ./legit.pl commit -m \"first\""
./legit.pl commit -m "first"

echo "$ echo a2 >>a"
echo a2 >>a
echo "$ ./legit.pl commit -a -m \"second\""
./legit.pl commit -a -m "second"

echo "$ echo b2 >>b"
echo b2 >>b
echo "$ ./legit.pl add b"
./legit.pl add b
echo "$ ./legit.pl commit -m \"third\""
./legit.pl commit -m "third"

echo "$ rm c"
rm c
echo "$ ./legit.pl commit -a -m \"fourth\""
./legit.pl commit -a -m "fourth"

echo "$ ./legit.pl show 0:a"
./legit.pl show 0:a
echo "$ ./legit.pl show 0:b"
./legit.pl show 0:b
echo "$ ./legit.pl show 0:c"
./legit.pl show 0:c

echo "$ ./legit.pl show 1:a"
./legit.pl show 1:a
echo "$ ./legit.pl show 1:b"
./legit.pl show 1:b
echo "$ ./legit.pl show 1:c"
./legit.pl show 1:c

echo "$ ./legit.pl show 2:a"
./legit.pl show 2:a
echo "$ ./legit.pl show 2:b"
./legit.pl show 2:b
echo "$ ./legit.pl show 2:c"
./legit.pl show 2:c

echo "$ ./legit.pl show 3:a"
./legit.pl show 3:a
echo "$ ./legit.pl show 3:b"
./legit.pl show 3:b
echo "$ ./legit.pl show 3:c"
./legit.pl show 3:c
# echo "$ "
# echo "$ "
