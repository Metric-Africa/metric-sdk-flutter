#import "MetricSdkPlugin.h"

// checks if this file exists as it contains actual implementation of plugin logic with swift code
#if __has_include(<metric_sdk/metric_sdk-Swift.h>)
#import <metric_sdk/metric_sdk-Swift.h>

//if file doesn't exist, fallback to use the same swift header file
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "metric_sdk-Swift.h"
#endif

// Swift static libraries don't automatically copy their generated Objective-C header

@implementation MetricSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftMetricSdkPlugin registerWithRegistrar:registrar];
}
@end
