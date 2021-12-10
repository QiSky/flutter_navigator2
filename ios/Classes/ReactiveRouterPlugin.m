#import "ReactiveRouterPlugin.h"
#if __has_include(<reactive_router/reactive_router-Swift.h>)
#import <reactive_router/reactive_router-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "reactive_router-Swift.h"
#endif

@implementation ReactiveRouterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftReactiveRouterPlugin registerWithRegistrar:registrar];
}
@end
