	.text
	.align 2
	.global setPixColor
	.global pixel
	.global circle
	.extern currentPixColor 
	.extern FrameBufferGetAddress
	.extern FrameBufferGetWidth


setPixColor:
	ldr	r1, =currentPixColor
	str	r0, [r1]
	bx	lr


pixel:
	/* ieejas parametri: x, y, color addr */
	push	{r0-r2, lr}
	bl	FrameBufferGetAddress
	str	r0, [sp, #-4]!	
	bl	FrameBufferGetWidth
	str	r0, [sp, #-4]!	
/* sp-> width, FrameBuffer addr, x, y, color addr, lr */
/* steka ir ierakstitas 6 vertibas */
	ldr	r0, [sp, #8]	@ x
	ldr	r1, [sp, #12]	@ y
	ldr	r2, [sp]		@ width
	mla	r3, r1, r2, r0	@ width*y+x : FrameBuffer indekss, kurs jaiekraso
	ldr	r1, [sp, #16]	@ color addr
	ldr	r1, [r1]		@ color value
	ldr	r2, [sp, #4]	@ FrameBuffer addr
/* r1: color, r2: FrameBuffer addr, r3: FrameBuffer index */
	lsr	r0, r1, #30		@ panemam tikai pirmos 2 bitus - op lauks (sakuma nevis beigas, jo little endian)
	cmp	r0, #0
	beq	.Lpixel_copy
	cmp	r0, #1
	beq	.Lpixel_and
	cmp	r0, #2
	beq	.Lpixel_or
	cmp	r0, #3
	beq	.Lpixel_xor
	@ neatbilstosa op lauka veriba, ja seit tiek
.Lerror_pixel:
	mov	r0, #1
	b	.Lend_pixel
.Lpixel_copy:
	str	r1, [r2, r3, LSL #2]	@ parkope/parraksta pari jauno krasu
	b	.Lend_pixel
.Lpixel_and:
	ldr	r0, [r2, r3, LSL #2]	@ r0 ieliekam pasreizejo krasu
	and	r0, r0, r1
	str	r0, [r2, r3, LSL #2]	@ iekrasojam
	b	.Lend_pixel
.Lpixel_or:
	ldr	r0, [r2, r3, LSL #2]	@ pasreizeja krasa
	orr	r0, r0, r1
	str	r0, [r2, r3, LSL #2]	@ iekrasojam
	b	.Lend_pixel
.Lpixel_xor:
	ldr	r0, [r2, r3, LSL #2]	@ pasreizeja krasa
	eor	r0, r0, r1
	str	r0, [r2, r3, LSL #2]	@ iekrasojam
	b	.Lend_pixel
.Lend_pixel:
	add	sp, sp, #20
	pop	{lr}
	bx	lr


draw_8_symmetric_points:
	/* Paligfunkcija prieks funkcijas circle()
	*  Ieejas parametri ir x0, y0, dx, dy
	*  Rinka linijai ar centru x0, y0 uzzime apkart
	*  8 punktus katru sava oktantaa. dx, dy define tikai
	*  vienu rinka linijas punktu, kas atrodas 0-45 gradu
	*  regiona. */
	push	{r0-r3, lr}
	ldr r2, =currentPixColor
	ldr r2, [r2]
	push	{r2}

	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	add	r0, r0, r3	@ x0+dx
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	add r1, r1, r3	@ y0+dy
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	add	r0, r0, r3	@ x0+dx
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	sub r1, r1, r3	@ y0-dy
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	sub	r0, r0, r3	@ x0-dx
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	add r1, r1, r3	@ y0+dy
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	sub	r0, r0, r3	@ x0-dx
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	sub r1, r1, r3	@ y0-dy
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	add	r0, r0, r3	@ x0+dy
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	add r1, r1, r3	@ y0+dx
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	add	r0, r0, r3	@ x0+dy
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	sub r1, r1, r3	@ y0-dx
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	sub	r0, r0, r3	@ x0-dy
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	add r1, r1, r3	@ y0+dx
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	sub	r0, r0, r3	@ x0-dy
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	sub r1, r1, r3	@ y0-dx
	ldr r2, [sp]
	bl	pixel

	pop {r2}
	pop {r0-r3, pc}


circle:
	push {r0-r2, lr}
	sub	sp, sp, #20

	mov r0, #0
	str r0, [sp]		@ x=0
	ldr r0, [sp, #28]
	str r0, [sp, #4]	@ y=R
	mvn	r0, r0			@ -R-1
	add r0, r0, #2		@ 1-R
	str r0, [sp, #8]	@ d=1-R
	mov r0, #3
	str r0, [sp, #12]	@ dE=3
	ldr r0, [sp, #28]	@ R
	lsl r0, r0, #1		@ 2*R
	mvn r1, r0			@ -2*R - 1
	add r1, r1, #6		@ -2*R + 5
	str r1, [sp, #16]	@ dSE = -2*R + 5

	/* izsaucam draw_8_symmetric_points(x0, y0, dx, dy) */
.Lcall8points:
	ldr r0, [sp, #20]
	ldr r1, [sp, #24]
	ldr r2, [sp]
	ldr r3, [sp, #4]
	bl	draw_8_symmetric_points
	b	.Lcircle_loop_test

/* while (y > x) */
.Lcircle_loop:
	/* if (d < 0) */
	ldr r0, [sp, #8]
	cmp r0, #0
	blt .Lcircle_1
	bge .Lcircle_2
.Lcircle_1:
	ldr r0, [sp, #8]	@ d
	ldr r1, [sp, #12]	@ dE
	ldr r2, [sp, #16]	@ dSE
	ldr r3, [sp]		@ x
	add r0, r0, r1
	add r1, r1, #2
	add r2, r2, #2
	add r3, r3, #1
	str r0, [sp, #8]	@ d+=dE
	str r1, [sp, #12]	@ dE+=2
	str r2, [sp, #16]	@ dSE+=2
	str r3, [sp]		@ x+=1
	b	.Lcall8points
.Lcircle_2:
	ldr r0, [sp, #8]	@ d
	ldr r1, [sp, #12]	@ dE
	ldr r2, [sp, #16]	@ dSE
	ldr r3, [sp]		@ x
	add r0, r0, r2
	add r1, r1, #2
	add r2, r2, #4
	add r3, r3, #1
	str r0, [sp, #8]	@ d+=dSE
	str r1, [sp, #12]	@ dE+=2
	str r2, [sp, #16]	@ dSE+=2
	str r3, [sp]		@ x+=1
	/* vel y-- */
	ldr r3, [sp, #4]
	sub r3, r3, #1
	str r3, [sp, #4]
	b	.Lcall8points

.Lcircle_loop_test:
	ldr r0, [sp, #4]
	ldr r1, [sp]
	cmp r0, r1
	bgt .Lcircle_loop

	add	sp, sp, #20
	pop {r0-r2, lr}
	bx	lr
