INSTALL_DIR=/usr/bin
DOC_DIR=/usr/share/doc/ucollage
MAN_DIR=/usr/share/man/man1
LICENSE_DIR=/usr/share/licenses/ucollage
SHARE_DIR=/usr/share/ucollage
SRC_DIR=${SHARE_DIR}/src
CONFIG_DIR=/etc/ucollage
all: 
	@echo Run \'make install\' to install ucollage

install:
	mkdir -p ${INSTALL_DIR}
	mkdir -p ${DOC_DIR}
	mkdir -p ${MAN_DIR}
	mkdir -p ${SRC_DIR}
	mkdir -p ${CONFIG_DIR}

	install -Dm755 ucollage -t ${INSTALL_DIR}
	install -Dm644 README.md -t ${DOC_DIR}
	install -Dm644 LICENSE -t ${LICENSE_DIR}
	gzip -k man/ucollage.1
	install -Dm644 man/ucollage.1.gz -t ${MAN_DIR}
	rm -f man/ucollage.1.gz
	install -Dm644  etc/* -t ${CONFIG_DIR}
	install -Dm644 src/* -t ${SRC_DIR}

uninstall:
	rm -rf ${DOC_DIR}
	rm -rf ${CONFIG_DIR}
	rm -rf ${SHARE_DIR}
	rm -rf ${LICENSE_DIR}
	rm -f ${INSTALL_DIR}/ucollage
	rm -f ${MAN_DIR}/ucollage.1
