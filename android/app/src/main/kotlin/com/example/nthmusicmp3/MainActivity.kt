package com.example.nthmusicmp3

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugins.GeneratedPluginRegistrant
import com.spotify.android.appremote.api.ConnectionParams
import com.spotify.android.appremote.api.Connector
import com.spotify.android.appremote.api.SpotifyAppRemote
import android.content.Intent
import android.net.Uri

class MainActivity: FlutterActivity() {
    private var spotifyAppRemote: SpotifyAppRemote? = null
    private val clientId = "24dfc57421d5444ab08ca1c434f30935"
    private val redirectUri = "com.example.nthmusicmp3://callback"
    private val CHANNEL = "com.example.nthmusicmp3/spotify"
    private var pendingResult: MethodChannel.Result? = null
    private val scope = "streaming app-remote-control user-read-playback-state user-modify-playback-state user-read-currently-playing user-read-lyrics"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isSpotifyConnected" -> isSpotifyConnected(result)
                "connectSpotify" -> connectSpotify(result)
                "playTrack" -> playTrack(call, result)
                "pauseTrack" -> pauseTrack(result)
                "resumeTrack" -> resumeTrack(result)
                "seekToPosition" -> seekToPosition(call, result)
                "getPlaybackPosition" -> getPlaybackPosition(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun connectSpotify(result: MethodChannel.Result) {
        val connectionParams = ConnectionParams.Builder(clientId)
            .setRedirectUri(redirectUri)
            .showAuthView(true)
            .build()

        SpotifyAppRemote.connect(this, connectionParams, object : Connector.ConnectionListener {
            override fun onConnected(appRemote: SpotifyAppRemote) {
                spotifyAppRemote = appRemote
                println("Connected successfully!")
                result.success(true)
            }

            override fun onFailure(error: Throwable) {
                println("Connection failed: ${error.message}")
                result.error("CONNECTION_ERROR", error.message, null)
            }
        })
    }

    private fun playTrack(call: MethodCall, result: MethodChannel.Result) {
        try {
            val trackUri = call.argument<String>("uri") ?: ""
            println("Playing track with URI: $trackUri")
            
            if (spotifyAppRemote?.isConnected != true) {
                println("Spotify not connected, attempting to connect...")
                connectSpotify(result)
                return
            }
            
            spotifyAppRemote?.playerApi?.play(trackUri)?.setResultCallback {
                println("Track played successfully")
                result.success(true)
            }?.setErrorCallback { throwable ->
                println("Error playing track: ${throwable.message}")
                result.error("PLAY_ERROR", throwable.message, null)
            }
        } catch (e: Exception) {
            println("Exception in playTrack: ${e.message}")
            result.error("PLAY_ERROR", e.message, null)
        }
    }

    private fun pauseTrack(result: MethodChannel.Result) {
        try {
            spotifyAppRemote?.playerApi?.pause()?.setResultCallback {
                result.success(true)
            }?.setErrorCallback { throwable ->
                result.error("PAUSE_ERROR", throwable.message, null)
            }
        } catch (e: Exception) {
            result.error("PAUSE_ERROR", e.message, null)
        }
    }

    private fun seekToPosition(call: MethodCall, result: MethodChannel.Result) {
        try {
            val positionMs = call.argument<Int>("positionMs") ?: 0
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                spotifyAppRemote?.playerApi?.seekTo(positionMs.toLong())
                    ?.setResultCallback {
                        result.success(true)
                    }?.setErrorCallback { throwable ->
                        result.error("SEEK_ERROR", throwable.message, null)
                    }
            }, 100)
        } catch (e: Exception) {
            result.error("SEEK_ERROR", e.message, null)
        }
    }

    private fun resumeTrack(result: MethodChannel.Result) {
        try {
            spotifyAppRemote?.playerApi?.resume()?.setResultCallback {
                result.success(true)
            }?.setErrorCallback { throwable ->
                result.error("RESUME_ERROR", throwable.message, null)
            }
        } catch (e: Exception) {
            result.error("RESUME_ERROR", e.message, null)
        }
    }

    private fun isSpotifyConnected(result: MethodChannel.Result) {
        result.success(spotifyAppRemote?.isConnected == true)
    }

    private fun getPlaybackPosition(result: MethodChannel.Result) {
        if (spotifyAppRemote?.isConnected != true) {
            println("Spotify not connected in getPlaybackPosition")
            result.error("NOT_CONNECTED", "Spotify is not connected", null)
            return
        }
        
        try {
            println("Getting playback position...")
            spotifyAppRemote?.playerApi?.playerState?.setResultCallback { playerState ->
                println("Playback position: ${playerState.playbackPosition}")
                result.success(playerState.playbackPosition.toInt())
            }?.setErrorCallback { throwable ->
                println("Error getting playback position: ${throwable.message}")
                result.error("PLAYBACK_ERROR", throwable.message, null)
            } ?: run {
                println("PlayerApi is null")
                result.error("PLAYER_API_NULL", "PlayerApi is null", null)
            }
        } catch (e: Exception) {
            println("Exception in getPlaybackPosition: ${e.message}")
            result.error("PLAYBACK_ERROR", e.message, null)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val uri = intent.data
        if (uri != null && uri.toString().startsWith(redirectUri)) {
            val code = uri.getQueryParameter("code")
            if (code != null) {
                val connectionParams = ConnectionParams.Builder(clientId)
                    .setRedirectUri(redirectUri)
                    .showAuthView(false)
                    .build()
                SpotifyAppRemote.connect(this, connectionParams, object : Connector.ConnectionListener {
                    override fun onConnected(appRemote: SpotifyAppRemote) {
                        spotifyAppRemote = appRemote
                        println("Reconnected successfully!")
                        pendingResult?.success(true)
                        pendingResult = null
                    }

                    override fun onFailure(throwable: Throwable) {
                        println("Reconnection failed: ${throwable.message}")
                        pendingResult?.error("SPOTIFY_CONNECT_ERROR", throwable.message, null)
                        pendingResult = null
                    }
                })
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        SpotifyAppRemote.disconnect(spotifyAppRemote)
    }
}
