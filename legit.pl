#!/usr/bin/perl 

use warnings;
use strict;

my $numarg = $#ARGV+1;
if ($numarg == 0){
    print "error, insufficient arguments\n";
    exit;
}


if ($ARGV[0] eq "init"){
    initdir();
}




sub initdir{
    if (-d ".legit"){
        print "legit.pl: error: .legit already exists\n";
    }
    else {
        mkdir(".legit", 0700);
        print "Initialized empty legit repository in .legit\n";
    }
}
