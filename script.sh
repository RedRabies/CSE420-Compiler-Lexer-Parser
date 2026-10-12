#!/bin/bash

# Auto-detect flex and bison/yacc commands for Windows vs Linux compatibility
YACC_CMD="yacc"
FLEX_CMD="flex"
GPP_CMD="g++"

# If we are on Windows and standard commands are missing, fallback to win_bison/win_flex
if ! command -v yacc &> /dev/null; then
    # Use full path for this specific laptop's winget installation
    YACC_CMD="/c/Users/ASUS/AppData/Local/Microsoft/WinGet/Packages/WinFlexBison.win_flex_bison_Microsoft.Winget.Source_8wekyb3d8bbwe/win_bison.exe"
fi

if ! command -v flex &> /dev/null; then
    # Use full path for this specific laptop's winget installation
    FLEX_CMD="/c/Users/ASUS/AppData/Local/Microsoft/WinGet/Packages/WinFlexBison.win_flex_bison_Microsoft.Winget.Source_8wekyb3d8bbwe/win_flex.exe"
fi

if ! command -v g++ &> /dev/null; then
    # Use full path for this specific laptop's winget installation
    GPP_CMD="/c/Users/ASUS/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.MCF.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin/g++.exe"
fi

$YACC_CMD -d -y --debug --verbose 22301737_21201675.y
echo 'Generated the parser C file as well the header file'

$GPP_CMD -w -c -o y.o y.tab.c
echo 'Generated the parser object file'

$FLEX_CMD 22301737_21201675.l
echo 'Generated the scanner C file'

$GPP_CMD -fpermissive -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'

$GPP_CMD y.o l.o -o a.exe
echo 'All ready, running'

./a.exe input.txt