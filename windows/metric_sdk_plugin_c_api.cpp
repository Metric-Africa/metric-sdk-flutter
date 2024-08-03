#include "include/metric_sdk/metric_sdk_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "metric_sdk_plugin.h"

void MetricSdkPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  metric_sdk::MetricSdkPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
