import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '_filelist_theme.dart';
import '_picker_action_theme.dart';
import '_topbar_theme.dart';

abstract class FilesystemPickerThemeBase with Diagnosticable {
  Color getBackgroundColor(BuildContext context, [Color? color]);

  FilesystemPickerTopBarThemeData getTopBar(BuildContext context);

  TextStyle getMessageTextStyle(BuildContext context);

  FilesystemPickerFileListThemeData getFileList(BuildContext context);

  FilesystemPickerActionThemeData getPickerAction(BuildContext context);
}
