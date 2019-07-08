# Common versions and dependency information for use by other shell scripts in KLB
#
# Requires $klb_dir to be set to the top level kubos-linux-build directory. Example:
#         klb_dir=$(cd `dirname "$0"`; pwd)
#         . "$klb_dir/tools/deps.sh"
#
#         echo $buildroot_version
#         echo $uboot_branch
#
# Note this script is intended to be consumed by other executables, and is not useful on it's own

klb_latest_tag=`git tag --sort=-creatordate | head -n 1`
klb_board="${KUBOS_BOARD:-beaglebone-black}"

buildroot_version="2019.02.3"
buildroot_dirname="buildroot-$buildroot_version"
buildroot_tar="$buildroot_dirname.tar.gz"
buildroot_url="https://buildroot.uclibc.org/downloads/$buildroot_tar"
buildroot_dir_abs=$(dirname "$klb_dir")/buildroot-$buildroot_version

uboot_branch="1.1"
uboot_branch_iobc="1.0"
