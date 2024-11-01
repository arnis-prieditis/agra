#include "agra.h"

// pagaidu funkcijas implementācijas C
// vajadzēs pārrakstīt asemblerā

//void setPixColor(pixcolor_t * color_op) {
//	currentPixColor = color_op;
//}

//void pixel(int x, int y, pixcolor_t * colorop) {
//	pixcolor_t * frame_buffer = FrameBufferGetAddress();
//	int width = FrameBufferGetWidth();
//	frame_buffer[x + width*y] = *colorop;
//}

void line(int x0, int y0, int x1, int y1){
	// var novilkt linijas tikai +-45 gradu lenkii no x ass
  if (x1 < x0) {
    int tmp = x0;
    x0 = x1;
    x1 = tmp;
    tmp = y0;
    y0 = y1;
    y1 = tmp;
  }
	int dx, dy, dE, dNE, d, x, y, yi;
	dx = x1-x0;
	dy = y1-y0;
  yi = 1;
  if (dy < 0) {
    yi = -1;
    dy = -dy;
  }

	d = 2 * dy - dx;
	dE = 2 * dy;
	dNE = 2 * (dy - dx);
	x = x0;
	y = y0;
	while(x<=x1){
    pixel(x, y, currentPixColor);
		if(d<=0){
			d+=dE;
			++x;
		}
		else{
			d+=dNE;
			++x;
			y = y + yi;
		}
	}
}

// void draw8SymmetricPoints(int x0, int y0, int x, int y) {
// 	pixel(x0+x, y0+y, currentPixColor);
// 	pixel(x0+x, y0-y, currentPixColor);
// 	pixel(x0-x, y0+y, currentPixColor);
// 	pixel(x0-x, y0-y, currentPixColor);
// 	pixel(x0+y, y0+x, currentPixColor);
// 	pixel(x0+y, y0-x, currentPixColor);
// 	pixel(x0-y, y0+x, currentPixColor);
// 	pixel(x0-y, y0-x, currentPixColor);
// }

// void circle(int x0, int y0, int R){
// 	int x,y, d, dE, dSE;
// 	x = 0;
// 	y = R;
// 	d = 1 - R;
// 	dE = 3;
// 	dSE = -2*R + 5;
// 	draw8SymmetricPoints(x0, y0, x, y);
// 	while(y > x){
// 		if(d < 0){
// 			d += dE;
// 			dE += 2;
// 			dSE += 2;
// 			++x;
// 		}
// 		else{
// 			d += dSE;
// 			dE += 2;
// 			dSE += 4;
// 			++x;
// 			--y;
// 		}
// 		draw8SymmetricPoints(x0, y0, x, y);
// 	}
// }

typedef struct {
	int x;
	int y;
} Vertice;

void fillBottomFlatTriangle(Vertice v1, Vertice v2, Vertice v3)
{
  float invslope1 = (float)(v2.x - v1.x) / (v2.y - v1.y);
  float invslope2 = (float)(v3.x - v1.x) / (v3.y - v1.y);

  float curx1 = v1.x;
  float curx2 = v1.x;

  for (int scanlineY = v1.y; scanlineY <= v2.y; scanlineY++)
  {
    line((int)curx1, scanlineY, (int)curx2, scanlineY);
    curx1 += invslope1;
    curx2 += invslope2;
  }
}

void fillTopFlatTriangle(Vertice v1, Vertice v2, Vertice v3)
{
  float invslope1 = (float)(v3.x - v1.x) / (v3.y - v1.y);
  float invslope2 = (float)(v3.x - v2.x) / (v3.y - v2.y);

  float curx1 = v3.x;
  float curx2 = v3.x;

  for (int scanlineY = v3.y; scanlineY > v1.y; scanlineY--)
  {
    line((int)curx1, scanlineY, (int)curx2, scanlineY);
    curx1 -= invslope1;
    curx2 -= invslope2;
  }
}

void triangleFill(int x1, int y1, int x2, int y2, int x3, int y3)
{
  Vertice v1 = {x1, y1};
  Vertice v2 = {x2, y2};
  Vertice v3 = {x3, y3};
   /* at first sort the three vertices by y-coordinate ascending so v1 is the topmost vertice */
  if (v2.y < v1.y) {
	Vertice tmp = v1;
	v1 = v2;
	v2 = tmp;
  }
  if (v3.y < v2.y) {
	Vertice tmp = v2;
	v2 = v3;
	v3 = tmp;
  }
  if (v2.y < v1.y) {
	Vertice tmp = v1;
	v1 = v2;
	v2 = tmp;
  }

  /* here we know that v1.y <= v2.y <= v3.y */
  /* check for trivial case of bottom-flat triangle */
  if (v2.y == v3.y)
  {
    fillBottomFlatTriangle(v1, v2, v3);
  }
  /* check for trivial case of top-flat triangle */
  else if (v1.y == v2.y)
  {
    fillTopFlatTriangle(v1, v2, v3);
  }
  else
  {
    /* general case - split the triangle in a topflat and bottom-flat one */
    Vertice v4 = {
		(int)(v1.x + ((float)(v2.y - v1.y) / (float)(v3.y - v1.y)) * (v3.x - v1.x)),
		v2.y
	};
    fillBottomFlatTriangle(v1, v2, v4);
    fillTopFlatTriangle(v2, v4, v3);
  }
}
