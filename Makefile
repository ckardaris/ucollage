PREFIX?=/usr
INSTALL_DIR?=${PREFIX}/bin
DOC_DIR?=${PREFIX}/share/doc/ucollage
MAN_DIR?=${PREFIX}/share/man/man1

all: 
	@echo Run \'make install\' to install ucollage

install:
	mkdir -p ${INSTALL_DIR}
	mkdir -p ${DOC_DIR}
	mkdir -p ${MAN_DIR}
	install -Dm755 ucollage -t ${INSTALL_DIR}
	install -Dm644 README.md -t ${DOC_DIR}
	gzip -k ucollage.1
	install -Dm644 ucollage.1.gz -t ${MAN_DIR}
	rm -f ucollage.1.gz

uninstall:
	rm -f ${INSTALL_DIR}/ucollage
	rm -rf ${DOC_DIR}
	rm -f ${MAN_DIR}/ucollage.1
