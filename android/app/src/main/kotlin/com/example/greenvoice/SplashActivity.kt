package com.greenvoice.app

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity


class SplashActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.splash_screen)

        // Delay to match the GIF animation duration
       Handler(Looper.getMainLooper())
        .postDelayed(
                {
                    startActivity(FlutterActivity.createDefaultIntent(this))
                    finish()
                },
                3500  // Adjust this delay accordingly
        )
    }
}
