	.text
	.align 2
	.global setPixColor
	.global pixel
	.global circle
	.global line
	.global triangleFill
	.extern currentPixColor 
	.extern FrameBufferGetAddress
	.extern FrameBufferGetWidth
	.extern FrameBufferGetHeight


setPixColor:
	ldr	r1, =currentPixColor
	str	r0, [r1]
	bx	lr


pixel:
	/* ieejas parametri: x, y, color addr */
	@ no sākuma pārbaudam, vai koordinātes nav ārpus FrameBuffer
	cmp	r0, #0
	bxlt	lr
	cmp	r1, #0
	bxlt	lr
	push	{r0-r2, lr}
	sub	sp, sp, #8	@ rezervējam vietu
/* sp-> _, _, x, y, color addr, lr */
	bl	FrameBufferGetHeight
	@ r0: FrameBufferHeight
	ldr	r1, [sp, #12]	@ y
	cmp	r1, r0
	bge	.Lend_pixel		@ if (y >= FrameBufferHeight) return;
	bl	FrameBufferGetWidth
	@ r0: FrameBufferWidth
	ldr	r1, [sp, #8]	@ x
	cmp r1, r0
	bge	.Lend_pixel	@ if (x >= FrameBufferWidth) return;
	str	r0, [sp, #4]
	bl	FrameBufferGetAddress
	str	r0, [sp]
/* sp-> FrameBuffer addr, FrameBufferWidth, x, y, color addr, lr */
	ldr	r0, [sp, #8]	@ x
	ldr r1, [sp, #12]	@ y
	ldr	r2, [sp, #4]	@ FrameBufferWidth
	mla	r3, r1, r2, r0	@ y*FrameBufferWidth + x : FrameBuffer indekss, kurs jaiekraso
	ldr	r1, [sp, #16]	@ color addr
	ldr	r1, [r1]		@ color value
	ldr	r2, [sp]		@ FrameBuffer addr
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

line:
	/* Balstits uz Brezenhama linijas zimesanas algiritmu.
	*  Bet vel papildinats ar to, lai var zimet ne tikai
	*  1. oktantaa: 0-45 gradu lenki no x ass. */
	push	{r4-r12, lr}

	sub	sp, sp, #40
	/* No sakuma parbaudam, vai abs(dy) > abs(dx) => tad var
	*  aprekinos attiecigos x un y mainigos samainit
	*  vietam, bet katrreiz, kad jazime pikseli,
	*  samainit "atpakal" aprekinatas x un y koordinates. */
.Lline_check_dx_dy:
	sub	r4, r2, r0	@ x1-x0 = dx
	sub	r5, r3, r1	@ y1-y0 = dy
	cmp	r4, #0			@ if (dx < 0) dx = -dx;
	mvnmi	r4, r4
	addmi	r4, r4, #1
	cmp	r5, #0			@ if (dy < 0) dy = -dy;
	mvnmi	r5, r5
	addmi	r5, r5, #1
	cmp	r5, r4
	@ bhi	.Lline_swap_x_y
	bls	.Lline_no_swap_x_y
.Lline_swap_x_y:
	mov	r4, #1
	str	r4, [sp]	@ sp-> doSwap=1, ...
	mov	r4, r0		@ 3 rindas: x0 <-> y0
	mov	r0, r1
	mov	r1, r4
	mov	r4, r2		@ 3 rindas: x1 <-> y1
	mov	r2, r3
	mov	r3, r4
	b	.Lline_check_left_to_right
.Lline_no_swap_x_y:
	mov	r4, #0
	str	r4, [sp]	@ sp-> doSwap=0, ...
.Lline_check_left_to_right:
	/* if (x1 < x0) samaina galapunktus vietam, jo
	*  Brezenhama algoritms tikai viena virziena strada */
	cmp	r2, r0
	@ blt	.Lline_swap_points
	bge	.Lline_start_brezenham
.Lline_swap_points:
	mov	r4, r0		@ 3 rindas: x0 <-> x1
	mov	r0, r2
	mov	r2, r4
	mov	r4, r1		@ 3 rindas: y0 <-> y1
	mov	r1, r3
	mov	r3, r4
.Lline_start_brezenham:
	/* registros: x0, y0, x1, y1 */
	/* sp-> doSwap, [9 brivas vietas] */
	sub	r4, r2, r0		@ x1-x0 = dx
	cmp	r4, #0
	blt	.Lline_error	@ dx tagad noteikti vajadzetu but nenegativam
	str	r4, [sp, #4]
	sub	r5, r3, r1		@ y1-y0 = dy
	mov	r6, #1			@ yi = 1; y inkrements
	/* Ja dy<0 tad linija dilst nevis aug:
	*  y bus jainkremente par -1 nevis +1
	*  Bet aprekinos vajag pozitivu dy vertibu */
	cmp	r5, #0
	bge	.Lline_set_variables
	@ blt	.Lline_set_decrement_y
.Lline_set_decrement_y:
	mvn	r5, r5		@ 2 rindas: dy = -dy
	add	r5, #1
	mov	r6, #-1		@ yi = -1

.Lline_set_variables:
	str	r5, [sp, #8]	@ dy
	str	r6, [sp, #12]	@ yi
	lsl	r7, r5, #1		@ 2*dy
	str	r7, [sp, #20]	@ dE = 2*dy
	sub	r8, r7, r4		@ 2*dy-dx
	str	r8, [sp, #16]	@ d = 2*dy-dx
	sub	r9, r5, r4		@ dy-dx
	lsl r9, r9, #1		@ 2*(dy-dx)
	str	r9, [sp, #24]	@ dNE = 2*(dy-dx)
	str	r0, [sp, #28]	@ x = x0
	str	r1, [sp, #32]	@ y = y0
	str	r2, [sp, #36]	@ parliekam x1 uz steku
	/* sp-> doSwap, dx, dy, yi, d, dE, dNE, x, y, x1 */
	b	.Lline_loop_check
.Lline_loop:
	ldr	r0, [sp]
	cmp	r0, #0
	beq	.Lline_call_pixel_normal
	cmp	r0, #1
	beq	.Lline_call_pixel_swap
	b	.Lline_error	@ nederiga doSwap vertiba
.Lline_call_pixel_normal:
	ldr	r0, [sp, #28]	@ x
	ldr	r1, [sp, #32]	@ y
	ldr	r2, =currentPixColor
	ldr	r2, [r2]		@ ?? jo ieprieks bija address to pointer value??
	bl	pixel
	b	.Lline_check_d
.Lline_call_pixel_swap:
	ldr	r0, [sp, #32]	@ y
	ldr	r1, [sp, #28]	@ x
	ldr	r2, =currentPixColor
	ldr	r2, [r2]
	bl	pixel
	b	.Lline_check_d
.Lline_check_d:
	ldr	r0, [sp, #16]
	cmp	r0, #0		@ (d <= 0) ?
	@ signed comparison!!
	ble	.Lline_d_nonpositive
	bgt	.Lline_d_positive

.Lline_d_nonpositive:
	/* 	d+=dE;
		x++; */
	ldr	r1, [sp, #20]	@ dE
	add	r2, r0, r1		@ d+dE
	str	r2, [sp, #16]	@ ieraksta jauno d
	ldr	r3, [sp, #28]	@ x
	add	r3, r3, #1
	str	r3, [sp, #28]
	b	.Lline_loop_check
.Lline_d_positive:
	/*	d+=dNE;
		x++;
		y = y + yi; */
	ldr	r1, [sp, #24]	@ dNE
	add	r2, r0, r1		@ d+dNE
	str	r2, [sp, #16]	@ ieraksta jauno d
	ldr	r3, [sp, #28]	@ x
	add	r3, r3, #1
	str	r3, [sp, #28]
	ldr	r4, [sp, #32]	@ y
	ldr	r5, [sp, #12]	@ yi
	add	r6, r4, r5
	str	r6, [sp, #32]
	b	.Lline_loop_check
.Lline_loop_check:
	ldr	r0, [sp, #28]	@ x
	ldr	r1, [sp, #36]	@ x1
	cmp	r0, r1			@ (x <= x1) ?
	ble	.Lline_loop
	b	.Lline_end		@ vai bgt?
.Lline_error:
	mov	r0, #1
	@ b	.Lline_end
.Lline_end:
	add	sp, sp, #40
	pop	{r4-r12, lr}
	bx	lr


triangleFill:
	push	{r4-r12,lr}
	ldr	r4, [sp, #40]	@ x3
	ldr	r5, [sp, #44]	@ y3
	sub	sp, sp, #8
	push	{r0-r5}

	/* Izsaucam determinant, lai noteiktu, vai punkti ir
	padoti pretpulksteņrādītājvirzienā. Ja nav, tad samainīsim
	2. un 3. punktu vietām. */
	push	{r4-r5}	@ r0-r3 jau satur pirmo 2 ptu koord, 3. ptam jabut stekā priekš determinant()
	bl	determinant
	add	sp, sp, #8	@ tagad sp->x1,y1,x2,y2,x3,y3, (r4-r12,lr)
	cmp	r0, #0
	bge	.LtriangleFill_is_anti_clockwise
	@ tagad ir jāsamaina vietām 2. un 3. punkts
	@ tie jau ir stekā
	ldr	r0, [sp, #8]	@ x2
	ldr	r1, [sp, #12]	@ y2
	ldr	r2, [sp, #16]	@ x3
	ldr	r3, [sp, #20]	@ y3
	str	r0, [sp, #16]
	str	r1, [sp, #20]
	str	r2,	[sp, #8]
	str	r3, [sp, #12]
.LtriangleFill_is_anti_clockwise:
	/* Tagad jānoskaidro max un min vērtības x un y koordinātēm.
	   Lai var izveidot "bounding box", kurā katram pikselim
	   pārbaudīsim, vai tas ir iekšā/ārā no trijstūra. */
	@ r4-r7 glabās xmax, ymax, xmin, ymin

	@ pagaidu fix (vajadzetu visu max/min noteikšanu pārrakstīt)
	ldr	r0, [sp, #8]	@ x2
	ldr	r1, [sp, #12]	@ y2
	ldr	r2, [sp, #16]	@ x3
	ldr	r3, [sp, #20]	@ y3

	@ xmax
	cmp	r0, r2	@ salidzinam x2 un x3
	movgt	r4, r0	@ x2>x3
	movle	r4, r2	@ x2<=x3
	ldr	r0, [sp]	@ x1
	cmp	r0, r4
	movgt	r4, r0

	@ ymax
	cmp r1, r3	@ y2 un y3
	movgt	r5, r1	@ y2>y3
	movle	r5, r3	@ y2<=y3
	ldr	r0, [sp, #4]	@ y1
	cmp	r0, r5
	movgt	r5, r0

	@ xmin
	ldr	r0, [sp, #8] @ x2
	@ tagad reģistros atkal ir x2,y2,x3,y3
	cmp r0, r2
	movlt	r6, r0
	movge	r6, r2
	ldr r0, [sp]	@ x1
	cmp r0, r6
	movlt r6, r0
	cmp r6, #0		@ pārbaudam, vai nav mazāk par 0
	movlt r6, #0

	@ ymin
	cmp r1, r3
	movlt	r7, r1
	movge	r7, r3
	ldr r0, [sp, #4]	@ y1
	cmp	r0, r7
	movlt	r7, r0
	cmp r7, #0		@ pārbaudam, vai nav mazāk par 0
	movlt r7, #0

	/* Tagad pārbaudam vēl, vai iegūtās
	max vērtības nav ārpus FrameBuffer */
	bl	FrameBufferGetWidth
	sub r0, r0, #1	@ jo xmax var būt frame buffer width - 1
	cmp r4, r0
	movgt r4, r0	@ if (xmax > frameBufferWidth-1) xmax = frameBufferWidth-1;
	bl FrameBufferGetHeight
	sub r0, r0, #1
	cmp r5, r0		@ if (ymax > frameBufferHeight-1) ymax = frameBufferHeight-1;
	movgt r5, r0

	/* Tagad ejam cauri katram pikselim iekš iespējamajām
	   max/min robežām un pārbaudam, vai tas ir "pa kreisi"
	   visām trim trijstūra malām, izsaucot determinant() */
	@ xmin un ymin jau būs kā ciklu skaitītāju sākotnējās vērtības
	str r6, [sp, #24]	@ saglabajam xmin
	str r7, [sp, #28]	@ saglabajam ymin

@ for (int y=ymin; y<=ymax; y++)
.LtriangleFill_y_loop:

@ for (int x=xmin; x<=xmax; x++)
	ldr	r6, [sp, #24]	@ x=xmin
.LtriangleFill_x_loop:

	sub sp, sp, #8	@ atbrivojam vietu, lai var determinant() padot parametrus
	str r6, [sp]		@ x
	str r7, [sp, #4]	@ y

	@ Visiem determinant() rezultātiem jābūt >=0
	@ Tagad sp->x,y,x1,y1,x2,y2,x3,y3,xmin,ymin, (r4-r12,lr)

	@ determinant(x1,y1,x2,y2,x,y)
	mov r8, sp
	add r8, r8, #8
	ldmfd r8, {r0-r3}
	bl	determinant
	cmp r0, #0
	blt	.LtriangleFill_nevajag_zimet

	@ determinant(x2,y2,x3,y3,x,y)
	add r8, r8, #8
	ldmfd r8, {r0-r3}
	bl	determinant
	cmp r0, #0
	blt	.LtriangleFill_nevajag_zimet

	@ determinant(x3,y3,x1,y1,x,y)
	add r8, r8, #8
	ldmfd r8, {r0,r1}
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	bl	determinant
	cmp r0, #0
	blt	.LtriangleFill_nevajag_zimet

	@ Ja šeit nokļūst, tātad izpildās (d1>=0 && d2>=0 && d3>=0)
	@ d1-d3 ir determinant() rezultāti
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, =currentPixColor
	ldr r2, [r2]
	bl	pixel

.LtriangleFill_nevajag_zimet:

	add sp, sp, #8	@ lai katrā cikla iterācijā nevajadzīgi neaizņemtu vēl papildus vietu
	add	r6, r6, #1	@ x++
.LtriangleFill_x_loop_check:
	cmp r6, r4
	ble	.LtriangleFill_x_loop

	add	r7, r7, #1	@ y++
.LtriangleFill_y_loop_check:
	cmp r7, r5
	ble	.LtriangleFill_y_loop

.LtriangleFill_end:
	add	sp, sp, #32
	pop	{r4-r12,lr}
	bx	lr

@ palīgfunkcija priekš triangleFill()
@ int determinant (int x0, int y0, int x1, int y1, int x2, int y2);
@ Aprēķina vektoriālo reizinājumu starp vektoriem AB un AC, ja
@ pieņem, ka ieejā ir attiecīgi punktu A,B,C koordinātes sādā secībā.
@ Ja rezultāts ir pozitīvs, tad punkts C ir pa kreisi no vektora AB.
determinant:
	push {r4-r5}
	sub r2, r2, r0	@ AB_dx=x1-x0
	sub r3, r3, r1	@ AB_dy=y1-y0
	ldr r4, [sp, #8]	@ x2
	ldr r5, [sp, #12]	@ y2
	sub r4, r4, r0	@ AC_dx=x2-x0
	sub r5, r5, r1	@ AC_dy=y2-y0
	@ rezultats = AB_dx*AC_dy - AB_dy*AC_dx
	mul r0, r2, r5
	mul r1, r3, r4
	sub r0, r0, r1

	pop	{r4-r5}
	bx	lr
