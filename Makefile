
PREFIX ?= /usr/local
LIBDIR ?= ${PREFIX}/lib
BINDIR ?= ${PREFIX}/bin
SHAREDIR ?= ${PREFIX}/share
PWD ?= `pwd`
TMPDIR ?= ${PWD}/tmp

LUA_VERSION ?= 5.1
LUA_SHAREDIR ?= ${SHAREDIR}/lua/${LUA_VERSION}

PROJECT ?= porteail

all: compile

test:
	test -d "${TMPDIR}" || mkdir "${TMPDIR}"

compile: test
	moonc -t "${TMPDIR}" "${PWD}/${PROJECT}/config.moon"
	moonc -t "${TMPDIR}" "${PWD}/porteail.moon"

install:
	mkdir -p "${DESTDIR}${BINDIR}"
	mkdir -p "${DESTDIR}${LUA_SHAREDIR}/${PROJECT}"
	install -m0755 ${TMPDIR}/${PROJECT}.lua "${DESTDIR}${BINDIR}/${PROJECT}"
	install -m0644 ${TMPDIR}/config.lua "${DESTDIR}${LUA_SHAREDIR}/${PROJECT}/config.lua"

uninstall:
	rm -f "${DESTDIR}${BINDIR}/${PROJECT}"
	rm -f ${LUA_SHAREDIR}/${PROJECT}/config.lua
	rmdir "${DESTDIR}${LUA_SHAREDIR}/${PROJECT}"

clean:
	rm -rf "${TMPDIR}/"
