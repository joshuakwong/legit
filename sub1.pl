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
    # flag $emptyCommit used to indicate if the commit contains no files
    # if ($empty commit)
    #   get list of files from latest commit
    #
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
    
    # if the -a flag is not found
    if ($aPos == -1){
        # add files from commit to list of files,
        # do not push filename from 2nd list if already exist in first list
        # remove all directory characters except the filename itself
        if ($firstCommit == 0){
            @filename2 = glob (".legit/commit/$latestCommit/*"); 
            foreach my $commitItem (@filename2){
                $commitItem =~ s/.legit\/commit\/$latestCommit\///;
                next if ($commitItem =~ /comment/);
                if (grep (/^$commitItem$/, @filename) != 1){
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

    # a flag present
    else{ 
        if ($firstCommit == 0){
            @filename2 = glob (".legit/commit/$latestCommit/*"); 
            foreach my $commitItem (@filename2){
                $commitItem =~ s/.legit\/commit\/$latestCommit\///;
                next if ($commitItem =~ /comment/);
                if (grep (/^$commitItem$/, @filename) != 1){
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
                # file appear in both index and latest commit
                if (-e "$item" && -e ".legit/commit/$latestCommit/$item") {
                    # file are the same, copy from the latest commit to new commit
                    if (compare(".legit/commit/$latestCommit/$item", "$item") == 0){
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
    
    #add comment
    COMMENT:
    if (-d ".legit/commit/$commitFileName"){
        my $commentDir = ".legit/commit/$commitFileName/comment";
        open my $commentFile, ">", $commentDir, or die "fail to write comments\n";
        print $commentFile $commitComment;
        close $commentFile;
    }
}

# legit rm [--force] [--cached] <file_1>..<file_n>
sub rm{
    initcheck();
    my @argv = @_;

    my $force = 0;
    my $cache = 0;
    my @fileList;
    # parse arguments#
    foreach my $arg (@argv){
        $force = 1 if ($arg =~ /--force/);
        $cache = 1 if ($arg =~ /--cache/);
        push(@fileList, $arg) if ($arg !~ /^--/);
    }

    # get the list of commit history
    # then pop the last element to get the latest commit
    # if $latestCommit is not defined, then this is the first commit
    my @commitHist = glob (".legit/commit/*");
    $latestCommit = pop(@commitHist);
    $latestCommit =~ s/\.legit\/commit\///;
    if (!defined $latestCommit){
        print "legit.pl: error: your repository does not have any commits yet\n";
        exit 1;
    }

    use File::Compare;
    foreach my $file (@fileList){
        # file comparison results
        # $curIndComp is the comparison between $file in current directory and in index
        # $indComComp is the comparison between $file in index and in latest commit
        # $curComComp is the comparison between $file in current directory and in latest commit 
        my $curIndComp = compare("$file", ".legit/index/$file");
        my $indComComp = compare(".legit/index/$file", ".legit/commit/$latestCommit/$file");
        my $curComComp = compare(".legit/commit/$latestCommit/$file", "$file");


        # All cases will be formated as follow
        # ------------------------------------
        #     current   index   latest
        #       dir             commit
        # ------------------------------------
        # e.g.   X        1        1   
        # indicates file does not exit in current dir, and index and commit has the same ver
        #
        # e.g.   3        2        1
        # indicates file exist in all dir, and are different versions

        # case 1
        # 1 1 1
        if (($curIndComp == 0) && ($indComComp == 0) && ($curComComp == 0)){
            #print "hit\n";
            unlink ".legit/index/$file";
            #if ($cache == 0 && $force == 1){
            if ($cache == 0){
                unlink "$file";
            }
        }

        # case 2
        # 1 2 1  or  1 X 1
        elsif (($curIndComp != 0) && ($indComComp != 0) && ($curComComp == 0)){
            if ($force == 1){
                if ($cache == 1){
                    if (-e ".legit/index/$file"){
                        unlink ".legit/index/$file";
                    }
                    else{
                        print "legit.pl: error: '$file' is not in the legit repository\n";
                    }
                }
                else {
                    if (-e ".legit/index/$file"){
                        unlink ".legit/index/$file";
                        unlink "$file";
                    }
                    else{
                        print "legit.pl: error: '$file' is not in the legit repository\n";
                    }
                }
            }

            else{
                if ($cache == 1){
                    if (-e ".legit/index/$file"){
                        print "legit.pl: error: '$file' in index is different to both working file and repository\n";
                    }
                    else{
                        print "legit.pl: error: '$file' is not in the legit repository\n";
                    }
                }
                else {
                    if (-e ".legit/index/$file"){
                        print "legit.pl: error: '$file' in index is different to both working file and repository\n";
                    }
                    else{
                        print "legit.pl: error: '$file' is not in the legit repository\n";
                    }
                }
            }
        }

        # case 3
        # 2 2 1  OR  2 2 X
        elsif (($curIndComp == 0) && ($indComComp != 0) && ($curComComp != 0)){
            if ($force == 1){
                if ($cache == 0){
                    unlink "$file";
                }
                unlink ".legit/index/$file";
            }
            else{
                if ($cache == 0){
                    print "legit.pl: error: '$file' has changes staged in the index\n";
                }
                else{
                    unlink ".legit/index/$file";
                }
            }
        }

        # case 4
        # 2 1 1  OR  X 1 1
        elsif (($curIndComp != 0) && ($indComComp == 0) && ($curComComp != 0)){
            if ($force == 1){
                unlink ".legit/index/$file";
                unlink "$file" if (-e "$file" && $cache == 0);
            }
            else{
                if (-e "$file" && $cache == 0){
                    print "legit.pl: error: '$file' in repository is different to working file\n";
                }
                else{
                    unlink ".legit/index/$file";
                }
            }
        }

        # case 5
        elsif (($curIndComp != 0) && ($indComComp != 0) && ($curComComp != 0)){
            # case 5.0
            # X X X
            if (!-e "$file" && !-e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
                print "legit.pl: error: '$file' is not in the legit repository\n";
            }

            #case 5.1
            # 1 X X
            elsif (!-e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
                print "legit.pl: error: '$file' is not in the legit repository\n";
            }

            #case 5.2
            # X 1 X
            elsif (!-e "$file" && !-e ".legit/commit/$latestCommit/$file"){
                unlink ".legit/index/$file";
            }
            
            #case 5.3
            # X X 1
            elsif (!-e "$file" && !-e ".legit/index/$file"){
                print "legit.pl: error: '$file' is not in the legit repository\n";
            }

            #case 5.4
            # X 2 1
            elsif (!-e "$file"){
                unlink ".legit/index/$file";
            }
            
            #case 5.5
            # 2 X 1
            elsif (!-e ".legit/index/$file"){
                print "legit.pl: error: '$file' is not in the legit repository\n";
            }

            #case 5.6
            # 2 1 X
            elsif (!-e ".legit/commit/$latestCommit/$file"){
                if ($force == 1){
                    unlink ".legit/index/$file";
                    if ($cache == 0){
                        unlink "$file";
                    }
                }
                else{
                    print "legit.pl: error: '$file' in index is different to both working file and repository\n";
                }
            }

            #case 5.7
            # 3 2 1 
            elsif (-e "$file" && -e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
                if ($force == 0){
                    print "legit.pl: error: '$file' in index is different to both working file and repository\n";
                }
                else {
                    unlink ".legit/index/$file";
                    unlink "$file" if ($cache == 0);
                }
            }
        }
    }
}


# legit status
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
        # file comparison results
        # $curIndComp is the comparison between $file in current directory and in index
        # $indComComp is the comparison between $file in index and in latest commit
        # $curComComp is the comparison between $file in current directory and in latest commit 
        my $curIndComp = compare("$file", ".legit/index/$file");
        my $indComComp = compare(".legit/index/$file", ".legit/commit/$latestCommit/$file");
        my $curComComp = compare(".legit/commit/$latestCommit/$file", "$file");

        # All cases will be formated as follow
        # ------------------------------------
        #     current   index   latest
        #       dir             commit
        # ------------------------------------
        # e.g.   X        1        1   
        # indicates file does not exit in current dir, and index and commit has the same ver
        #
        # e.g.   3        2        1
        # indicates file exist in all dir, and are different versions
        
        # case 1
        # X X 1
        if (!-e "$file" && !-e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            print "$file - deleted\n";
        }

        # case 2
        # X 1 1
        elsif (!-e "$file" && -e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            print "$file - file deleted\n";
        }

        # case 3
        # 1 X X
        elsif (-e "$file" && !-e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - untracked\n";
        }

        # case 4
        # 1 X 1
        elsif (-e "$file" && !-e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            print "$file - untracked\n";
        }

        # case 5
        # X 1 X
        elsif (!-e "$file" && -e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - added to index\n";
        }

        # case 6
        # 1 1 X
        elsif (-e "$file" && -e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - added to index\n";
        }

        # case 7
        elsif (-e "$file" && -e ".legit/index/$file" && -e ".legit/commit/$latestCommit/$file"){
            # case 7.1 
            # 1 1 1
            if ($curIndComp == 0 && $indComComp == 0 && $curComComp == 0){
                print "$file - same as repo\n";
            }
            
            # case 7.2 
            # 3 2 1
            elsif ($curIndComp != 0 && $indComComp != 0 && $curComComp != 0){
                print "$file - file changed, different changes staged for commit\n";
            }

            # case 7.3
            # 2 2 1
            elsif ($curIndComp == 0 && $indComComp != 0 && $curComComp != 0){
                print "$file - file changed, changes staged for commit\n";
            }

            # case 7.4
            # 2 1 1
            elsif ($curIndComp != 0 && $indComComp == 0 && $curComComp != 0){
                print "$file - file changed, changes not staged for commit\n";
            }

            # case 7.5
            # 2 1 2
            elsif ($curIndComp != 0 && $indComComp != 0 && $curComComp == 0){
                print "$file - file changed, changes staged for commit\n";
            }
        }

        

        # case 8
        # 1 1 X
        elsif (-e "$file" && -e ".legit/index/$file" && !-e ".legit/commit/$latestCommit/$file"){
            print "$file - added to index\n";
        }
    }
}

1;
