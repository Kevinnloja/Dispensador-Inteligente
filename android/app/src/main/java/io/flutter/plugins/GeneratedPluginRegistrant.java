package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new com.ryanheise.audio_session.AudioSessionPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin audio_session, com.ryanheise.audio_session.AudioSessionPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new xyz.luan.audioplayers.AudioplayersPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin audioplayers_android, xyz.luan.audioplayers.AudioplayersPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin cloud_firestore, io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin firebase_auth, io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin firebase_core, io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.database.FirebaseDatabasePlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin firebase_database, io.flutter.plugins.firebase.database.FirebaseDatabasePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin firebase_messaging, io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin flutter_local_notifications, com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.ryanheise.just_audio.JustAudioPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin just_audio, com.ryanheise.just_audio.JustAudioPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin path_provider_android, io.flutter.plugins.pathprovider.PathProviderPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.llfbandit.record.RecordPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin record, com.llfbandit.record.RecordPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin shared_preferences_android, io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.videoplayer.VideoPlayerPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin video_player_android, io.flutter.plugins.videoplayer.VideoPlayerPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.webviewflutter.WebViewFlutterPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin webview_flutter_android, io.flutter.plugins.webviewflutter.WebViewFlutterPlugin", e);
    }
  }
}
