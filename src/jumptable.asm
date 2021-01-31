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
.export	INTE
.export	INTD
.export	GET_INT
.export ACIA_SCAN

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
SHDLY:	JMP	__delay2          		;$FF1B	Short delay
RST:	JMP	_bootloader_		;$FF1E	Restart to bootloader
KBINPUT:	JMP	kbinput          		;$FF21	get key from PS2 keyboard
KBGET:	JMP	kbget             		;$FF24
KBSCAN:	JMP	kbscan            		;$FF27
KBINIT:	JMP	kbinit            		;$FF2A	Initialise PS2 keyboard
INPUT:	JMP	INPUT_CHK         		;$FF2D
DLY:	JMP	_delay		;$FF30	Long delay
INTE:	JMP	_INTE		;$FF33	Enable Interrupts
INTD:	JMP	_INTD		;$FF36	Disable Interrupts
GET_INT:	JMP	_GET_INT		;$FF39	Get Interrupt number 0 = IRQ0, 2 = IRQ1, 4 = IRQ2, 6 = IRQ3, 8 = IRQ4, A = IRQ5, C = IRQ6, E = IRQ7
ACIA_SCAN:	JMP	_acia_scan		;$FF3C	scan acia for character, if no return 0
