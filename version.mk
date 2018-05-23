DISTRO        = cuda-roll
ARCH          = x86_64
VERSION       = rhel7
DATE         :=$(shell date +%Y.%m.%d)
ifndef MIRRORURL
  MIRRORURL   =https://developer.download.nvidia.com/compute/cuda/repos
endif
BASEPATH      = $(VERSION)/$(ARCH)
