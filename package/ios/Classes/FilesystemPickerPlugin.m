#import "FilesystemPickerPlugin.h"
#if __has_include(<filesystem_picker_plugin/filesystem_picker_plugin-Swift.h>)
#import <filesystem_picker_plugin/filesystem_picker_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "filesystem_picker_plugin-Swift.h"
#endif

@implementation FilesystemPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFilesystemPickerPlugin registerWithRegistrar:registrar];
}
@end
