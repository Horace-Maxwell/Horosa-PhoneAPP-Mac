package com.horosa.wwwcom.horosa.www

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import org.devio.flutter.splashscreen.SplashScreen

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // SplashScreen.show(this)
        // or enable full screen
        SplashScreen.show(this, true)
        super.onCreate(savedInstanceState)
    }
}
