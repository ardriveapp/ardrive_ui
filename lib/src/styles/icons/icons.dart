import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:flutter/material.dart';

class ArDriveIcon extends StatelessWidget {
  const ArDriveIcon({
    super.key,
    this.color,
    this.size,
    required this.icon,
  });

  final double? size;
  final Color? color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color ?? ArDriveTheme.of(context).themeData.colors.themeFgDefault,
    );
  }

  ArDriveIcon copyWith({
    double? size,
    Color? color,
    IconData? icon,
  }) {
    return ArDriveIcon(
      icon: icon ?? this.icon,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }
}

class ArDriveIcons {
  static ArDriveIcon closeIconCircle({double? size, Color? color}) =>
      ArDriveIcon(
        icon: ArDriveIconsData.close_icon_circle,
        color: color,
        size: size,
      );

  static ArDriveIcon closeIcon({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.close_icon,
        color: color,
        size: size,
      );

  static ArDriveIcon uploadCloud({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.cloud_upload,
        size: size,
        color: color,
      );

  static ArDriveIcon checkSuccess({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.check_success,
        size: size,
        color: color,
      );

  static ArDriveIcon warning({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.warning,
        size: size,
        color: color,
      );

  static ArDriveIcon checked({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.checked,
        size: size,
        color: color,
      );

  static ArDriveIcon indeterminateIndicator({
    double? size,
    Color? color,
  }) =>
      ArDriveIcon(
        icon: ArDriveIconsData.indeterminate_indicator,
        size: size,
        color: color,
      );

  static ArDriveIcon chevronRight({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.chevron_right,
        size: size,
        color: color,
      );

  static ArDriveIcon chevronLeft({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.chevron_left,
        size: size,
        color: color,
      );

  static ArDriveIcon chevronUp({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.chevron_up,
        size: size,
        color: color,
      );

  static ArDriveIcon chevronDown({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.chevron_down,
        size: size,
        color: color,
      );

  static ArDriveIcon dots({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.dots,
        size: size,
        color: color,
      );

  static ArDriveIcon eyeOff({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.eye_off,
        size: size,
        color: color,
      );

  static ArDriveIcon eye({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.eye,
        size: size,
        color: color,
      );

  static ArDriveIcon arrowLeftCircle({double? size, Color? color}) =>
      ArDriveIcon(
        icon: ArDriveIconsData.arrow_left_circle,
        size: size,
        color: color,
      );

  static ArDriveIcon arrowRightCircle({double? size, Color? color}) =>
      ArDriveIcon(
        icon: ArDriveIconsData.arrow_right_circle,
        size: size,
        color: color,
      );

  static ArDriveIcon fileCode({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.file_outlined,
        size: size,
        color: color,
      );

  static ArDriveIcon info({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.info,
        size: size,
        color: color,
      );

  static ArDriveIcon fileDoc({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.file_outlined,
        size: size,
        color: color,
      );

  static ArDriveIcon share({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.share,
        size: size,
        color: color,
      );

  static ArDriveIcon fileMusic({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.file_music_1,
        size: size,
        color: color,
      );

  static ArDriveIcon edit({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.edit_2,
        size: size,
        color: color,
      );

  static ArDriveIcon fileVideo({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.file_video,
        size: size,
        color: color,
      );

  static ArDriveIcon download({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.cloud_download,
        size: size,
        color: color,
      );

  static ArDriveIcon fileZip({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.file_zip,
        size: size,
        color: color,
      );

  static ArDriveIcon fileImage({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.image,
        size: size,
        color: color,
      );

  static ArDriveIcon file({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.file_filled,
        size: size,
        color: color,
      );

  static ArDriveIcon folderOutlined({double? size, Color? color}) =>
      ArDriveIcon(
        icon: ArDriveIconsData.folder_outlined,
        size: size,
        color: color,
      );

  static ArDriveIcon folderFilled({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.folder_fill,
        size: size,
        color: color,
      );

  //sync
  static ArDriveIcon sync({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.sync_icon,
        size: size,
        color: color,
      );

  // logout
  static ArDriveIcon logout({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.logout,
        size: size,
        color: color,
      );

  // menu arrow
  static ArDriveIcon menuArrow({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.menu_arrow,
        size: size,
        color: color,
      );

  // fileOutlined
  static ArDriveIcon fileOutlined({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.file_outlined,
        size: size,
        color: color,
      );
  // external link
  static ArDriveIcon externalLink({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.external_link,
        size: size,
        color: color,
      );

  // arrow back
  static ArDriveIcon arrowBack({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.arrow_back,
        size: size,
        color: color,
      );

  // copy
  static ArDriveIcon copy({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.copy_1,
        size: size,
        color: color,
      );

  // move
  static ArDriveIcon move({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.move,
        size: size,
        color: color,
      );

  // folder add
  static ArDriveIcon folderAdd({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.icon_new_folder,
        size: size,
        color: color,
      );

  // plus
  static ArDriveIcon plus({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.plus,
        size: size,
        color: color,
      );

  // driv
  static ArDriveIcon drive({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.style_4,
        size: size,
        color: color,
      );
  // help
  static ArDriveIcon help({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.help,
        size: size,
        color: color,
      );

  // arrow forward filled
  static ArDriveIcon arrowForwardFilled({double? size, Color? color}) =>
      ArDriveIcon(
        icon: ArDriveIconsData.arrow_forward_filled,
        size: size,
        color: color,
      );

  // image
  static ArDriveIcon image({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.image,
        size: size,
        color: color,
      );

  // manifest
  static ArDriveIcon manifest({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.manifest,
        size: size,
        color: color,
      );

  // close button
  static ArDriveIcon closeButton({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.close_button,
        size: size,
        color: color,
      );

  // camera
  static ArDriveIcon camera({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.camera,
        size: size,
        color: color,
      );

  // person
  static ArDriveIcon person({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.person,
        size: size,
        color: color,
      );

  // arrow back filled
  static ArDriveIcon arrowBackFilled({double? size, Color? color}) =>
      ArDriveIcon(
        icon: ArDriveIconsData.arrow_back_filled,
        size: size,
        color: color,
      );

  // options
  static ArDriveIcon options({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.options,
        size: size,
        color: color,
      );

  // attach drive
  static ArDriveIcon attachDrive({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.icon_attach_drive,
        size: size,
        color: color,
      );

  // add drive
  static ArDriveIcon addDrive({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.icon_add_drive,
        size: size,
        color: color,
      );

  // snapshot
  static ArDriveIcon snapshot({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.icon_create_snapshot,
        size: size,
        color: color,
      );

  // dots_vert
  static ArDriveIcon dotsVert({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.dots_vert,
        size: size,
        color: color,
      );
  // folder upload
  static ArDriveIcon uploadFolder({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.icon_upload_folder,
        size: size,
        color: color,
      );

  // create folder
  static ArDriveIcon newFolder({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.icon_new_folder,
        size: size,
        color: color,
      );

  // add file
  static ArDriveIcon addFile({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.icon_upload_files,
        size: size,
        color: color,
      );
  // arconnect
  static ArDriveIcon arconnect({double? size, Color? color}) => ArDriveIcon(
        icon: ArDriveIconsData.arconnect_icon_1,
        size: size,
        color: color,
      );
}
