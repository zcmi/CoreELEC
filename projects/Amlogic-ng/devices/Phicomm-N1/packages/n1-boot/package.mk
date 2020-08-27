PKG_NAME="n1-boot"
PKG_VERSION="1.1"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain u-boot-tools-aml u-boot-script"
PKG_DEPENDS_UNPACK="linux"
PKG_TOOLCHAIN="manual"
PKG_NEED_UNPACK="$PKG_DIR/sources $PROJECT_DIR/$PROJECT/devices/$DEVICE/bootloader "

make_target() {
  # Enter kernel directory
  pushd $BUILD/linux-$(kernel_version) > /dev/null
  
  cp -av $PKG_DIR/sources/meson-gxl-s905d-phicomm-n1.dts arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/coreelec-gxl/
  
  # Compile device trees
  kernel_make coreelec-gxl/meson-gxl-s905d-phicomm-n1.dtb
  cp arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/coreelec-gxl/*.dtb $PKG_BUILD
  
  popd > /dev/null
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  
  find_file_path bootloader/uEnv.ini && cp -av ${FOUND_PATH} $INSTALL/usr/share/bootloader/
  for src in $INSTALL/usr/share/bootloader/*.ini ; do
      sed -e "s/@BOOT_LABEL@/$DISTRO_BOOTLABEL/g" \
          -e "s/@DISK_LABEL@/$DISTRO_DISKLABEL/g" \
          -i "$src"

      sed -e "s/@DTB_NAME@/$DEFAULT_DTB_NAME/g" \
          -i "$src"
  done
  
  # Always install the update script
  find_file_path bootloader/update.sh && cp -av ${FOUND_PATH} $INSTALL/usr/share/bootloader
  sed -e "s/@KERNEL_NAME@/$KERNEL_NAME/g" \
      -e "s/@LEGACY_KERNEL_NAME@/$LEGACY_KERNEL_NAME/g" \
      -e "s/@LEGACY_DTB_NAME@/$LEGACY_DTB_NAME/g" \
      -i $INSTALL/usr/share/bootloader/update.sh

  # Always install the canupdate script
  if find_file_path bootloader/canupdate.sh; then
    cp -av ${FOUND_PATH} $INSTALL/usr/share/bootloader
  fi
  
  # Install dtb file
  mkdir -p $INSTALL/usr/share/bootloader/device_trees
  cp -av $PKG_BUILD/*.dtb $INSTALL/usr/share/bootloader/device_trees
      
}
