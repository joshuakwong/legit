#!/usr/bin/perl 

use warnings;
use strict;

my $numarg = $#ARGV+1;
if ($numarg == 0){
    print "legit.pl: error: insufficient arguments\n";
    exit;
}


if ($ARGV[0] eq "init"){
    initdir();
}

elsif ($ARGV[0] eq "add"){
    add();
}

else {
    print "legit.pl: error: not recognized command\n";
    exit;
}

sub add{
    return;
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
