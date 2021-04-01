PKG_NAME="u-boot-Phicomm_N1"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain u-boot-tools-aml u-boot-script"
PKG_DEPENDS_UNPACK="linux"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  cp -av $PKG_DIR/sources/*.ini $INSTALL/usr/share/bootloader/
  for src in $INSTALL/usr/share/bootloader/*.ini ; do
      sed -e "s/@BOOT_LABEL@/$DISTRO_BOOTLABEL/g" \
          -e "s/@DISK_LABEL@/$DISTRO_DISKLABEL/g" \
          -i "$src"

      sed -e "s/@DTB_NAME@/$DEFAULT_DTB_NAME/g" \
          -i "$src"
  done
  
  # Always install the update script
  cp -av $PKG_DIR/sources/update.sh $INSTALL/usr/share/bootloader
  sed -e "s/@KERNEL_NAME@/$KERNEL_NAME/g" \
      -e "s/@LEGACY_KERNEL_NAME@/$LEGACY_KERNEL_NAME/g" \
      -e "s/@LEGACY_DTB_NAME@/$LEGACY_DTB_NAME/g" \
      -i $INSTALL/usr/share/bootloader/update.sh

  # Always install the canupdate script
  #cp -av $PKG_DIR/sources/canupdate.sh $INSTALL/usr/share/bootloader
  
  # Install dtb file
  cp -av $BUILD/build/linux-$(kernel_version)/arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/coreelec-gxl/gxl_p230_2g.dtb $INSTALL/usr/share/bootloader/Phicomm_N1_dtb.img
}
