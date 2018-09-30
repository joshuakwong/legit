# legit commit
sub commit{
    initcheck();
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
    for (my $i=0; $i<$#args+1; $i++){
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
    if (!-d ".legit/commit"){
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
    foreach my $item (@filename){
        $item =~ s/.*\///;
    }
    my $emptyCommit = 0;
    if (!@filename){
        $emptyCommit = 1;
        @filename2 = glob (".legit/commit/$latestCommit/*"); 
        foreach my $item (@filename2){
            next if ($item =~ /comment/);
        }
        if ($#filename2 != 0){
            mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
            print "Committed as commit $commitFileName\n"; 
            goto COMMENT;
            exit 1;
        }
        else {
            print "nothing to commit\n";
            exit 1;
        }
    }

    my $fileDeleted = 0;
    if ($aPos == -1){
        # add files from commit to list of files,
        # do not push filename from 2nd list if already exist in first list
        # remove all directory characters except the filename itself
        if ($firstCommit == 0){
            @filename2 = glob (".legit/commit/$latestCommit/*"); 
            foreach my $commitItem (@filename2){
                #$commitItem =~ s/.*\///;
                $commitItem =~ s/.legit\/commit\/$latestCommit\///;
                next if ($commitItem =~ /comment/);
                if (grep (/^$commitItem$/, @filename) != 1){
                    #print ">>> hit deleted item: $commitItem\n";
                    $fileDeleted = 1;
                }
                else{
                    push(@filename, $commitItem) unless grep{$_ ne $commitItem} @filename;
                }
            }
        }

        

        use File::Copy;
        use File::Compare;
        # case if this is the first commit
        if ($firstCommit == 1){
            mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
            foreach my $item (@filename){
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
                    $allSame = 0;
                }
            }

            #print "hit\t $allSame \t $fileDeleted\n";
            if ($allSame == 0 || $fileDeleted == 1){
                #copy the rest
                foreach my $item (@sameFiles){
                    #print "$item\n";
                    mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                    copy(".legit/commit/$latestCommit/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
                } 
                print "Committed as commit $commitFileName\n";        
            }
            else {
                print "nothing to commit\n";
            }
        }
    }

    # a flag present
    else{ 
        #print ">>>yes -a flag\n";
        if ($firstCommit == 0){
            #print "not first commit\n";
            @filename2 = glob (".legit/commit/$latestCommit/*"); 
            foreach my $commitItem (@filename2){
                $commitItem =~ s/.legit\/commit\/$latestCommit\///;
                next if ($commitItem =~ /comment/);
                #print "$commitItem\n";
                if (grep (/^$commitItem$/, @filename) != 1){
                    #print "file detected\n";
                    $fileDeleted = 1;
                }
                else{
                    push(@filename, $commitItem) unless grep{$_ ne $commitItem} @filename;
                }
            }
        }

        
        # case if this is the first commit
        if ($firstCommit == 1){
            mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
            foreach my $item (@filename){
                copy("$file", ".legit/index/$item");
                copy(".legit/index/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
            }
            print "Committed as commit 0\n";        
        }
        
        else {
            my $allSame = 1;
            my @sameFiles;
            foreach my $item (@filename){
                #print ">>>file: $item\n";
                # file appear in both index and latest commit
                if (-e "$item" && -e ".legit/commit/$latestCommit/$item") {
                    #print "both exists\n";
                    # file are the same, copy from the latest commit to new commit
                    if (compare(".legit/commit/$latestCommit/$item", "$item") == 0){
                        #print "same file\n";
                        push (@sameFiles, "$item");
                    }
                    else {
                        #file are not the same, copy from index
                        mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                        copy("$item", ".legit/index/$item");
                        copy("$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
                        $allSame = 0;
                    }
                }
                # file only appear in index but not latest commit
                elsif (-e "$item" && !-e ".legit/commit/$latestCommit/$item") {
                    mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                    copy("$item", ".legit/index/$item");
                    copy("$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
                    $allSame = 0;
                }
                elsif (!-e "$file"){
                    $allSame = 0;
                }
            }

            if ($allSame == 0 || $fileDeleted == 1){
                #copy the rest
                foreach my $item (@sameFiles){
                    mkdir (".legit/commit/$commitFileName", 0700) if (!-d ".legit/commit/$commitFileName");
                    copy(".legit/commit/$latestCommit/$item", ".legit/commit/$commitFileName/$item") or die "copy fail";
                } 
                print "Committed as commit $commitFileName\n";        
            }
            else {
                print "nothing to commit\n";
            }
        }
    }
    
    COMMENT:
    #add comment
    if (-d ".legit/commit/$commitFileName"){
        my $commentDir = ".legit/commit/$commitFileName/comment";
        open my $commentFile, ">", $commentDir, or die "fail to write comments\n";
        print $commentFile $commitComment;
        close $commentFile;
    }
}


sub rm{
    my @argv = @_;
    initcheck();

    my $force = 0;
    my $cache = 0;
    my @fileList;
    # parse arguments#
    foreach my $arg (@argv){
        $force = 1 if ($arg =~ /--force/);
        $cache = 1 if ($arg =~ /--cache/);
        push(@fileList, $arg) if ($arg !~ /^--/);
    }
    my @commitHist = glob (".legit/commit/*");
    $latestCommit = pop(@commitHist);
    $latestCommit =~ s/\.legit\/commit\///;
    if (!defined $latestCommit){
        print "legit.pl: error: your repository does not have any commits yet\n";
        #print "legit.pl: error: no previous commit history\n";
        exit 1;
    }

    use File::Compare;
    foreach my $file (@fileList){
        my $resA = compare("$file", ".legit/index/$file");
        my $resB = compare(".legit/index/$file", ".legit/commit/$latestCommit/$file");
        my $resC = compare(".legit/commit/$latestCommit/$file", "$file");

        # case 1
        if (($resA == 0) && ($resB == 0) && ($resC == 0)){
            #print "hit\n";
            unlink ".legit/index/$file";
            #if ($cache == 0 && $force == 1){
            if ($cache == 0){
                unlink "$file";
            }
        }

        # case 2
        elsif (($resA != 0) && ($resB != 0) && ($resC == 0)){
            if ($force == 1){

            }
            #unlink "$file" if ($cache == 0 && $force == 1);
            #if (-e ".legit/index/$file"){
            #    if ($force == 0){
            #        print "legit.pl: error: '$file' in index is different to both working file and repository\n";
            #    }
            #    else {
            #        unlink ".legit/index/$file";
            #    }
            #}
            #else {
            #    print "legit.pl: error: '$file' is not in the legit repository\n";
            #}
        }

        # case 3
        elsif (($resA == 0) && ($resB != 0) && ($resC != 0)){
            #if ($cache == 0){
            #    print "legit.pl: error: '$file' has changes staged in the index\n";
            #}
            if ($force == 1){
                if ($cache == 0 && -e ".legit/index/$file"){
                    unlink "$file";
                }
                else{
                    next;
                }
                unlink ".legit/index/$file";
            }
            #&& !-e ".legit/commit/$latestCommit/$file"
            else{
                if ($cache == 1 ){
                    unlink ".legit/index/$file";
                }
                else{
                    print "legit.pl: error: '$file' has changes staged in the index\n";
                }
            }
        }

        # case 4
        elsif (($resA != 0) && ($resB == 0) && ($resC != 0)){
            unlink ".legit/index/$file";
            if (-e "$file"){
                print "legit.pl: error: '$file' in repository is different to working file\n";
            }
            else {
                print "legit.pl: error: ?????4\n";
            }
        }

        # case 5
        elsif (($resA != 0) && ($resB != 0) && ($resC != 0)){
            #print "case5\n";
            if (!-e "$file" && !-e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
                print "legit.pl: error: '$file' is not in the legit repository\n";
            }
            elsif (!-e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
                print "legit.pl: error: '$file' is not in the legit repository\n";
            }
            elsif (!-e "$file" && !-e ".legit/commit/$latestCommit/$file"){
                print "legit.pl: error: ?????5\n";
            }
            #elsif (!-e "file" && !-e ".legit/index/$file"){
            #    print "legit.pl: error: -----5\n";
            #}
            elsif (!-e "$file"){
                print "legit.pl: error: '$file' in index is different to both working file and repository\n";
            }
            elsif (!-e ".legit/index/$file"){
                if ($force == 1){
                    unlink "$file";
                    print "legit.pl: error: '$file' is not in the legit repository\n";
                }
            }
            elsif (!-e ".legit/commit/$latestCommit/$file"){
                print "legit.pl: error: +++++5\n";
            }
            elsif (-e "$file" && -e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
                if ($force == 0){
                    print "legit.pl: error: '$file' in index is different to both working file and repository\n";
                }
                else {
                    unlink "$file";
                    unlink ".legit/index/$file";
                }
            }
        }
    }
}



sub status{
    initcheck();

    my @commitHist = glob (".legit/commit/*");
    $latestCommit = pop(@commitHist);
    $latestCommit =~ s/\.legit\/commit\///;
    if (!defined $latestCommit){
        print "legit.pl: error: no previous commit history\n";
        exit 1;
    }

    my @filename = glob ("./*");
    foreach my $file (@filename){
        $file =~ s/.*\///;
    }
    my @tempList = glob (".legit/index/*");
    foreach my $item(@tempList){
        $item =~ s/.*\///;
        next if ($item =~ /comment/);
        push(@filename, $item) unless grep{$_ eq $item} @filename;
    }
    @tempList = glob (".legit/commit/$latestCommit/*");
    foreach my $item(@tempList){
        $item =~ s/.*\///;
        next if ($item =~ /comment/);
        push(@filename, $item) unless grep{$_ eq $item} @filename;
    }

    foreach my $file (sort @filename){
        my $resA = compare("$file", ".legit/index/$file");
        my $resB = compare(".legit/index/$file", ".legit/commit/$latestCommit/$file");
        my $resC = compare(".legit/commit/$latestCommit/$file", "$file");

        if (!-e "$file" && !-e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            print "$file - deleted\n";
        }

        elsif (!-e "$file" && -e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            print "$file - file deleted\n";
        }
        elsif (-e "$file" && !-e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - untracked\n";
        }

        elsif (-e "$file" && !-e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            print "$file - untracked\n";
        }

        elsif (!-e "$file" && -e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - added to index\n";
        }
        elsif (-e "$file" && -e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - added to index\n";
        }

        elsif (-e "$file" && -e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            if ($resA == 0 && $resB == 0 && $resC == 0){
                print "$file - same as repo\n";
            }
            elsif ($resA != 0 && $resB != 0 && $resC != 0){
                print "$file - file changed, different changes staged for commit\n";
            }
            elsif ($resA == 0 && $resB != 0 && $resC != 0){
                print "$file - file changed, changes staged for commit\n";
            }
            elsif ($resA != 0 && $resB == 0 && $resC != 0){
                print "$file - file changed, changes not staged for commit\n";
            }
            elsif ($resA != 0 && $resB != 0 && $resC == 0){
                print "$file - file changed, changes staged for commit\n";
            }
        }


        elsif (-e "$file" && -e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - added to index\n";
        }
    }
}

1;
