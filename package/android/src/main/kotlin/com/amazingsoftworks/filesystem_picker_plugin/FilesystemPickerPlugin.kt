package com.amazingsoftworks.filesystem_picker_plugin

import android.content.Context
import android.os.Build
import android.os.Environment
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FilesystemPickerPlugin */
class FilesystemPickerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "filesystem_picker/android_native")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${Build.VERSION.RELEASE}")
    } else if (call.method == "isExternalStorageManager") {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        result.success(Environment.isExternalStorageManager())
      } else {
        result.success(true)
      }
    } else if (call.method == "getExtStorageData") {
      val reply = StorageUtils.getExternalStorageAvailableData(context)
      result.success(reply)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
