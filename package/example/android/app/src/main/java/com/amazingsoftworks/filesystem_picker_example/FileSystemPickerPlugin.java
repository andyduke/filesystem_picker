package com.amazingsoftworks.filesystem_picker_example;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static android.os.Environment.isExternalStorageManager;

public class FileSystemPickerPlugin extends FlutterActivity {

  private static final String channel = "filesystem_picker/android_native";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), channel)
            .setMethodCallHandler(
                    (call, result) -> {
                      if (call.method.equals("isExternalStorageManager")) {
                          if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                              result.success(isExternalStorageManager());
                          } else {
                              result.success(true);
                          }
                      } else if (call.method.equals("getExtStorageData")) {
                          ArrayList<HashMap<String, Object>> reply = StorageUtils.getExternalStorageAvailableData(getApplicationContext());
                          result.success(reply);
                      } else {
                        result.notImplemented();
                      }
                    }
            );
  }
}
