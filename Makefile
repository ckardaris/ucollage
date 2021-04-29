PREFIX?=/
PREFIX_PATH=$(shell readlink -f ${PREFIX})
INSTALL_DIR=${PREFIX_PATH}/usr/bin
DOC_DIR=${PREFIX_PATH}/usr/share/doc/ucollage
MAN_DIR=${PREFIX_PATH}/usr/share/man/man1
LICENSE_DIR=${PREFIX_PATH}/usr/share/licenses/ucollage
SHARE_DIR=${PREFIX_PATH}/usr/share/ucollage
SRC_DIR=${SHARE_DIR}/src
CONFIG_DIR=${PREFIX_PATH}/etc/ucollage

all: help

help:
	@echo "Usage: make [PREFIX=<path>] <option>"
	@echo
	@echo "Optional arguments:"
	@echo "PREFIX      the directory to install the ucollage tree (default: /)"
	@echo
	@echo "Options:"
	@echo "install     install ucollage"
	@echo "uninstall   remove ucollage files and directories"
	@echo "help        show this message"

install:
	@echo "Checking that make is called from inside the base directory..."
	@[ -f Makefile ]
	@echo OK
	@echo "Creating necessary directories..."
	@mkdir -p ${INSTALL_DIR}
	@mkdir -p ${DOC_DIR}
	@mkdir -p ${MAN_DIR}
	@mkdir -p ${SRC_DIR}
	@mkdir -p ${CONFIG_DIR}
	@echo OK
	@echo "Installing files..."
	@cp ucollage ucollage.bak
	@sed -i "s|{{UCOLLAGE_PREFIX_DIR}}|${PREFIX_PATH}|" ucollage.bak
	@install -Dm755 ucollage.bak ${INSTALL_DIR}/ucollage
	@rm -f ucollage.bak
	@install -Dm644 README.md -t ${DOC_DIR}
	@install -Dm644 LICENSE -t ${LICENSE_DIR}
	@gzip -k man/ucollage.1
	@install -Dm644 man/ucollage.1.gz -t ${MAN_DIR}
	@rm -f man/ucollage.1.gz
	@install -Dm644 etc/* -t ${CONFIG_DIR}
# clean directory in case filename changes happen between versions
	@rm -f ${SRC_DIR}/*
	@install -Dm644 src/* -t ${SRC_DIR}
	@echo OK
	@echo Succesful installation
	@echo Directory: ${PREFIX_PATH}

uninstall:
	@echo "Checking that make is called from inside the base directory..."
	@[[ -f Makefile ]]
	@echo OK
	@echo "Removing files and directories..."
	@rm -rf ${DOC_DIR}
	@rm -rf ${CONFIG_DIR}
	@rm -rf ${SHARE_DIR}
	@rm -rf ${LICENSE_DIR}
	@rm -f  ${INSTALL_DIR}/ucollage
	@rm -f  ${MAN_DIR}/ucollage.1.gz
	@echo OK
	@echo Succesful removal
	@echo Directory: ${PREFIX_PATH}
