#Compiler and Linker
CC          := nasm
LINKER		:= gcc

#The Directories, Source, Includes, Objects, Binary and Resources
SRCDIR      := src
INCDIR      := inc
BUILDDIR    := obj
TARGETDIR   := bin
SRCEXT      := asm
DEPEXT      := d
OBJEXT      := o

#Flags, Libraries and Includes
CFLAGS      := -felf64 -Worphan-labels -w-macro-params
LFLAGS		:= -lc -fPIE
LIB         :=
INC         :=


#--------------------------------------------------------------------------------------

SOURCES     := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS     := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))
TARGETS		:= $(patsubst $(SRCDIR)/%.$(SRCEXT),$(TARGETDIR)/%,$(SOURCES))

#Default Make
all: $(TARGETS)

#Remake
remake: cleaner all


#Clean only Objects
clean:
	$(RM) -rf $(BUILDDIR)

#Full Clean, Objects and Binaries
cleaner: clean
	$(RM) -rf $(TARGETDIR)

#Link
$(TARGETDIR)/%: $(BUILDDIR)/%.$(OBJEXT) | $(TARGETDIR)
	@mkdir -p $(dir $@)
	$(LINKER) $(LFLAGS) $< $(LIB) $(INC) -o $@

#Compile
$(BUILDDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT) | $(BUILDDIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $<

$(TARGETDIR):
	@mkdir -p $(TARGETDIR)

$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

#Non-File Targets
.PHONY: all remake clean cleaner resources
