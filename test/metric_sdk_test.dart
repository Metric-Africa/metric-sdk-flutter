import 'package:flutter_test/flutter_test.dart';
import 'package:metric_sdk/metric_sdk.dart';
import 'package:metric_sdk/metric_sdk_platform_interface.dart';
import 'package:metric_sdk/metric_sdk_method_channel.dart';
import 'package:metric_sdk/models/models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMetricSdkPlatform
    with MockPlatformInterfaceMixin
    implements MetricSdkPlatform {

  /*@override
  Future<String?> getPlatformVersion() => Future.value('42');*/

  @override
  void initializeSdk(SdkSettings settings) {
    // TODO: implement initializeSdk
  }

  @override
  Future<String> launchSdk(String token) {
    // TODO: implement launchSdk
    throw UnimplementedError();
  }
}

void main() {
  final MetricSdkPlatform initialPlatform = MetricSdkPlatform.instance;

  test('$MethodChannelMetricSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMetricSdk>());
  });

  /*test('getPlatformVersion', () async {
    MetricSdk metricSdkPlugin = MetricSdk();
    MockMetricSdkPlatform fakePlatform = MockMetricSdkPlatform();
    MetricSdkPlatform.instance = fakePlatform;

    expect(await metricSdkPlugin.getPlatformVersion(), '42');
  });*/
}
