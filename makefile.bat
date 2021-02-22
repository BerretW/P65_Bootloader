for %%a in (".\src\*.asm") do (
ca65.exe -I .\include -l .\output\%%~na.lst -o .\output\%%~na.o .\%%a
)
cd .\output
cl65.exe -m ram.map main.o utils.o zeropage.o ram_disk.o ewoz.o sn76489.o acia.o pckybd.o gameduino.o spi.o jumptable.o -C ..\config\RAM_DISK.cfg -o ramdisk.bin
cl65.exe -m rom.map main.o utils.o zeropage.o ram_disk.o ewoz.o sn76489.o acia.o pckybd.o gameduino.o spi.o jumptable.o -C ..\config\appartus.cfg -o ROM.bin
cl65.exe main.o utils.o zeropage.o ram_disk.o ewoz.o sn76489.o acia.o pckybd.o gameduino.o spi.o jumptable.o -C ..\config\bank_ram_disk.cfg -o BANK.bin
