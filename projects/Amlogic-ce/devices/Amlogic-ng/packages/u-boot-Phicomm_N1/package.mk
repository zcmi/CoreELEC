PKG_NAME="u-boot-Phicomm_N1"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain u-boot-tools-aml u-boot-script"
PKG_DEPENDS_UNPACK="linux"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  
  # Install dtb file
  cp -av $BUILD/build/linux-$(kernel_version)/arch/$TARGET_KERNEL_ARCH/boot/dts/amlogic/coreelec-gxl/gxl_p230_2g.dtb $INSTALL/usr/share/bootloader/Phicomm_N1_dtb.img
}
