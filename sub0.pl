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

    use File::Copy;
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
        # catch files that doesn't exist in directory but alread traced
        if (!-e $file && -e ".legit/index/$file"){
            unlink ".legit/index/$file";
            next;
        }
 
        # catch files that doesn't exist in directory
        if (!-e $file ){
            print "legit.pl: error: can not open '$file'\n";
            next;
        }

        # copy files
        copy("$file", ".legit/index/$file") or die "copy fail";
    }
}



# legit show
sub show{
    initcheck();
    my (@args) = @_;   

    #print $args[0];
    if ($#args != 0){
        print "legit.pl: error: too much arguments\n";
        print "usage: ./legit.pl show [commitNumber]:<filename>\n";
        exit 1;
    }

    # parse the argument
    # 2 scenarios
    # - <commit num>:<file>
    # - :<file>#
    $arg = $args[0];
    if ($arg =~ /^(\d+):(.+)$/){
        our $commitNum = $1;
        our $filename = $2;
    }

    elsif ($arg =~ /^:(.+)$/){
        our $filename = $1;
    }
    
    else{
        print "legit.pl: error: invlid arguments\n";
        print "usage: ./legit.pl show [commitNumber]:<filename>\n";
        exit 1;
    }
    
    # commitNumber not supplied, get file from index
    # open the file for reading and print the file
    if (!defined $commitNum){
        if (!-e ".legit/index/$filename"){
            print "legit.pl: error: '$filename' not found in index\n";
            exit 1;
        }
        open my $f, "<", ".legit/index/$filename" or print "file cannot be opened";

        while (my $line = <$f>){
            print $line;
        }
        close $f;
    }
    
    elsif (!-d ".legit/commit/$commitNum"){
        print "legit.pl: error: unknown commit '$commitNum'\n";
        exit 1;
    }

    else {
        if (! -e ".legit/commit/$commitNum/$filename"){
            print "legit.pl: error: '$filename' not found in commit $commitNum\n";
            exit 1;
        }
        open my $f, "<", ".legit/commit/$commitNum/$filename" or print "file cannot be opened";

        while (my $line = <$f>){
            print $line;
        }
        close $f;
    }
}


# legit log
sub legitlog{
    initcheck();
    if (!-e ".legit/commit"){
        print "legit.pl: error: no commit history.\n";
        exit 1;
    }
    
    # find the latest commit, set the boolean value if this is the first commit
    my @commitHist = glob(".legit/commit/*");
    if (!@commitHist){
        print "legit.pl: error: no commit history.\n";
        exit 1;
    }

    # for each item in the list of commit history,
    # open the comment in respective files
    # print the content in the file as well as the commit number#
    foreach $dir (reverse @commitHist){
        $dir =~ /(\d+)/;
        open my $f, "<", "$dir/comment" or die "fail to read comment";
        print "$1 ";
        while (my $line = <$f>){
            print "$line"; 
        }
        close $f;
        print "\n";
    }
}


# helper function, initialization check
# if not initialized, print error message
sub initcheck{
    #legit not initialized
    if (!-d ".legit"){ 
        print "legit.pl: error: no .legit directory containing legit repository exists\n";
        exit 1;
    }
}

1;
