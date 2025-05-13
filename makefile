CC = cl
CFLAGS = /O2 /GS- /Gf /Gr /kernel- /Zl
LDFLAGS = /NODEFAULTLIB /ENTRY:main user32.lib kernel32.lib
TARGET = capbeep.exe
SRCS = capbeep.c
OBJS = $(SRCS:.c=.obj)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) /link $(LDFLAGS) /OUT:$(TARGET)

$(OBJS): $(SRCS)
	$(CC) $(CFLAGS) /c $(SRCS)

clean:
	del /Q $(OBJS) $(TARGET)
