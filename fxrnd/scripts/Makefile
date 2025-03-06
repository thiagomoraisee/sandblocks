# SandBlocks - Copyright 2024 Thiago M. de Oliveira. Solderpad Hardware License v2.1
# Script     : Makefile                                             Date: 2025.03.06
# Author     : Thiago M. de Oliveira <thiagomoraisee@gmail.com>
# Description: One Makefile to rule them all.

# Individual Makefiles directories:
MAKEFILE_SYSTEMC := ../scripts/Makefile.systemc
MAKEFILE_MODELSIM := ../scripts/Makefile.modelsim
MAKEFILE_LATEX := ../scripts/Makefile.latex

help:
	@echo "Usage: make [environment] [target]"
	@echo ""
	@echo "Environments:"
	@echo "  arch   - ARCH model build and simulation (SystemC)"
	@echo "  rtl    - RTL model build and simulation (ModelSim)"
	@echo "  doc    - DOC compilation and publish (LaTeX)"
	@echo ""
	@echo "Examples:"
	@echo "  make arch run    # Run SystemC simulation"
	@echo "  make rtl gui     # Run RTL simulation with ModelSim GUI"
	@echo "  make doc view    # Visualize compiled documentation in PDF"
clean:
	@echo "Cleanning workspace..."
	@rm -rf *.txt
	@rm -rf *.log
	@rm -rf *.vcd
	@rm -rf *.pdf
	@rm -rf *.pdf

ifeq ($(MAKECMDGOALS), help)

else ifeq ($(MAKECMDGOALS), clean)

else
# Target and environment match
ENVIRONMENT := $(firstword $(MAKECMDGOALS))
TARGET := $(word 2, $(MAKECMDGOALS))

# Remove flow variables to avoid conflicts:
$(eval $(ENVIRONMENT):;@:)

# Environment mapping to Makefiles:
ifeq ($(ENVIRONMENT), arch)
	SUBMAKEFILE := $(MAKEFILE_SYSTEMC)
else ifeq ($(ENVIRONMENT), rtl)
	SUBMAKEFILE := $(MAKEFILE_MODELSIM)
else ifeq ($(ENVIRONMENT), doc)
	SUBMAKEFILE := $(MAKEFILE_LATEX)
else
	$(error Invalid environment! Use: arch, rtl, doc)
endif

# Redirect command to the correspondent Makefile
$(TARGET):
	@$(MAKE) -f $(SUBMAKEFILE) $@
endif
