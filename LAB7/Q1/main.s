;******************** (C) Andrew Wolfe *******************************************
; @file    main_hw_proto.s
; @author  Andrew Wolfe
; @date    August 29, 2019
; @note
;           This code is for the book "Embedded Systems with ARM Cortex-M 
;           Microcontrollers in Assembly Language and C, Yifeng Zhu, 
;           ISBN-13: 978-0982692639, ISBN-10: 0982692633 as used at Santa Clara University
;*******************************************************************************



	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s   

	INCLUDE leds.h

	INCLUDE	adc.h

	
			AREA    main, CODE, READONLY
			EXPORT	__main				
			ENTRY			
				
__main	PROC
	

; Add code here to configure the proper GPIO port to drive the red LED.  
; You may use the routines provided in leds.s 		
		LDR r0, =(RCC_BASE + RCC_AHB2ENR) ;activates red clock
		LDR r1, [r0]
		ORR r1, #RCC_AHB2ENR_GPIOBEN
		STR r1, [r0]
			
		LDR r0, =(GPIOB_BASE+GPIO_MODER) ;sets up digital output
		LDR r1, [r0]
		BIC r1, r1, #(0x03<<(2*2))
		ORR r1, r1, #(1<<(2*2))
		STR r1, [r0]
		bl		adc_init

loop	bl		adc_read
		cmp r0, #2048
		blt	off
		bge on
		
off 	bl red_off
		b loop
on 		bl red_on
		b loop

		
; Add and/or modify code here to repeatedly read the A/D converter and turn the red LED on if 
; the reading is greater than or equal to 2048 and turn off the red LED is the reading is less than that.

endless	b		endless		
		ENDP
			
	

			
			
			ALIGN						
			AREA    myData, DATA, READWRITE
			
			ALIGN			


	END
