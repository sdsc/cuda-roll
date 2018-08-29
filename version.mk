DISTRO        = cuda-rhel7
ARCH          = x86_64
#VERSION       = rhel7
VERSION      :=$(shell date +%Y.%m.%d)
ifndef MIRRORURL
  MIRRORURL   = https://developer.download.nvidia.com/compute/cuda/repos
endif
BASEPATH      = rhel7/$(ARCH)
