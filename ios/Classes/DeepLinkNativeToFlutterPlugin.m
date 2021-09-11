#import "DeepLinkNativeToFlutterPlugin.h"
#if __has_include(<deep_link_native_to_flutter/deep_link_native_to_flutter-Swift.h>)
#import <deep_link_native_to_flutter/deep_link_native_to_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "deep_link_native_to_flutter-Swift.h"
#endif

@implementation DeepLinkNativeToFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeepLinkNativeToFlutterPlugin registerWithRegistrar:registrar];
}
@end
