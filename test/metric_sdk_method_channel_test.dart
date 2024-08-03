import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metric_sdk/metric_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMetricSdk platform = MethodChannelMetricSdk();
  const MethodChannel channel = MethodChannel('metric_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  /*test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });*/
}
