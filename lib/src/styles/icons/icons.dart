import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArDriveIcon extends StatelessWidget {
  const ArDriveIcon({
    super.key,
    required this.path,
    this.color,
    this.size = 20,
  });

  final String path;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (path.endsWith('.svg')) {
      return _buildSvgIcon(context);
    } else {
      return _buildPngIcon(context);
    }
  }

  Widget _buildPngIcon(BuildContext context) {
    return Image.asset(
      path,
      color: color ?? ArDriveTheme.of(context).themeData.colors.themeFgOnAccent,
      height: size,
      width: size,
      package: 'ardrive_ui',
    );
  }

  Widget _buildSvgIcon(context) {
    return SvgPicture.asset(
      path,
      color: color ?? ArDriveTheme.of(context).themeData.colors.themeFgOnAccent,
      height: size,
      width: size,
      package: 'ardrive_ui',
    );
  }
}

class ArDriveIcons {
  static ArDriveIcon closeIconCircle({double? size, Color? color}) =>
      ArDriveIcon(
        path: 'assets/icons/close_icon_circle.svg',
        color: color,
        size: size,
      );

  static ArDriveIcon closeIcon({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/close_icon.svg',
        color: color,
        size: size,
      );

  static ArDriveIcon uploadCloud({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/cloud_upload.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon checkSuccess({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/check_success.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon warning({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/warning.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon checked({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/checked.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon indeterminateIndicator({
    double? size,
    Color? color,
  }) =>
      ArDriveIcon(
        path: 'assets/icons/indeterminate_indicator.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon chevronRight({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/chevron_right.svg',
        size: size,
        color: color,
      );
  static ArDriveIcon chevronLeft({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/chevron_left.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon chevronUp({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/chevron_up.svg',
        size: size,
        color: color,
      );
  static ArDriveIcon chevronDown({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/chevron_down.svg',
        size: size,
        color: color,
      );
  static ArDriveIcon dots({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/dots.svg',
        size: size,
        color: color,
      );
  static ArDriveIcon arConnectLogo({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/arconnect_logo.svg',
        size: size,
        color: color,
      );
  static ArDriveIcon eyeOff({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/eye_off.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon eye({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/eye.svg',
        size: size,
        color: color,
      );

  static ArDriveIcon arrowLeftCircle({double? size, Color? color}) =>
      ArDriveIcon(
        path: 'assets/icons/arrow_left_circle.svg',
        size: size,
        color: color,
      );
  static ArDriveIcon arrowRightCircle({double? size, Color? color}) =>
      ArDriveIcon(
        path: 'assets/icons/arrow_right_circle.svg',
        size: size,
        color: color,
      );

  // file_code
  static ArDriveIcon fileCode({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/file_code.svg',
        size: size,
        color: color,
      );
  // info
  static ArDriveIcon info({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/info.svg',
        size: size,
        color: color,
      );

  // file_doc
  static ArDriveIcon fileDoc({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/file_doc.svg',
        size: size,
        color: color,
      );
  // share
  static ArDriveIcon share({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/share.svg',
        size: size,
        color: color,
      );

  // file_music
  static ArDriveIcon fileMusic({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/file_music.svg',
        size: size,
        color: color,
      );
  // edit
  static ArDriveIcon edit({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/edit.svg',
        size: size,
        color: color,
      );

  // file_video
  static ArDriveIcon fileVideo({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/file_video.svg',
        size: size,
        color: color,
      );
  //download
  static ArDriveIcon download({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/download.svg',
        size: size,
        color: color,
      );

  // file_zip
  static ArDriveIcon fileZip({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/file_zip.svg',
        size: size,
        color: color,
      );

  //move
  static ArDriveIcon move({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/move.svg',
        size: size,
        color: color,
      );

  // external link
  static ArDriveIcon externalLink({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/external_link.svg',
        size: size,
        color: color,
      );

  // folder outlined
  static ArDriveIcon folderOutlined({double? size, Color? color}) =>
      ArDriveIcon(
        path: 'assets/icons/folder_outlined.svg',
        size: size,
        color: color,
      );

  // image
  static ArDriveIcon image({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/image.svg',
        size: size,
        color: color,
      );

  // folder fill
  static ArDriveIcon folderFilled({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/folder_fill.svg',
        size: size,
        color: color,
      );

  // folder add
  static ArDriveIcon folderAdd({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/folder_add.svg',
        size: size,
        color: color,
      );

  // file fill
  static ArDriveIcon fileFilled({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/file_filled.svg',
        size: size,
        color: color,
      );

  // file outlined
  static ArDriveIcon fileOutlined({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/file_outlined.svg',
        size: size,
        color: color,
      );

  // arrow back
  static ArDriveIcon arrowBack({double? size, Color? color}) => ArDriveIcon(
        path: 'assets/icons/arrow_back.svg',
        size: size,
        color: color,
      );
}
