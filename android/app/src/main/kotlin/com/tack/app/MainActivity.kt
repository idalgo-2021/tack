package com.tack.app

import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "tack/keyboard"
        ).setMethodCallHandler { call, result ->
            if (call.method == "configureTabletKeyboard") {
                configureAllEditTexts()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun configureAllEditTexts() {
        val content = window.decorView.findViewById<View>(android.R.id.content) ?: return
        configureRecursive(content)
    }

    private fun configureRecursive(view: View) {
        if (view is android.widget.EditText) {
            view.imeOptions = view.imeOptions or EditorInfo.IME_FLAG_NO_EXTRACT_UI
            return
        }
        if (view is ViewGroup) {
            for (i in 0 until view.childCount) {
                configureRecursive(view.getChildAt(i))
            }
        }
    }
}
