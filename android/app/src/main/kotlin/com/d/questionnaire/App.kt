package com.d.questionnaire

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class App: FlutterApplication() {
    override fun attachBaseContext(newBase: Context?) {
        super.attachBaseContext(newBase)

        //fixing multidex for api < 19
        MultiDex.install(this)
    }
}