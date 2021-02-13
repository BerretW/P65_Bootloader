.include "io.inc65"
.include "macros.inc65"
.include "zeropage.inc65"


	.fopt		compiler,"cc65 v 2.19 - Git a861d84"
	.setcpu		"65C02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.export		_GD_Init
	.export		_spr
	.export _GD_print_char
	.export _GD_print
	.export _GD_WR_8
	.export _GD_puts
	.export _GD_print_nl
	.export _GD_newLine
	.export _GD_RD_8
	.export _GD_clr_scr
	.export _GD_fill
	.export _GD_push

.segment	"DATA"

.segment "ZEROPAGE"
_posx: .res 1,$00
_posy: .res 1,$00
_str_tmp: .res 2, $00
_str_pos: .res 1, $00

.segment	"BSS"

_spr:
	.res	1,$00

.segment	"CODE"
; ---------------------------------------------------------------
; _start(char * addr)
; in X = Hibyte of start address
; in A = Lobyte of start address
; ---------------------------------------------------------------
__start:			PHA
							LDA #14
							JSR _spi_begin
							TXA
							ORA #$80
							CLC
							TAX
							PLA
							JSR _spi_set_addr
							RTS
; ---------------------------------------------------------------
; void __near__ GD_Init (void)
; ---------------------------------------------------------------
_GD_Init:	JSR _GD_res_cur
					jsr _spi_init
					JSR _GD_clr_scr
					RTS

; ---------------------------------------------------------------
; GD_res_cur
; ---------------------------------------------------------------
_GD_res_cur:	STZ _posx
							STZ _posy
							RTS
; ---------------------------------------------------------------
; GD_clr_scr
; clear character screen area
; ---------------------------------------------------------------
_GD_clr_scr:	LDA #$0
							STA ptr1
							LDX #$0
							LDA #$0
							LDY #$0

							JSR _GD_fill
							;JSR _GD_push

							LDX #$40
							LDA #$00
							LDY #$7F
							STZ ptr1
							JSR _GD_fill
							RTS


; ---------------------------------------------------------------
; GD_push
; push number(Y) of characters(ptr1) to Gameduino from start at X A
; in X = Hibyte of start address
; in A = Lobyte of start address
; in Y = Last page filled
; in ptr1 = data to fill
; ---------------------------------------------------------------
_GD_push:			PHA
							INY
							STY tmp1

							LDA #14
							JSR _spi_begin

							TXA
							ORA #$80
							CLC

							TAX
							PLA
							JSR _spi_set_addr

@_push:				PHA
							LDA ptr1
							JSR _spi_write
							PLA
							INC
							BNE @_push
							INX
							CPX tmp1
							BNE @_push
@end:					JMP _spi_end




; ---------------------------------------------------------------
; GD_fill
; in X = Hibyte of start address
; in A = Lobyte of start address
; in Y = Last page filled
; in ptr1 = data to fill
; ---------------------------------------------------------------
_GD_fill:			INY
							STY tmp1

@fill:				JSR _GD_WR_8
							INC
							BNE @fill
							INX
							CPX tmp1
							BNE @fill
@end:					RTS





; ---------------------------------------------------------------
; void GD_wr_8(char * addr, char data)
; in X = Hibyte of address
; in A = Lobyte of address
; in ptr1 = data to write
; ---------------------------------------------------------------
_GD_WR_8: 	phaxy
						JSR __start
					 	LDA ptr1
						JSR _spi_write
						JSR _spi_end
						plaxy
						RTS
; ---------------------------------------------------------------
;	GD_rd
; in X = Hibyte of address
; in A = Lobyte of address
; out A = return byte
; return
; ---------------------------------------------------------------
_GD_RD_8:		TAY
						LDA #14
						JSR _spi_begin
						TYA

						JSR _spi_set_addr

						LDA #$0
						JSR _spi_read
						STA ptr1
						JSR _spi_end
						LDA ptr1
						RTS


; void GD_puts(const char * s)
; Send the zero terminated string pointed to by A/X
; @in A/X (s) pointer to the string to send
; @mod ptr1
_GD_puts:						phy
										phx
										pha
                    sta ptr3
                    stx ptr3 + 1
                    ldy #0
										STY ptr4
@next_char:         LDY ptr4
										lda (ptr3),y
                    beq @eos
                    jsr _GD_print
                    inc ptr4
                    bne @next_char
@eos:								PLA
										PLX
										PLY
                    rts

; ---------------------------------------------------------------
; void GD_newline
; increase line number and set cursor to start of line
; ---------------------------------------------------------------
_GD_newLine:			INC _posy
									STZ _posx
									RTS

; ---------------------------------------------------------------
; void GD_print_nl(const char * s)
; increase line number and set cursor to start of line
; and print string to new position
; ---------------------------------------------------------------

_GD_print_nl:			JSR _GD_puts
									JMP _GD_newLine

; ---------------------------------------------------------------
; void GD_putchar (char c)
; Put character at cursor position
; in X = position at x
; in Y = position at y
; in A = Char to print
; if Z = 1 then exit
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_GD_putchar: near

.segment	"CODE"
							PHA
							PLA
							BEQ @end
							clc
							CLD

							PHA
							LDA #14
							JSR _spi_begin

							TYA
							PHA
							AND #$FC
							;CLC
							ROR
							ROR
							ADC #$80
							JSR _spi_write
							PLA
							AND #$3
							ROL
							ROL
							ROL
							ROL
							ROL
							ROL
							STA ptr2
							TXA
							AND #$3F
							ADC ptr2
							JSR _spi_write
							PLA
							JSR _spi_write
							JSR _spi_end
@end:					RTS

.endproc

; ---------------------------------------------------------------
; void get_cursor_pos ()
; out X = position of cursor at x 0 - 49
; out Y = position of cursor at y 0 - 36
;
; ---------------------------------------------------------------
_get_cursor_pos: 	LDX _posx
									LDY _posy
									RTS


; ---------------------------------------------------------------
; void GD_print_char()
; in A = char to print
; ---------------------------------------------------------------
_GD_print: 				JSR _check_char
_GD_print_char:		JSR _get_cursor_pos
									JSR _GD_putchar
									JSR _GD_next_pos
									RTS

; --------------------------------------------------------------
; void _check_char
; check if in A is printable character, if not then set Z = 1
; --------------------------------------------------------------
_check_char:
							BEQ @end
							CMP #$94
							BEQ @left
							CMP #$96
							BEQ @right
							CMP #$98
							BEQ @up
							CMP #$92
							BEQ @down
							CMP #$08
							BEQ @bksp
							RTS

@left:				JSR _GD_prev_pos
							LDA #$0
							RTS

@right:				RTS
@up:					RTS
@down:				RTS
@del:					RTS
@ent:					RTS
@bksp:				JSR _GD_prev_pos
							LDA #$20
							JSR _get_cursor_pos
							JSR _GD_putchar
							LDA #0
							RTS
@end:					RTS
; --------------------------------------------------------------
; void GD_prev_pos()
; update position of cursor by 1 character left
; --------------------------------------------------------------
_GD_prev_pos:	LDX _posx
							BNE @_decx
							LDX #50
							STX _posx
							DEC _posy
@_decx:				DEX
							STX _posx
							RTS

; ---------------------------------------------------------------
; void GD_next_pos ()
; update position of cursor by 1 character right
; ---------------------------------------------------------------
_GD_next_pos:

							LDX _posx
							LDY _posy
							PHA
							PLA
							BEQ @end
							INX
							CPX #50
							BNE @end
							LDX #0
							STX _posx
							INY
							CPY #37
							BNE @end
							LDY #0
							STY _posy
@end:					STX _posx
							STY _posy
							RTS
