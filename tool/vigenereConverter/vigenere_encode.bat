echo off
set dir=%CD%
cd %~p1
for %%v in (*%~x1) do %dir%\vigenere.exe "%%v" "%%~nv.dat" "encode" "zi9W6TVsrJ05Fote7kaECTxK3yyv0Qmrf9qLo1HwPkedmPDPGUS0DGrHnZnBJdfJ"
