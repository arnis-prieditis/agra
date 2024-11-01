#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "agra.h"

pixcolor_t * FrameBuffer = NULL;
pixcolor_t * currentPixColor = NULL;

// Kadra bufera sākuma adrese
pixcolor_t * FrameBufferGetAddress() {
	return FrameBuffer;
}

// Kadra platums
int FrameBufferGetWidth() {
	if (FrameBuffer == NULL) return 0;
	return FrameWidth;
}

// Kadra augstums
int FrameBufferGetHeight() {
	if (FrameBuffer == NULL) return 0;
	return FrameHeight;
}

char* pix_to_char (pixcolor_t pix) {
	bool redDominates = false;
	bool greenDominates = false;
	bool blueDominates = false;
	if (pix.r >= 0x0200) redDominates = true;
	if (pix.g >= 0x0200) greenDominates = true;
	if (pix.b >= 0x0200) blueDominates = true;
	if (!redDominates && !greenDominates && !blueDominates)	return " ";
	if (redDominates && greenDominates && blueDominates)	return "*";
	if (redDominates && !greenDominates && !blueDominates)	return "R";
	if (!redDominates && greenDominates && !blueDominates)	return "G";
	if (!redDominates && !greenDominates && blueDominates)	return "B";
	if (!redDominates && greenDominates && blueDominates)	return "C";
	if (redDominates && !greenDominates && blueDominates)	return "M";
	if (redDominates && greenDominates && !blueDominates)	return "Y";
	return "E"; // error
}

char* pix_to_char_color (pixcolor_t pix) {
	bool redDominates = false;
	bool greenDominates = false;
	bool blueDominates = false;
	if (pix.r >= 0x0200) redDominates = true;
	if (pix.g >= 0x0200) greenDominates = true;
	if (pix.b >= 0x0200) blueDominates = true;
	if (!redDominates && !greenDominates && !blueDominates)	return " ";
	if (redDominates && greenDominates && blueDominates)	return "\033[0;37m*\033[0m";
	if (redDominates && !greenDominates && !blueDominates)	return "\033[0;31mR\033[0m";
	if (!redDominates && greenDominates && !blueDominates)	return "\033[0;32mG\033[0m";
	if (!redDominates && !greenDominates && blueDominates)	return "\033[0;34mB\033[0m";
	if (!redDominates && greenDominates && blueDominates)	return "\033[0;36mC\033[0m";
	if (redDominates && !greenDominates && blueDominates)	return "\033[0;35mM\033[0m";
	if (redDominates && greenDominates && !blueDominates)	return "\033[0;33mY\033[0m";
	return "E"; // error
}

// Kadra izvadīšana uz "displeja iekārtas".
int FrameShow() {
	if (FrameBuffer == NULL) return 1;
	for (int i=0; i<FrameHeight; i++) {
		for (int j=0; j<FrameWidth; j++) {
			printf("%s", pix_to_char(FrameBuffer[i*FrameWidth + j]));
		}
		printf("\n");
	}
	return 0;
}
