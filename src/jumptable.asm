.zeropage

.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch
.export	CHROUT
.export	CHRIN
.export	PRNTLN
.export	PRNT
.export	PRNL
.export	SETBNK
.export	GETBNK
.export	SNINIT
.export	SNWRT
.export	SHDLY
.export	RST
.export	KBINPUT
.export	KBGET
.export	KBSCAN
.export	KBINIT
.export	INPUT
.export	DLY

.segment "JMPTBL"

CHROUT:	JMP	_acia_putc        		;$FF00	print CHAR from regA
CHRIN:	JMP	_acia_getc        		;$FF03	get char from buffer to regA
PRNTLN:	JMP	_print_nl         		;$FF06	put new line and a string with start address in regA and regX "lda #<(STRING),ldx #>(STRING),jsr PRNTLN"
PRNT:	JMP	_acia_puts        		;$FF09	put a string with start address in regA and regX "lda #<(STRING),ldx #>(STRING),jsr PRNTLN"
PRNL:	JMP	_acia_put_newline 		;$FF0C	print a new line
SETBNK:	JMP	_set_bank         		;$FF0F	set bank to number from regA
GETBNK:	JMP	_get_bank         		;$FF12	get bank number to regA
SNINIT:	JMP	_sn_init          		;$FF15	Initialize SN76489 chipwith mute
SNWRT:	JMP	_sn_write_data    		;$FF18	write data from regA to sn76489
SHDLY:	JMP	__delay2          		;$FF1B
RST:	JMP	_loop             		;$FF1E
KBINPUT:	JMP	kbinput          		;$FF21
KBGET:	JMP	kbget             		;$FF24
KBSCAN:	JMP	kbscan            		;$FF27
KBINIT:	JMP	kbinit            		;$FF2A
INPUT:	JMP	INPUT_CHK         		;$FF2D
DLY:	JMP	_delay		;$FF30
