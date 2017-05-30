set -e

size=3800


mkdir temp
mount -t tmpfs -o size=${size}M tmpfs temp/
cd temp/
dd if=/dev/zero of=disk.img bs=1M count=$size
losetup /dev/loop0 disk.img

# Create the partition table
parted /dev/loop0 mklabel msdos

# Create the partitions
# Partition sizes are now all 4MB aligned
boot_size=20
rootfs_size=20
upgrade_size=52

sd_size=`expr $size - 4`
upgrade_start=`expr $sd_size - $upgrade_size`
rootfs_start=`expr $upgrade_start - $rootfs_size`
boot_start=`expr $rootfs_start - $boot_size`

parted /dev/loop0 mkpart primary ext4   4M                  ${boot_start}M
parted /dev/loop0 mkpart extended       ${boot_start}M      ${sd_size}M
parted /dev/loop0 mkpart logical fat16  ${boot_start}M      ${rootfs_start}M i
parted /dev/loop0 mkpart logical ext4   ${rootfs_start}M    ${upgrade_start}M i
parted /dev/loop0 mkpart logical ext4   ${upgrade_start}M   ${sd_size}M i

sleep 1

# Configure the partitions
mkfs.ext4 /dev/loop0p1
mkfs.fat /dev/loop0p5
mkfs.ext4 /dev/loop0p6
mkfs.ext4 /dev/loop0p7

sleep 1

mkdir /tmp-kubos

mount /dev/loop0p5 /tmp-kubos
cp ../kubos-kernel.itb /tmp-kubos/kernel
sleep 1
umount /dev/loop0p5

mount /dev/loop0p6 /tmp-kubos
tar -xvf ../../../buildroot-2016.11/output/images/rootfs.tar -C /tmp-kubos
sleep 1
umount /dev/loop0p6

rmdir /tmp-kubos

cd ..
losetup -d /dev/loop0
mv temp/disk.img disk.img
umount temp
rmdir temp