#!/usr/bin/perl 

use warnings;
use strict;
require 'sub0.pl';
require 'sub1.pl';


my $numarg = $#ARGV+1;

if ($numarg == 0){
    print "legit.pl: error: insufficient arguments\n";
    exit;
}

elsif ($ARGV[0] eq "init"){
    initdir();
}

elsif ($ARGV[0] eq "add"){
    shift @ARGV;
    add(@ARGV);
}

elsif ($ARGV[0] eq "commit"){
    shift @ARGV;
    commit(@ARGV);
}

elsif ($ARGV[0] eq "log"){
    legitlog();
}

elsif ($ARGV[0] eq "show"){
    shift @ARGV;
    show(@ARGV);
}

elsif ($ARGV[0] eq "rm"){
    shift @ARGV;
    rm(@ARGV);
}

elsif ($ARGV[0] eq "status"){
    status();
}

elsif ($ARGV[0] eq "test"){
    my @test;
    push (@test, "a");
    #push (@test, "b");
    #push (@test, "c");
    #push (@test, "d");
    #push (@test, "e");
    #if (grep(/^g$/, @test) != 1){
    #    print "not found\n";
    #}
    print "$#test\n";
}

else {
    print "legit.pl: error: not recognized command\n";
    exit;
}


