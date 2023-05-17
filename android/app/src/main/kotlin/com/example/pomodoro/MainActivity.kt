package com.example.pomodoro

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}



//package com.example.pomodoro
//
//import android.annotation.TargetApi
//import android.app.AlarmManager
//import android.app.PendingIntent
//import android.content.*
//import android.os.BatteryManager
//import android.os.Build.VERSION
//import android.os.Build.VERSION_CODES
//import android.util.Log
//import androidx.annotation.NonNull
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import io.flutter.plugins.GeneratedPluginRegistrant
//import java.util.*
//
//
//class MainActivity : FlutterActivity() {
//    private val CHANNEL = "samples.flutter.dev/alarm"
//
//    private lateinit var alarmManager: AlarmManager
//    private lateinit var intentAlarm: Intent
//    private lateinit var pendingIntent: PendingIntent
//
//    private class AlarmReceiver : BroadcastReceiver() {
//        override fun onReceive(
//                context: Context,
//                intent: Intent
//        ) {
//            Log.d("Alarm Bell", "Alarm just fired")
//        }
//    }
//
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        alarmManager = this.context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
//        pendingIntent = Intent(context, AlarmReceiver::class.java).let { intent ->
//            PendingIntent.getBroadcast(context, 0, intent, 0)
//        }
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//            // This method is invoked on the main thread.
//            call, result ->
//            if (call.method == "setAlarm") {
//                val time = (call.arguments) as List<Any>
//                val timeinMillies : Long = time[0] as Long
//                setAlarm(time[0] as Long)
//                alarmManager.setAlarmClock(AlarmManager.AlarmClockInfo(timeinMillies,pendingIntent), pendingIntent )
//                result.success("Alarm is set successfully")
//
//            } else if (call.method == "deleteAlarm") {
//                deleteAlarm()
//                result.success("Alarm is deleted")
//            } else {
//                result.notImplemented()
//            }
//        }
//
//    }
//
//    @TargetApi(VERSION_CODES.LOLLIPOP)
//    private fun setAlarm(timeinMillies: Long) {
//        //alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, timeinMillies, AlarmManager.INTERVAL_DAY, pendingIntent)
//        alarmManager.setAlarmClock(AlarmManager.AlarmClockInfo(timeinMillies,pendingIntent), pendingIntent )
//    }
//
//    private fun deleteAlarm() {
//        alarmManager.cancel(pendingIntent)
//    }
//
//    private fun getBatteryLevel(): Int {
//        val batteryLevel: Int
//        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
//            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
//            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//        } else {
//            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
//            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
//        }
//
//        return batteryLevel
//    }
//
//
//}
//
//
//
//
//
