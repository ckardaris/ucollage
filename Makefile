INSTALL_DIR=/usr/bin
DOC_DIR=/usr/share/doc/ucollage
MAN_DIR=/usr/share/man/man1
CONFIG_DIR=/etc/ucollage
all: 
	@echo Run \'make install\' to install ucollage

install:
	mkdir -p ${INSTALL_DIR}
	mkdir -p ${DOC_DIR}
	mkdir -p ${MAN_DIR}
	mkdir -p ${CONFIG_DIR}

	install -Dm755 ucollage -t ${INSTALL_DIR}
	install -Dm644 README.md -t ${DOC_DIR}
	gzip -k ucollage.1
	install -Dm644 ucollage.1.gz -t ${MAN_DIR}
	rm -f ucollage.1.gz
	install -Dm644 default/mappings -t ${CONFIG_DIR}

uninstall:
	rm -f ${INSTALL_DIR}/ucollage
	rm -rf ${DOC_DIR}
	rm -rf ${CONFIG_DIR}
	rm -f ${MAN_DIR}/ucollage.1
