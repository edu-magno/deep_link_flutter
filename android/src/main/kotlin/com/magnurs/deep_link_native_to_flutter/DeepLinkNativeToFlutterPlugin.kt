package com.magnurs.deep_link_native_to_flutter

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.BroadcastReceiver
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*


/** DeepLinkNativeToFlutterPlugin */
class DeepLinkNativeToFlutterPlugin: FlutterPlugin, MethodCallHandler, PluginRegistry.NewIntentListener, ActivityAware
   {

  private lateinit var context: Context
  private lateinit var channel : MethodChannel
  private lateinit var event : EventChannel
  private val channelName = "https.magnurs.deep.link.com/channel"
  private val eventName = "https.magnurs.deep.link.com/event"
  private var initialDeepLink: String? = null
  private var latestDeepLink: String? = null
  private var initialIntent: Boolean = true
  private var deepLinksReceiver: BroadcastReceiver? = null


  private fun handleIntent(context: Context , intent : Intent){

    val action: String? = intent.action
    val dataString : String? =  intent.dataString

    if (Intent.ACTION_VIEW == action) {
      if (initialIntent) {
        initialDeepLink =  dataString
        initialIntent = false
      }
      latestDeepLink =  dataString
      if (deepLinksReceiver != null) {
        deepLinksReceiver?.onReceive(context, intent)
    }
  }
  }

  private fun createDeepLinksReceiver(events: EventSink): BroadcastReceiver {
     return object : BroadcastReceiver() {
      override fun onReceive(context: Context, intent: Intent) {
        val dataString: String? = intent.dataString

        if (dataString == null) {
          events.error("Unavailable", "Link unavailable", null)
        }else {
          events.success(dataString)
        }
      }
    }
  }

   private fun register(messenger: BinaryMessenger, plugin: DeepLinkNativeToFlutterPlugin) {
     channel = MethodChannel(messenger, channelName)
     channel.setMethodCallHandler(object : MethodCallHandler{
       override fun onMethodCall(call: MethodCall, result: Result) {
         if (call.method == "deepLink") {
           if (initialIntent) {
             result .success(initialDeepLink)
             return
           }
           result.success(latestDeepLink)
         }else {
           result.error("Error","Error, cannot find deeplink", {})
         }
       }

     })
     event = EventChannel(messenger, eventName)
     event.setStreamHandler(object : EventChannel.StreamHandler {
       override fun onListen(arguments: Any?, events: EventSink) {
         deepLinksReceiver =  createDeepLinksReceiver(events)
       }

       override fun onCancel(arguments: Any?) {
          deepLinksReceiver = null
       }

     })
   }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    this.context = binding.applicationContext
    register(binding.binaryMessenger, this)
  }



  override fun onNewIntent(intent: Intent): Boolean {
    this.handleIntent(context, intent)
    return false
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    event.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    this.handleIntent(this.context, binding.activity.intent)
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    this.handleIntent(this.context, binding.activity.intent)
  }

  override fun onDetachedFromActivity() {}
}
