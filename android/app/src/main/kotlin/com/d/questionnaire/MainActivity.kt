package com.d.questionnaire

import android.content.Context
import android.os.Build
import android.os.Bundle
import androidx.multidex.MultiDex

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {

    //fixing #8610
    if (Build.VERSION.SDK_INT < 18) {
      intent.putExtra("enable-software-rendering", true)
    }

    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
