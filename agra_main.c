#include <stdlib.h>
#include <stdio.h>
#include "agra.h"

#define FrameWidthVal 40
#define FrameHeightVal 20

// definējam mainīgos no agra.h
pixcolor_t * FrameBuffer = NULL;
int FrameWidth = 0;
int FrameHeight = 0;
pixcolor_t * currentPixColor = NULL;

int main (int argc, char ** argv) {

	// inicializējam ekrāna buferi
	FrameWidth = FrameWidthVal;
	FrameHeight = FrameHeightVal;
	FrameBuffer = (pixcolor_t *)malloc(FrameWidth * FrameHeight * sizeof(pixcolor_t));

	// definējam uzreiz vienuviet vajadzīgās krāsas
	pixcolor_t black = {0,0,0,0};
	pixcolor_t white = {0x03ff,0x03ff,0x03ff,0};
	pixcolor_t blue = {0,0,0x03ff,0};
	pixcolor_t green = {0,0x03ff,0,0};
	pixcolor_t red = {0x03ff,0,0,0};

	// inicializējam tekošo krāsu
	currentPixColor = &black;
	
	// katru pikseli aizpilda ar melnu krāsu
	int width = FrameBufferGetWidth();
	int height = FrameBufferGetHeight();
	for (int i=0; i<width; i++) {
		for (int j=0; j<height; j++) {
			pixel(i, j, &black);
		}
	}

	pixel(25, 2, &white);

	setPixColor(&blue);
	line(0, 0, 39, 19);

	setPixColor(&green);
	triangleFill(20, 13, 28, 19, 38, 6);

	setPixColor(&red);
	circle(20, 10, 7);

	FrameShow();

	free(FrameBuffer);
	return 0;
}
