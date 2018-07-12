$directories = ls ./ | ?{$_.PSISContainer}

foreach ($dir in $directories) {
    cd $dir
    
    if (Test-path .\.git) {
        git pull origin master    
    }

    cd ..
}