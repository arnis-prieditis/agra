#include <stdlib.h>
#include <stdio.h>
#include "agra.h"

int main (int argc, char ** argv) {

	// frame and current color init
	FrameBuffer = (pixcolor_t *)malloc(FrameWidth * FrameHeight * sizeof(pixcolor_t));
	pixcolor_t black = {0,0,0,0};
	currentPixColor = &black;
	
	// tests
	int width = FrameBufferGetWidth();
	int height = FrameBufferGetHeight();
	for (int i=0; i<width; i++) {
		for (int j=0; j<height; j++) {
			pixcolor_t black = {0,0,0,0};
			pixel(i, j, &black);
		}
	}
	pixcolor_t white = {0x03ff,0x03ff,0x03ff,0};
	pixel(25, 2, &white);
	pixcolor_t blue = {0,0,0x03ff,0};
	setPixColor(&blue);
	line(39,19,10,0);
	pixcolor_t green = {0,0x03ff,0,2};
	setPixColor(&green);
	// triangleFill(19, 19, 5, 9, 30, 3);
	triangleFill_1(19, 0, 5, 9, 30, 3);
	pixcolor_t red = {0x03ff,0,0,2};
	setPixColor(&red);
	circle(20,10,7);
	FrameShow();

	free(FrameBuffer);
	return 0;
}
