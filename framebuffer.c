#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "agra.h"

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

// Palīgfunkcija priekš FrameShow, kas pikselim piešķir simbolu,
// ar ko reprezentēt tā krāsu.
char* pix_to_char (pixcolor_t pix) {
	bool redDominates = false;
	bool greenDominates = false;
	bool blueDominates = false;
	if (pix.r >= 0x0200) redDominates = true; // salīdzina ar ~pusi no max vērtības 0x3ff
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
	return "E"; // error, bet it kā nav iespējams sasniegt šo rindu
}

// Neliela modifikācija no ieipriekšējās funkcijas, kas simbolam arī
// piešķir tam atbilstošo aptuveno krāsu, kad izvada terminālī.
// Šobrīd netiek lietota iekš FrameShow
char* pix_to_char_color (pixcolor_t pix) {
	bool redDominates = false;
	bool greenDominates = false;
	bool blueDominates = false;
	if (pix.r >= 0x0200) redDominates = true;
	if (pix.g >= 0x0200) greenDominates = true;
	if (pix.b >= 0x0200) blueDominates = true;
	if (!redDominates && !greenDominates && !blueDominates)	return " ";
	if (redDominates && greenDominates && blueDominates)	return "\033[0;37m*";
	if (redDominates && !greenDominates && !blueDominates)	return "\033[0;31mR";
	if (!redDominates && greenDominates && !blueDominates)	return "\033[0;32mG";
	if (!redDominates && !greenDominates && blueDominates)	return "\033[0;34mB";
	if (!redDominates && greenDominates && blueDominates)	return "\033[0;36mC";
	if (redDominates && !greenDominates && blueDominates)	return "\033[0;35mM";
	if (redDominates && greenDominates && !blueDominates)	return "\033[0;33mY";
	return "E"; // error
}

// Kadra izvadīšana uz "displeja iekārtas".
int FrameShow() {
	if (FrameBuffer == NULL) return 1;
	// Izvadam tā, lai x koordinātes augtu pa labi
	// un y koordinātes augtu uz augšu.
	for (int i=FrameHeight-1; i>=0; i--) {
		for (int j=0; j<FrameWidth; j++) {
			printf("%s", pix_to_char(FrameBuffer[i*FrameWidth + j]));
		}
		printf("\n");
	}
	return 0;
}
