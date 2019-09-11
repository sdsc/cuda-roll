include version.mk

default: createroll

# Create the mirror...
# NOTE: Because of the structure of the nVIDIA repository the resulting ISO will be empty...
mirrorrepo:
	[ -f /root/.wgetrc ] && mv -v /root/.wgetrc /root/.wgetrc.sav
	/bin/cp ./wgetrc /root/.wgetrc
	/opt/rocks/bin/rocks create mirror $(MIRRORURL)/$(BASEPATH) arch=$(ARCH) rollname=$(DISTRO) version=$(VERSION) release=$(RELEASE)
	/usr/bin/yumdownloader --enablerepo=epel --destdir=$(MIRRORPATH) --downloadonly libva-vdpau-driver opencl-filesystem ocl-icd
	[ -f /root/.wgetrc.sav ] && mv -vf /root/.wgetrc.sav /root/.wgetrc

filterrepo:
	find $(MIRRORPATH) -name "*7.0*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
	find $(MIRRORPATH) -name "*8-0-8.0.44*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
	#only the cuda-cublas*-8-0-8.0.61-1.x86_64.rpm should be removed in favor of cuda-cublas*-8-0-8.0.61-2.x86_64.rpm
	#find $(MIRRORPATH) -name "*8.0.61*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
	find $(MIRRORPATH) -name cuda-cublas-8-0-8.0.61-1.x86_64.rpm | xargs /bin/rm -vf
	find $(MIRRORPATH) -name cuda-cublas-dev-8-0-8.0.61-1.x86_64.rpm | xargs /bin/rm -vf
	find $(MIRRORPATH) -name "*9.[01]*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
	find $(MIRRORPATH) -name "*9.2.88*" | sort | xargs /bin/rm -vf
	find $(MIRRORPATH) -name "*10.0*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf

createroll:
	/bin/rm -f ./$(DISTRO)-$(VERSION)*.iso
	/bin/ln -sf ./developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 ./RPMS
	/opt/rocks/bin/rocks create roll roll-$(DISTRO).xml
	/bin/rm -rf ./disk1

testing:
	echo "arch is " $(ARCH)
	curl -I $(MIRRORURL)/$(BASEPATH)/7fa2af80.pub
