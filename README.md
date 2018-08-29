# cuda-roll

This roll will help you to create a local archive/mirror of the [NVIDIA CUDA repository](https://developer.download.nvidia.com/compute/cuda/repos/rhel7/) for your Rocks system, easily add the RPMs to your Rocks distribution and install CUDA support onto your nodes.

There are no graph or node files defining what to install on your nodes. That is left up to you to define for your system.

Modify the `version.mk` file to change from rhel7 to rhel6 RPMs.

This roll requires ~25GB of free space to download all of the CUDA RPMs in the NVIDIA repository and another ~8GB to create the Rocks roll ISO file.

## Instructions

1. Clone this repository into a directory/filesystem with at least 36GB of free space
2. Mirror the NVIDIA CUDA repository with...
```
# make mirrorrepo
```
3. Create the roll ISO with...
```
# make createrepo
```
4. Add/enable the cuda-rhel7 roll to your Rocks distribution with...
```
# rocks add roll cuda-rhel7-*
# rocks enable roll cuda-rhel7
```
5. Rebuild your Rocks distribution with...
```
# cd /export/rocks/install
# rocks create distro
```
6. Add cuda support to a test system using yum and the cuda metapackages...
```
# yum install cuda-7-0 cuda-7-5 cuda-8-0 cuda-9-2
```
7. Determine how you'd like to deploy cuda to your cluster and implement that.
