
# cuda-roll build Information

## mirrorrepo step

The `mirrorrepo` step of the `Makefile` will use the Rocks `create mirror`
command to create a local mirror of the NVIDIA CUDA repository for the
architecture and Redhat release specified in the `version.mk` file.

```
# make mirrorrepo
/opt/rocks/bin/rocks create mirror https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 arch=x86_64 rollname=cuda-rhel7 version=2018.12.18 release=
2018-12-18 11:33:38 URL:https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/ [146278/146278] -> "developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64.1" [1]
FINISHED --2018-12-18 11:33:44--
Total wall clock time: 6.4s
Downloaded: 1 files, 143K in 0.007s (21.0 MB/s)
Creating disk1 (0.00MB)...
Building ISO image for disk1 ...
mkisofs: mkisofs -R -f -T -V "cuda-rhel7 disk1"  -o /export/rocks/src/roll/cuda-roll/cuda-rhel7-2018.12.18-0.x86_64.disk1.iso .
```

The `ISO` file created by this step **WILL NOT** contain any RPMs...

```
# ls -l cuda-rhel7-2018.12.18-0.x86_64.disk1.iso
-rw-r--r-- 1 root wheel 385024 Dec 18 11:33 cuda-rhel7-2018.12.18-0.x86_64.disk1.iso

# isoinfo -R -f -i cuda-rhel7-2018.12.18-0.x86_64.disk1.iso | grep ".rpm" | wc -l
0
```

## createroll step

The `createroll` step of the `Makefile` will modify some of the output of the
previous `mirrorrepo` step and then use the Rocks `create roll` command to
generate a `ISO` from the local NVIDIA CUDA repository created in the `mirrorrepo`
step.

```
# make createroll
/bin/rm -f ./cuda-rhel7-2018.12.18-0.x86_64.disk1.iso
/bin/ln -sf ./developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 ./RPMS
/opt/rocks/bin/rocks create roll roll-cuda-rhel7.xml
Creating disk1 (0.00MB)...
Building ISO image for disk1 ...
mkisofs: mkisofs -R -f -T -V "cuda-rhel7 disk1"  -o /export/rocks/src/roll/cuda-roll/cuda-rhel7-2018.12.18-0.x86_64.disk1.iso .
/bin/rm -rf ./disk1
```

The `ISO` file created by this step **WILL** contain RPMs...

```
# ls -l cuda-rhel7-2018.12.18-0.x86_64.disk1.iso
-rw-r--r-- 1 root wheel 10405122048 Dec 18 11:34 cuda-rhel7-2018.12.18-0.x86_64.disk1.iso

# isoinfo -R -f -i cuda-rhel7-2018.12.18-0.x86_64.disk1.iso | grep ".rpm" | wc -l
313
```

...and can be used to add CUDA support to nodes in your cluster.

This roll **DOES NOT** add any graph and/or node `XML` files to your distribution.
