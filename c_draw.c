#include "agra.h"
#include <stdio.h>

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

// void line_low(int x0, int y0, int x1, int y1, int swap){
//   if (x1 < x0) {
//     int tmp = x0;
//     x0 = x1;
//     x1 = tmp;
//     tmp = y0;
//     y0 = y1;
//     y1 = tmp;
//   }
// 	int dx, dy, dE, dNE, d, x, y, yi;
// 	dx = x1-x0;
// 	dy = y1-y0;
//   yi = 1;
//   if (dy < 0) {
//     yi = -1;
//     dy = -dy;
//   }

// 	d = 2 * dy - dx;
// 	dE = 2 * dy;
// 	dNE = 2 * (dy - dx);
// 	x = x0;
// 	y = y0;
// 	while(x<=x1){
//     if (swap) {
//       pixel(y, x, currentPixColor);
//     } else {
//       pixel(x, y, currentPixColor);
//     }
// 		if(d<=0){
// 			d+=dE;
// 			++x;
// 		}
// 		else{
// 			d+=dNE;
// 			++x;
// 			y = y + yi;
// 		}
// 	}
// }

// void line(int x0, int y0, int x1, int y1) {
//   int dx, dy;
//   dx = x1 - x0;
//   dy = y1 - y0;
//   if (dx < 0) dx = -dx;
//   if (dy < 0) dy = -dy;
//   if (dy < dx) {
//     line_low(x0, y0, x1, y1, 0);
//   } else {
//     line_low(y0, x0, y1, x1, 1);
//   }
// }

// void line_1(int x0, int y0, int x1, int y1) {
//   int dx, dy;
//   dx = x1 - x0;
//   dy = y1 - y0;
//   if (dx < 0) dx = -dx;
//   if (dy < 0) dy = -dy;
//   int swap = 0;
//   if (dy > dx){
//     // Brezenhama algoritms var novilkt liniju tikai max 45 gradu lenkii
//     // saja gadijuma lenkis bus lielaks
//     // tatad aprekinos varam samainit vietam visus attiecigos
//     // x un y mainigos, bet kad bus jazime pikselis, jasamaina "atpakal" x un x
//     swap = 1;
//     int tmp = x0;
//     x0 = y0;
//     y0 = tmp;
//     tmp = x1;
//     x1 = y1;
//     y1 = tmp;
//   }
//   if (x1 < x0) {
//     // tiek samainiti punkti vietam, jo Brezenhama algoritms
//     // zime tikai no kreisas uz labo pusi
//     int tmp = x0;
//     x0 = x1;
//     x1 = tmp;
//     tmp = y0;
//     y0 = y1;
//     y1 = tmp;
//   }
// 	int dE, dNE, d, x, y, yi;
// 	dx = x1-x0;
// 	dy = y1-y0;
//   yi = 1;
//   if (dy < 0) {
//     // ja linija dilst, nevis aug, tad y bus jainkremente par -1, nevis +1
//     yi = -1;
//     dy = -dy;
//   }
// 	d = 2 * dy - dx;
// 	dE = 2 * dy;
// 	dNE = 2 * (dy - dx);
// 	x = x0;
// 	y = y0;
// 	while(x<=x1){
//     // te zimejot tad parbaudam, vai nevajag samainit x un y
//     if (swap) {
//       pixel(y, x, currentPixColor);
//     } else {
//       pixel(x, y, currentPixColor);
//     }
// 		if(d<=0){
// 			d+=dE;
// 			++x;
// 		}
// 		else{
// 			d+=dNE;
// 			++x;
// 			y = y + yi;
// 		}
// 	}
// }

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

int determinant (int x0, int y0, int x1, int y1, int px, int py) {
    int mala_dx = x1-x0;
    int mala_dy = y1-y0;
    int pts_dx = px-x0;
    int pts_dy = py-y0;
    int D = mala_dx * pts_dy - mala_dy * pts_dx;
    return D;
}

void triangleFill_1 (int x1, int y1, int x2, int y2, int x3, int y3) {
  int xmax, xmin, ymax, ymin;
  xmax = x1;
  if (x2>xmax) xmax = x2;
  if (x3>xmax) xmax = x3;
  xmin = x1;
  if (x2<xmin) xmin = x2;
  if (x3<xmin) xmin = x3;
  ymax = y1;
  if (y2>ymax) ymax = y2;
  if (y3>ymax) ymax = y3;
  ymin = y1;
  if (y2<ymin) ymin = y2;
  if (y3<ymin) ymin = y3;

  // vajag, lai pti 1, 2, 3 šādā secībā ir izvietoti pretpulksteņrādītājvirzienā
  // šis pārbauda, vai pts 3 ir pa kreisi no vektora p1->p2
  // ja nav, tad samaina vietām ptus 2 un 3
  if (determinant(x1,y1,x2,y2,x3,y3) < 0) {
    int tmp = x2;
    x2 = x3;
    x3 = tmp;
    tmp = y2;
    y2 = y3;
    y3 = tmp;
  }
  
  // samazinam "bounding box", lai ietilpst ieks FrameBuffer
  int frame_width = FrameBufferGetWidth();
  int frame_height = FrameBufferGetHeight();
  if (xmax > frame_width-1) xmax = frame_width-1;
  if (xmin < 0) xmin = 0;
  if (ymax > frame_height-1) ymax = frame_height-1;
  if (ymin < 0) ymin = 0;

  for (int y=ymin; y<=ymax; y++) {
    for (int x=xmin; x<=xmax; x++) {
      // katram punktam pārbaudam tā "vektoriālo reizinājumu" ar
      // katru no trijstūra malām. Ja visi ir nenegatīvi, tad punkts ir
      // trijstūra iekšienē. Te arī tiek pieņemts, ka trijstūra punkti ir
      // tādā secībā, ka tie iet pretpulksteņrādītājvirzienā ap trijstūra centru.
      int d1 = determinant(x1,y1,x2,y2,x,y);
      int d2 = determinant(x2,y2,x3,y3,x,y);
      int d3 = determinant(x3,y3,x1,y1,x,y);
      // printf("%d %d %d\n", d1, d2, d3);

      if (d1>=0 && d2>=0 && d3>=0) {
        pixel(x, y, currentPixColor);
      }
    }
    // printf("Next line\n");
  }
}
