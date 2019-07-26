
# cuda-roll build Information

## mirrorrepo step

The `mirrorrepo` step of the `Makefile` will use the Rocks `create mirror`
command to create a local mirror of the NVIDIA CUDA repository for the
architecture and Redhat release specified in the `version.mk` file.

In addition, since the NVIDIA RPM repository for rhel7 includes a complete
set of RPMs for the ppc64le architecture and *NONE* of those files will be
used in Rocks7 that directory is excluded from the wget action with the
use of a `.wgetrc` file for the root user. The correct file is included
in this repository and copied to the `/root` directory during the `mirrorrepo`
step. An existing `/root/.wgetrc` file is saved/restored if found.


```
# make mirrorrepo
[ -f /root/.wgetrc ] && mv -v /root/.wgetrc /root/.wgetrc.sav
‘/root/.wgetrc’ -> ‘/root/.wgetrc.sav’
/bin/cp ./wgetrc /root/.wgetrc
/opt/rocks/bin/rocks create mirror https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 arch=x86_64 rollname=cuda-rhel7 version=2019.07.25 release=0
2019-07-25 17:12:43 URL:https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/ [199625/199625] -> "developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64.19" [1]
2019-07-25 17:12:43 URL:https://developer.download.nvidia.com/compute/cuda/repos/rhel7/ [636/636] -> "developer.download.nvidia.com/compute/cuda/repos/rhel7/index.html" [1]
...<snip>...
2019-07-25 17:13:22 URL:https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-9-1-9.1.85-1.x86_64.rpm [6228/6228] -> "developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-9-1-9.1.85-1.x86_64.rpm" [1]
2019-07-25 17:13:22 URL:https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-9-2-9.2.88-1.x86_64.rpm [6228/6228] -> "developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-9-2-9.2.88-1.x86_64.rpm" [1]
FINISHED --2019-07-25 17:13:26--
Total wall clock time: 43s
Downloaded: 219 files, 7.7G in 33s (239 MB/s)
Creating disk1 (0.00MB)...
Building ISO image for disk1 ...
mkisofs: mkisofs -R -f -T -V "cuda-rhel7 disk1"  -o /export/rocks/src/roll/cuda-roll/cuda-rhel7-2019.07.25-0.x86_64.disk1.iso .
/usr/bin/yumdownloader --enablerepo=epel --destdir=developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 --downloadonly libva-vdpau-driver opencl-filesystem ocl-icd
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * epel: mirror.prgmr.com
exiting because "Download Only" specified
[ -f /root/.wgetrc.sav ] && mv -vf /root/.wgetrc.sav /root/.wgetrc
‘/root/.wgetrc.sav’ -> ‘/root/.wgetrc’
```

The `ISO` file created by this step **WILL NOT** contain any RPMs...

```
# ls -l cuda-rhel7-2019.07.25-0.x86_64.disk1.iso
-rw-r--r-- 1 root wheel 385024 Jul 25 09:46 cuda-rhel7-2019.07.25-0.x86_64.disk1.iso

# isoinfo -R -f -i cuda-rhel7-2019.07.25-0.x86_64.disk1.iso | grep -E "\.rpm$"
```

## filterrepo step

The `filterrepo` step of the `Makefile` can be used to remove RPMs which are not
needed on the target system from the mirror and subsequently from the ISO that
is generated in the `createroll` step.

```
[tcooper@manzanita-devel-0-0 cuda-roll]$ sudo make filterrepo
find developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 -name "*7.0*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-7.0-28.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-7-0-7.0-28.x86_64.rpm’
...<snip>...
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-toolkit-7-0-7.0-28.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-7-0-7.0-28.x86_64.rpm’
find developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 -name "*8-0-8.0.44*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-8-0-8.0.44-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-command-line-tools-8-0-8.0.44-1.x86_64.rpm’
...<snip>...
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-toolkit-8-0-8.0.44-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-8-0-8.0.44-1.x86_64.rpm’
find developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 -name cuda-cublas-8-0-8.0.61-1.x86_64.rpm | xargs /bin/rm -vf
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-cublas-8-0-8.0.61-1.x86_64.rpm’
find developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 -name cuda-cublas-dev-8-0-8.0.61-1.x86_64.rpm | xargs /bin/rm -vf
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-cublas-dev-8-0-8.0.61-1.x86_64.rpm’
find developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 -name "*9.[01]*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-9.0.176-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-9-0-9.0.176-1.x86_64.rpm’
...<snip>...
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-9-0-9.0.176-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-9-1-9.1.85-1.x86_64.rpm’
find developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 -name "*9-2-9.2.88*" | sort | xargs /bin/rm -vf
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-9-2-9.2.88-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-command-line-tools-9-2-9.2.88-1.x86_64.rpm’
...<snip>...
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-tools-9-2-9.2.88-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-9-2-9.2.88-1.x86_64.rpm’
find developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 -name "*10.0*" ! -name "cuda-license-*" | sort | xargs /bin/rm -vf
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-10-0-10.0.130-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-10.0.130-1.x86_64.rpm’
...<snip>...
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-tools-10-0-10.0.130-1.x86_64.rpm’
removed ‘developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-visual-tools-10-0-10.0.130-1.x86_64.rpm’
```


## createroll step

The `createroll` step of the `Makefile` will modify some of the output of the
previous `mirrorrepo` step and then use the Rocks `create roll` command to
generate a `ISO` from the local NVIDIA CUDA repository created in the `mirrorrepo`
step.

```
# make createroll
/bin/rm -f ./cuda-rhel7-2019.07.25*.iso
/bin/ln -sf ./developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64 ./RPMS
/opt/rocks/bin/rocks create roll roll-cuda-rhel7.xml
Creating disk1 (0.00MB)...
Building ISO image for disk1 ...
mkisofs: mkisofs -R -f -T -V "cuda-rhel7 disk1"  -o /export/rocks/src/roll/cuda-roll/cuda-rhel7-2019.07.25-0.x86_64.disk1.iso .
/bin/rm -rf ./disk1
```

The `ISO` file created by this step **WILL** contain RPMs...

```
# ls -l cuda-rhel7-2019.07.25-0.x86_64.disk1.iso
-rw-r--r-- 1 root wheel 9590994944 Jul 25 09:52 cuda-rhel7-2019.07.25-0.x86_64.disk1.iso

# isoinfo -R -f -i cuda-rhel7-2019.07.25-0.x86_64.disk1.iso | grep -E "\.rpm$" | wc -l
284
```

...and can be used to add CUDA support to nodes in your cluster.

This roll **DOES NOT** add any graph and/or node `XML` files to your distribution.
