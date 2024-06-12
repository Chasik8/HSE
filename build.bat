@echo off

rem скомпилировать файл main.c в объектный файл main.obj
gcc -m32 -c integral.c -o main.o

rem скомпилировать файл add.asm в объектный файл add.o
nasm --gprefix _ -f win32 function.asm -o function.o

rem линкуем скомиленные asm и c файлы
gcc -m32 main.o function.o -o program.exe

rem запустить исполняемый файл program.exe
program.exe

rem prog.exe

rem pause
