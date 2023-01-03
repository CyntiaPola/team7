package com.example.smart_waage

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.plugins.RxJavaPlugins;

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        RxJavaPlugins.setErrorHandler { e -> } //Wichtig für fehlgeleitete Bluetootherrors
    }
}