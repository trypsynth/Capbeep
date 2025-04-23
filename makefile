CC = cl
CFLAGS = /D_CRT_SECURE_NO_WARNINGS /O2 /EHsc
LDFLAGS = user32.lib kernel32.lib
TARGET = capbeep.exe
SRCS = capbeep.c
OBJS = $(SRCS:.c=.obj)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS) /link /OUT:$(TARGET)

$(OBJS): $(SRCS)
	$(CC) $(CFLAGS) /c $(SRCS)

clean:
	del /Q $(OBJS) $(TARGET)
