#!/bin/sh

# test 01 
# run command that is not in legit
# run command before init


echo "Test 01 - command that is not in legit"
echo "          run command without running legit init"
echo "--------------------------------------------------\n"

echo "$ ./legit.pl timmoc mr"
./legit.pl timmoc mr
echo ""

echo "$ rm -rf .legit/"
rm -rf .legit/

echo "$ touch a b c d"
touch a b c d

echo "$ ./legit.pl add a b c d"
./legit.pl add a b c d
echo ""

rm a b c d &2>/dev/null
