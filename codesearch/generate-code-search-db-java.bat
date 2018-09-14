@ECHO OFF

dir /b/a/s *.java    > cscope.files   
dir /b/a/s *.js >> cscope.files   
dir /b/a/s *.xml >> cscope.files   
dir /b/a/s *.sql  >> cscope.files   

cscope -cb

ctags --fields=+i -n -R -L cscope.files

cqmakedb -s .\project.db -c cscope.out -t tags -p