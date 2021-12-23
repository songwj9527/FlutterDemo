package com.flutter.demoapp.flutter_demo_app

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

internal class MyApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(base)
    }
}