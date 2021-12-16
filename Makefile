TARGET = AltStore
ID = "com.ichitaso.altstore"
VERSION = 1_4_8
PKG_VER = 1.4.8

.PHONY: all clean

all: clean
	wget https://cdn.altstore.io/file/altstore/apps/altstore/$(VERSION).ipa
	unzip $(VERSION).ipa > /dev/null 2>&1
	mkdir -p directry/Applications
	mkdir -p directry/DEBIAN
	cp -a Payload/$(TARGET).app directry/Applications/$(TARGET).app
	cp -a control directry/DEBIAN/control
	cp -a postinst directry/DEBIAN/postinst
	chmod 755 directry/DEBIAN/postinst
	find . -name ".DS_Store" | xargs rm
	dpkg-deb -b -Zgzip directry $(ID)_$(PKG_VER)_iphoneos-arm.deb

clean:
	rm -rf directry Payload ./*.ipa ./*.deb
