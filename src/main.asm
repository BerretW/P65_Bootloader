				.setcpu "65C02"
				.include "io.inc65"
				.include "zeropage.inc65"


				.autoimport	on


				.export main
                .segment "VECTORS"

                .word   nmi
                .word   reset
                .word   irq


                .segment "CODE"


reset:          SEI
								JMP main

nmi:            JMP (RAMDISK_NMI_VECTOR)
								RTI

irq:            JMP (RAMDISK_IRQ_VECTOR)
								RTI


main:
								JSR _acia_init
								JMP _bootloader_
