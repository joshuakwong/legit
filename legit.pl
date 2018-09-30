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

else {
    print "legit.pl: error: unknown command $ARGV[0]\n";
    print "Usage: ./legit.pl <command> [<args>]\n";
    print "\n";
    print "These are the legit commands:\n";
    print "\tinit\tCreate an empty legit repository\n";
    print "\tadd\tAdd file contents to the index\n";
    print "\tcommit\tRecord changes to the repository\n";
    print "\tlog\tShow commit log\n";
    print "\trm\tRemove files from the current directory and from the index\n";
    print "\tstatus\tShow the status of files in the current directory, index, and repository\n";
    print "\n";
    exit;
}


