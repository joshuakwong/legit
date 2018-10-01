#!/bin/sh

# test 07 - legit rm --cached
# curr dir, index and commit all different files


echo "test 07 - legit rm --cached"
echo "          curr dir, index and commit all different files"
echo "--------------------------------------------------\n"

echo "$ rm -rf .legit/"
rm -rf .legit/
echo "$ $1 init"
$1 init

echo "$ echo 1 >a"
echo 1 >a
echo "$ echo 1 >b"
echo 1 >b
echo "$ echo 1 >e"
echo 1 >e
echo "$ echo 1 >f"
echo 1 >f

echo "$ $1 add a b e f"
$1 add a b e f
echo "$ $1 commit -m \"first commit\""
$1 commit -m "first commit"

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

echo "$ $1 add a b c e f g"
$1 add a b c e f g


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

$1 rm --cached a
$1 rm --cached b
$1 rm --cached c
$1 rm --cached d
$1 rm --cached e
$1 rm --cached f
$1 rm --cached g

#$1 status 

###########################################################
