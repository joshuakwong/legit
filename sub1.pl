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
    
    # declare the commit file name,
    # if it is the first commit, assign it to "0"
    # else, assign it to latest commit +1#
    if (!defined $latestCommit){
        our $firstCommit = 1;
        our $commitFileName = "0";
    }
    else{
        my $firstCommit = 0;
        $latestCommit =~ /(\d+)/;
        our $commitFileName = $1+1;
        $commitFileName = "$commitFileName";
    }

    # check if there are files in .legit/index
    my @filename = glob (".legit/index/*");
    if (!@filename){
        print "legit.pl: error: there is nothing in index, use ./legit.pl add <filename> <filename>\n";
        exit 1;
    }

    # add files from commit to list of files,
    # do not push filename from 2nd list if already exist in first list
    # remove all directory characters except the filename itself
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
        my $allSame = 1;
        my @sameFiles;
        foreach my $item (@filename){
            # file appear in both index and latest commit
            if (-e ".legit/index/$item" && -e ".legit/commit/$latestCommit/$item") {
                # file are the same, copy from the latest commit to new commit
                if (compare(".legit/commit/$latestCommit/$item", ".legit/index/$item") == 0){
                    push (@sameFiles, "$item");
                }
                else {
                    #file are not the same, copy from index
                    mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                    copy(".legit/index/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
                    $allSame = 0;
                }
            }
            # file only appear in index but not latest commit
            elsif (-e ".legit/index/$item" && !-e ".legit/commit/$latestCommit/$item") {
                mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                copy(".legit/index/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
            }
        }

        if ($allSame == 0){
            #copy the rest
            foreach my $item (@sameFiles){
                copy(".legit/commit/$latestCommit/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
            } 
            print "Committed as commit $commitFileName\n";        
        }
        else {
            print "nothing to commit\n";
        }
    }

    #add comment
    if (-d ".legit/commit/$commitFileName"){
        my $commentDir = ".legit/commit/$commitFileName/comment";
        open my $commentFile, ">", $commentDir, or die "fail to write comments\n";
        print $commentFile $commitComment;
        close $commentFile;
    }
}


1;
