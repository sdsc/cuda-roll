# cuda-roll

This roll will simply allow you to create a mirror of the nVIDIA cuda repository for your Rocks system to easily add the RPMs to your Rocks distribution.

There are no graph or node files defining what to install on your nodes that is left up to you.

Modify the `version.mk` file to change from rhel7 to rhel6 RPMs.

This roll requires ~15GB of free space to download all of the CUDA RPMs and create the Rocks roll ISO file.
