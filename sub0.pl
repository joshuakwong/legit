
#initialize .legit directory
sub initdir{
    if (-d ".legit"){
        print "legit.pl: error: .legit already exists\n";
    }
    else {
        mkdir(".legit", 0700);
        print "Initialized empty legit repository in .legit\n";
    }
}



# index file, stores the latest copy of the added files
sub add{
    my (@files) = @_;
    if (!-d ".legit"){ #legit not initialized
        print "legit.pl: error: .legit not yet initialized\n";
        return;
    }

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



















1;
