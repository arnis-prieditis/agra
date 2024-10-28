TARGET=agra
OBJS= framebuffer.o $(TARGET)_main.o c_draw.o $(TARGET).o
CC=arm-linux-gnueabi-gcc
LINKER=arm-linux-gnueabi-gcc
AS=arm-linux-gnueabi-as
ASFLAGS=-mcpu=xscale -alh=$*.lis -L -g
CFLAGS = -O0 -Wall -g

all:	$(OBJS)
	$(LINKER) -g -o $(TARGET) $^

%.o:	%.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.o:	%.s
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	$(RM) *.o $(TARGET) $(TARGET).lis 

test:   all 
	qemu-arm -L /usr/arm-linux-gnueabi $(TARGET) 

