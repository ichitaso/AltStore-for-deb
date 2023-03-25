TARGET = AltStore
ID = "com.ichitaso.altstore"
VERSION = 1_6_2
PKG_VER = 1.6.2

.PHONY: all clean

all: clean
# https://github.com/permasigner/permasigner
# https://permasigner.itsnebula.net/usage/run-on-macos
	python3 -m permasigner -u https://cdn.altstore.io/file/altstore/apps/altstore/$(VERSION).ipa -o ./
	mkdir deb-extract
	dpkg -x $(TARGET)_$(PKG_VER).deb ./deb-extract
	dpkg -e $(TARGET)_$(PKG_VER).deb ./deb-extract/DEBIAN
	cp -a control deb-extract/DEBIAN/control
	cp -a postinst deb-extract/DEBIAN/postinst
	cp -a postrm deb-extract/DEBIAN/postrm
	rm -f deb-extract/DEBIAN/prerm
	chmod 755 deb-extract/DEBIAN/postinst
	chmod 755 deb-extract/DEBIAN/postrm
	ldid -s deb-extract/DEBIAN/postinst
	find . -name ".DS_Store" | xargs rm
	fakeroot dpkg-deb -b -Zgzip deb-extract $(ID)_$(PKG_VER)_iphoneos-arm.deb
	rm -rf deb-extract $(TARGET)_$(PKG_VER).deb

clean:
	rm -rf deb-extract Payload ./*.ipa ./*.deb
