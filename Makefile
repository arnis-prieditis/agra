TARGET=agra
OBJS=framebuffer.o $(TARGET)_main.o $(TARGET).o
CC=arm-linux-gnueabi-gcc
LINKER=arm-linux-gnueabi-gcc
AS=arm-linux-gnueabi-as
ASFLAGS=-mcpu=xscale -alh=$*.lis -L -g
CFLAGS=-O0 -Wall -g

all:	$(OBJS)
	$(LINKER) -g -o $(TARGET) $^

%.o:	%.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.o:	%.s
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	$(RM) *.o $(TARGET) $(TARGET).lis *.png pixel_art.txt

test:   all 
	qemu-arm -L /usr/arm-linux-gnueabi $(TARGET)
pic:	all txt_to_png.py
	qemu-arm -L /usr/arm-linux-gnueabi $(TARGET) > pixel_art.txt
	python3 txt_to_png.py
