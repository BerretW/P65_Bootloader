# P65_Bootloader
You need "build" package installed in ATOM
F9 for build
and run makefile.bat for finish, or run makefile.bat it will do its thing. :D
We already have a functional jump table, which greatly simplifies the programming of other applications for the P65.

Board has Prioritised Interrupts by http://www.6502.org/mini-projects/priority-interrupt-encoder/priority-interrupt-encoder.html

The bootloader has built-in routines, for easier programming, their use and auxiliary functions can be found in the file jumptable.xls, which internally generates files for your programs in C and asm.
