.include "io.inc65"
.include "macros.inc65"

.zeropage
_delay_lo:				.res 1
_delay_hi:				.res 1

.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch

.export _format_bank
.export _set_bank
.export _get_bank
.export __delay2
.export _print_nl
.export INPUT_CHK
.export _delay
.export _via_test
.export _INTE
.export _INTD
.export _GET_INT

.segment "RODATA"
msg_0:			.byte "Mazu BANKDISK", $00

.segment "CODE"
INPUT_CHK:
@END:			RTS

_set_bank:
					STA BANK_BASE
					;CLC
					;ADC #$30
					;JSR _acia_putc
					RTS
_get_bank:  LDA BANK_BASE
            RTS



_via_test:	LDA #$FF
						STA VIA2_DDRB
						LDA #$55
						STA VIA2_ORB
						JSR _delay
						LDA #$AA
						STA VIA2_ORB
						JSR _delay
						JMP _via_test

via_loop:			JSR CHRIN
						STA VIA2_ORB
						JSR CHROUT
						JMP via_loop
; ---------------------------------------------------------------
; void __near__ print_f (char *s)
; ---------------------------------------------------------------

_print_nl:
            jsr     _acia_put_newline
            JMP     _acia_puts


_format_bank:
                  LDY #0
                  LDA #<(BANKDISK)
                  LDX #>(BANKDISK)
                  STA ptr1
                  STX ptr1 + 1

@write_BANK:			LDA #$0
                  STA (ptr1), Y
                  INY
                  CPY #$0
                  BNE @end_BANK
                  INX
                  STX ptr1 + 1
                  CPX #$C0
                  BNE @end_BANK
                  RTS
@end_BANK:			  JMP @write_BANK

_GET_INT:   LDA $CF20
            RTS

_INTE:  CLI
        RTS
_INTD:  SEI
        RTS


_delay:
  STA _delay_lo  ; save state
  LDA #$00
  STA _delay_hi  ; high byte
delayloop:
  ADC #01
  BNE delayloop
  CLC
  INC _delay_hi
  BNE delayloop
  CLC
  ; exit
  LDA _delay_lo  ; restore state
  RTS

__delay2:				LDX #$2
__delay3:				DEX
                BNE __delay3
                RTS
