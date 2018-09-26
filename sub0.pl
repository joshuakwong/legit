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
            print "legit.pl: error: can not open '$file'\n";
            next;
        }
 
        # copy files
        use File::Copy;
        copy("$file", ".legit/index/$file") or die "copy fail";
        #print "Backup of '$file' saved '.legit/index/$file'\n";        
    }
}


# legit commit
sub commit{
    #initcheck();
    my (@args) = @_;
    # case if there are too much arguments to commit
    if ($#args+1 > 3){
        print "legit.pl: error: too much arguments\n";
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

    # case if -m does not exist
    if ($mPos == -1){
        print "legit.pl: error: invalid operation, message must be included\n";
        print "usage: ./legit.pl commit [-a] -m \"message\"\n";
        exit 1;
    }

    # case if -a flag is between -m and message
    if ($aPos == $mPos+1){
        print "legit.pl: error: invalid operation, -m flag must be followed by a message\n";
        print "usage: ./legit.pl commit [-a] -m \"message\"\n";
        exit 1;
    }

    # case if message started with a dash#
    if ($args[$mPos+1] =~ /^-/){
        print "legit.pl: error: invalid operation, message must not be started with a dash\n";
        print "usage: ./legit.pl commit [-a] -m \"message\"\n";
        exit 1;
    }

    my $commitComment = $args[$mPos+1];

    # check if commit directory exists or not
    if (!-e ".legit/commit"){
        mkdir (".legit/commit", 0700);
    }
    
    # find the latest commit, set the boolean value if this is the first commit
    my @commitHist = glob(".legit/commit/*");
    foreach my $item (@commitHist){
        $item =~ s/\.legit\/commit\///;
    }
    my $latestCommit = $commitHist[$#commitHist];
    
    # new commit file
    if (!defined $latestCommit){
        our $firstCommit = 1;
        #print "first commit\n";
        our $commitFileName = "0";
    }
    else{
        my $firstCommit = 0;
        $latestCommit =~ /(\d+)/;
        our $commitFileName = $1+1;
        $commitFileName = "$commitFileName";
    }

    #use File::Compare;
    my @filename = glob (".legit/index/*");
    if (!@filename){
        print "legit.pl: error: there is nothing in index, use ./legit.pl add <filename> <filename>\n";
        exit 1;
    }

    # do not push filename from 2nd list if already exist in first list
    if ($firstCommit == 0){
        @filename2 = glob (".legit/commit/$latestCommit/*"); 
        foreach my $commitItem (@filename2){
            $commitItem =~ s/.legit\/commit\/$latestCommit\///;
            push(@filename, $commitItem) unless grep{$_ ne $commitItem} @filename;
        }
    }
    foreach my $item (@filename){
        $item =~ s/.*\///;
    }
    

    use File::Copy;
    use File::Compare;
    if ($firstCommit == 1){
        mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
        foreach my $item (@filename){
            #copy("$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
            copy(".legit/index/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
        }
        print "Committed as commit 0\n";        
    }
    
    else {
        foreach my $item (@filename){
            # file appear in both index and latest commit
            if (-e ".legit/index/$item" && -e ".legit/commit/$latestCommit/$item") {
                # file are the same, copy from the latest commit to new commit
                if (compare(".legit/commit/$latestCommit/$item", ".legit/index/$item") == 0){
                    mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                    copy(".legit/commit/$latestCommit/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
                }
                else {
                    #file are not the same, copy from index
                    mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                    copy(".legit/index/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
                }
            }
            # file only appear in index but not latest commit
            elsif (-e ".legit/index/$item" && !-e ".legit/commit/$latestCommit/$item") {
                mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                copy(".legit/index/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
            }
        }
            print "Committed as commit $commitFileName\n";        
    }

    #add comment
    if (-d ".legit/commit/$commitFileName"){
        my $commentDir = ".legit/commit/$commitFileName/comment";
        open my $commentFile, ">", $commentDir, or die "fail to write comments\n";
        print $commentFile $commitComment;
        close $commentFile;
    }


}


# legit show
sub show{
    #initcheck();
    my (@args) = @_;   

    #print $args[0];
    if ($#args != 0){
        print "legit.pl: error: too much arguments\n";
        print "usage: ./legit.pl show [commitNumber]:<filename>\n";
        exit 1;
    }

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
    if (!defined $commitNum){
        if (!-e ".legit/index/$filename"){
            print "legit.pl: error: '$filename' not found in index\n";
            exit 1;
        }
        open my $f, "<", ".legit/index/$filename" or print "fuck, file cannot be opened";

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
        open my $f, "<", ".legit/commit/$commitNum/$filename" or print "fuck, file cannot be opened";

        while (my $line = <$f>){
            print $line;
        }
        close $f;
    }
}


# legit log
sub legitlog{
    #initcheck();
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


sub initcheck{
    #legit not initialized
    if (!-d ".legit"){ 
        print "legit.pl: error: no .legit directory containing legit repository exists\n";
        exit 1;
    }
}

1;
