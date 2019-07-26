include version.mk

default: createroll

# Create the mirror...
# NOTE: Because of the structure of the nVIDIA repository the resulting ISO will be empty...
mirrorrepo:
	[ -f /root/.wgetrc ] && mv -v /root/.wgetrc /root/.wgetrc.sav
	/bin/cp ./wgetrc /root/.wgetrc
	/opt/rocks/bin/rocks create mirror $(MIRRORURL)/$(BASEPATH) arch=$(ARCH) rollname=$(DISTRO) version=$(VERSION) release=$(RELEASE)
	[ -f /root/.wgetrc.sav ] && mv -vf /root/.wgetrc.sav /root/.wgetrc

createroll:
	/bin/rm -f ./$(DISTRO)-$(VERSION)*.iso
	/bin/ln -sf ./developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 ./RPMS
	/opt/rocks/bin/rocks create roll roll-$(DISTRO).xml
	/bin/rm -rf ./disk1

testing:
	echo "arch is " $(ARCH)
	curl -I $(MIRRORURL)/$(BASEPATH)/7fa2af80.pub
