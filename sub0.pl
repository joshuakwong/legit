# legit commit
sub commit{
    initcheck();
    my (@args) = @_;
    # case if there are too much arguments to commit
    if ($#args+1 > 3){
        print "./legit.pl: error: too much arguments\n";
        print "usage: ./legit.pl commit [-a] -m \"message\"\n";
        exit 1;
    }
    # check for existence of -a flag
    my $aPos = -1;
    my $mPos = -1;
    for (my $i=0; $i<$#args; $i++){
        $aPos = $i if ($args[$i] eq "-a");
        $mPos = $i if ($args[$i] eq "-m");
    }
    #print "aPos = $aPos\n";
    #print "mPos = $mPos\n";
    #print "$args[$mPos+1]\n";

    # case if -a flag is between -m and message
    if ($aPos == $mPos+1){
        print "./legit.pl: error: invalid operation, -m flag must be followed by a message\n";
        print "usage: ./legit.pl commit [-a] -m \"message\"\n";
        exit 1;
    }

    if ($args[$mPos+1] =~ /^-/){
        print "./legit.pl: error: invalid operation, message must not be started with a dash\n";
        print "usage: ./legit.pl commit [-a] -m \"message\"\n";
        exit 1;
    }













}

# legit init
# initialize .legit directory
sub initdir{
    if (-d ".legit"){
        print "legit.pl: error: .legit already exists\n";
    }
    else {
        mkdir(".legit", 0700);
        print "Initialized empty legit repository in .legit\n";
    }
}

# legit add <file> <file> ... <file>
# index file, stores the latest copy of the added files
sub add{
    my (@files) = @_;
    initcheck();
    if (!-d ".legit/index"){ #create index file
        mkdir (".legit/index", 0700);
    }

    foreach my $file (@files){
        # catch files not in the current directory
        if ($file =~ /\//){
            print "only file of the current directory can be added\n";
            next;
        }
        # catch files not named right#
        if ($file !~ /^[a-zA-Z0-9]/){
            print "filename $file is not valid\n";
            next;
        }
        # catch files that doesn't exist in directory
        if (!-e $file ){
            print "file $file does not exist in directory\n";
            next;
        }
 
        # copy files
        use File::Copy;
        copy("$file", ".legit/index/$file") or die "copy fail";
        print "Backup of '$file' saved '.legit/index/$file'\n";        
    }
}


sub initcheck{
    #legit not initialized
    if (!-d ".legit"){ 
        print "legit.pl: error: .legit not yet initialized\n";
        exit 1;
    }
}
















1;
