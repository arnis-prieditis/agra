#ifndef AGRA_H
#define AGRA_H

#define FrameWidth 40
#define FrameHeight 20

// Krāsas tips punktam: 
//    r,g,b ir sarkanā, zaļā, un zilā krāsu komponentes, katrai 10 biti.
//    op  ir operācija, kas jāizpilda šim pikselim ar fona krāsu. 0 - nozīmē rakstīt pāri.
typedef struct {
    unsigned int r  : 10;
    unsigned int g  : 10;
    unsigned int b  : 10;
    unsigned int op : 2;
} pixcolor_t;

// Operācijas iespējas pikselim ar fona (FrameBuffer) krāsu.
// Izmantots pixcolor_t struktūras laukā "op".
typedef enum {
    PIXEL_COPY = 0,
    PIXEL_AND  = 1,
    PIXEL_OR   = 2,
    PIXEL_XOR  = 3
} pixop_t;

// globālie mainīgie priekš "ekrāna" un tekošās krāsas
// (varbūt ir labāks veids, kā šo realizēt)
extern pixcolor_t * FrameBuffer;
extern pixcolor_t * currentPixColor;

// Funkcija krasas (un operācijas) uztādīšanai
void setPixColor(pixcolor_t * color_op);

// Funkcija viena pikseļa uzstadīšanai
void pixel(int x, int y, pixcolor_t * colorop);

// Funkcija līnijas zīmēšanai starp punktiem
void line(int x1, int y1, int x2, int y2);
// void line_1(int x1, int y1, int x2, int y2);

// Funkcija trijstūra aizpildīšanai ar tekošo krāsu
void triangleFill(int x1, int y1, int x2, int y2, int x3, int y3);
// void triangleFill_1(int x1, int y1, int x2, int y2, int x3, int y3);
// void triangleFill_2(int x1, int y1, int x2, int y2, int x3, int y3);
// int determinant_1 (int x0, int y0, int x1, int y1, int px, int py);
// int determinant (int x0, int y0, int x1, int y1, int px, int py);

// Funkcija riņķa līnijas zīmēšanai
void circle(int x1, int y1, int radius);

// Kadra bufera sākuma adrese
pixcolor_t * FrameBufferGetAddress();

// Kadra platums
int FrameBufferGetWidth();

// Kadra augstums
int FrameBufferGetHeight();

// Kadra izvadīšana uz "displeja iekārtas".
int FrameShow();

#endif /* AGRA_H */
