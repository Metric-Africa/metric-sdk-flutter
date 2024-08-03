package com.metric.metric_sdk

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import androidx.annotation.NonNull
import com.metric.sdk.init.BasicMetricSettings
import com.metric.sdk.init.ClientAuthenticator
import com.metric.sdk.init.Environment
import com.metric.sdk.init.Metric
import com.metric.sdk.init.ThemeProvider
import com.metric.sdk.theme.AppLogo
import com.metric.sdk.theme.AppTheme
import com.metric.sdk.ui.sdklaucher.Reason
import com.metric.sdk.ui.sdklaucher.VerificationOutcome
import com.metric.sdk.ui.sdklaucher.legacy.MetricSdkContract

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** MetricSdkPlugin */
class MetricSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

  companion object {
    private const val LAUNCH_SDK_REQUEST_CODE = 36
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private lateinit var result: Result

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "metric_sdk")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    this.result = result
    when(call.method) {
      "initializeSdk" -> {
        val appName = call.argument<String>("appName") ?: error("No App name passed")
        val logo = call.argument<String>("logo") ?: error("No logo passed")
        val primaryColor = call.argument<Long>("primaryColor") ?: error("No primary color passed")
        val secretKey = call.argument<String>("secretKey") ?: error("No secret key passed")
        val clientKey = call.argument<String>("clientKey") ?: error("No client key passed")
        val environment = call.argument<String>("environment") ?: error("No logo passed")
        val act = activity ?: error("Activity not found")
        initMetricSdk(
          activity = act,
          appName = appName,
          logo = logo,
          primaryColor = primaryColor.toInt(),
          secretKey = secretKey,
          clientKey = clientKey,
          environment = environment
        )
      }

      "launchSdk" -> {
        val token = call.argument<String>("token")
        if (token.isNullOrBlank()) {
          result.success(Reason.UNKNOWN.name + " no token passed")
          return
        }

        val intent = Metric.createStartIntent(token)
        activity?.startActivityForResult(intent, LAUNCH_SDK_REQUEST_CODE)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == LAUNCH_SDK_REQUEST_CODE) {
      if (resultCode == Activity.RESULT_OK) {
        val outcome = Metric.getResultsFromIntent(data) ?: VerificationOutcome.Failed(Reason.UNKNOWN)
        val res = when (outcome) {
          is VerificationOutcome.Failed -> outcome.reason.name
          is VerificationOutcome.Success -> "SUCCESS"
        }
        result.success(res)
      } else {
        result.success(Reason.UNKNOWN.name)
      }
      return true
    }
    return false
  }

  private fun initMetricSdk(
    activity: Activity,
    appName: String,
    logo: String,
    primaryColor: Int,
    secretKey: String,
    clientKey: String,
    environment: String
  ) {
    Metric.init(
      metricSettings = BasicMetricSettings(
        applicationContext = activity.applicationContext,
        themeProvider = ThemeProvider(
          appTheme = {
            AppTheme(
              appName = appName,
              logo = AppLogo.NetworkImage(logo),
              primaryColor = primaryColor,
            )
          }
        ),
        authenticator = {
          ClientAuthenticator(
            clientKey = clientKey,
            secretKey = secretKey
          )
        },
        environment = if (environment == "prod") Environment.Prod else Environment.Dev,
      )
    )
  }
}
