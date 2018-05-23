include version.mk

default: mirrorbase

# Create the Base OS Roll
mirrorbase:
	/opt/rocks/bin/rocks create mirror $(MIRRORURL)/$(BASEPATH) arch=$(ARCH) rollname=$(DISTRO) version=$(VERSION) release=$(DATE)

testing:
	echo "arch is " $(ARCH)
	curl -I $(MIRRORURL)/$(BASEPATH)/7fa2af80.pub
