@ECHO OFF

ECHO Starting PHP FastCGI...


REM We want to set the php path
set PATH=./php;%PATH%

REM Lets run php-cgi
.\php\php-cgi.exe -b 127.0.0.1:9000