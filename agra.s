	.text
	.align 2
	.global setPixColor
	.global pixel
	.global draw8SymmetricPoints
	.global circle
	.extern currentPixColor 
	.extern FrameBufferGetAddress
	.extern FrameBufferGetWidth
setPixColor:
	ldr	r1, =currentPixColor
	str	r0, [r1]
	bx	lr

pixel:
	push	{r0-r2,lr}
	bl	FrameBufferGetAddress
	str	r0, [sp, #-4]!	
	bl	FrameBufferGetWidth
	str	r0, [sp, #-4]!	
/* sp-> width, frame addr, x, y, color addr, lr val */
	ldr	r0, [sp, #8]	@ x
	ldr	r1, [sp, #12]	@ y
	ldr	r2, [sp]	@ width
	mla	r3, r1, r2, r0	@ width*y + x
	ldr	r1, [sp, #16]	@ color addr
	ldr	r1, [r1]	@ color val
	b	.Lcolor
.Lend_pixel:
	ldr	lr, [sp, #20]
	add	sp, sp, #24
	bx	lr
.Lcolor:
/* r1: color, r3: frame buffer index - sos neaiztiekam */
	@ bic	r0, r1, #0x3FFFFFFF	@ pirmos (!!) 2 bitus saglabajam - op lauks (jo little endian??)
	lsr	r0, r1, #30
	cmp	r0, #0
	beq	.Lpixel_copy
	cmp	r0, #1
	beq	.Lpixel_and
	cmp	r0, #2
	beq	.Lpixel_or
	cmp	r0, #3
	beq	.Lpixel_xor
	b	.Lerror_pixel	@ neatbilstosa op lauka veriba
.Lerror_pixel:
	mov	r0, #1
	b	.Lend_pixel
.Lpixel_copy:
	ldr	r0, [sp, #4]		@ frame addr
	str	r1, [r0, r3, LSL #2]	@ vnk parkope
	b	.Lend_pixel
.Lpixel_and:
	ldr	r0, [sp, #4]		@ frame addr
	ldr	r2, [r0, r3, LSL #2]	@ r2 ieliekam pasreizejo krasu
	and	r2, r2, r1
	str	r2, [r0, r3, LSL #2]	@ iekrasojam
	b	.Lend_pixel
.Lpixel_or:
	ldr	r0, [sp, #4]		@ frame addr
	ldr	r2, [r0, r3, LSL #2]	@ r2 ieliekam pasreizejo krasu
	orr	r2, r2, r1
	str	r2, [r0, r3, LSL #2]	@ iekrasojam
	b	.Lend_pixel
.Lpixel_xor:
	ldr	r0, [sp, #4]		@ frame addr
	ldr	r2, [r0, r3, LSL #2]	@ r2 ieliekam pasreizejo krasu
	eor	r2, r2, r1
	str	r2, [r0, r3, LSL #2]	@ iekrasojam
	b	.Lend_pixel

draw8SymmetricPoints:
	push	{r0-r3, lr}
	ldr r2, =currentPixColor
	ldr r2, [r2]
	push	{r2}
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	add	r0, r0, r3	@ x0+x
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	add r1, r1, r3	@ y0+y
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	add	r0, r0, r3	@ x0+x
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	sub r1, r1, r3	@ y0-y
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	sub	r0, r0, r3	@ x0-x
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	add r1, r1, r3	@ y0+y
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #12]
	sub	r0, r0, r3	@ x0-x
	ldr	r1, [sp, #8]
	ldr r3, [sp, #16]
	sub r1, r1, r3	@ y0-y
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	add	r0, r0, r3	@ x0+y
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	add r1, r1, r3	@ y0+x
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	add	r0, r0, r3	@ x0+y
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	sub r1, r1, r3	@ y0-x
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	sub	r0, r0, r3	@ x0-y
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	add r1, r1, r3	@ y0+x
	ldr r2, [sp]
	bl	pixel
	ldr	r0, [sp, #4]
	ldr	r3, [sp, #16]
	sub	r0, r0, r3	@ x0-y
	ldr	r1, [sp, #8]
	ldr r3, [sp, #12]
	sub r1, r1, r3	@ y0-x
	ldr r2, [sp]
	bl	pixel
	pop {r0}
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

	/* izsaucam draw8SymmetricPoints(x0, y0, x, y) */
.Lcall8points:
	ldr r0, [sp, #20]
	ldr r1, [sp, #24]
	ldr r2, [sp]
	ldr r3, [sp, #4]
	bl	draw8SymmetricPoints
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
