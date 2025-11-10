import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAdManager {
  // Constants
  static const int _walletAdType = 4;
  static const int _cooldownDuration = 2; 
  static const int _coinsReward = 5;
  static const String _adUnitId = 'ca-app-pub-8328099920408589/5627342176';

  // Ad watching variables
  InterstitialAd? _interstitialAd;
  Timer? _timer;
  final ValueNotifier<int> timeLeft = ValueNotifier<int>(0);

  // Callbacks
  final VoidCallback onAdRewardGranted;
  final Function(String) onError;

  ProfileAdManager({
    required this.onAdRewardGranted,
    required this.onError,
  });

  // Getters
  int get coinsReward => _coinsReward;
  bool get isAdReady => _interstitialAd != null;
  bool get isOnCooldown => timeLeft.value > 0;

  /// Initialize ad timer and load first ad
  Future<void> initialize() async {
    await _initAdTimer();
    _loadInterstitialAd();
  }

  /// Dispose of resources
  void dispose() {
    _interstitialAd?.dispose();
    _timer?.cancel();
    timeLeft.dispose();
  }

  /// Initialize the ad timer based on stored timestamp
  Future<void> _initAdTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timestamp = prefs.getInt('wallet_timestamp$_walletAdType');

    if (timestamp != null) {
      final elapsedSeconds = (currentTime - timestamp) ~/ 1000;
      if (elapsedSeconds < _cooldownDuration) {
        timeLeft.value = _cooldownDuration - elapsedSeconds;
        _startAdTimer(timestamp);
      } else {
        await prefs.remove('wallet_timestamp$_walletAdType');
      }
    }
  }

  /// Start the cooldown timer
  void _startAdTimer(int startTime) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final storedTimestamp = prefs.getInt('wallet_timestamp$_walletAdType');

      // If timestamp changed externally, cancel this timer
      if (storedTimestamp != startTime) {
        timer.cancel();
        timeLeft.value = 0;
        return;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final elapsedSeconds = (currentTime - storedTimestamp!) ~/ 1000;
      final remainingTime = _cooldownDuration - elapsedSeconds;

      if (remainingTime <= 0) {
        timer.cancel();
        await prefs.remove('wallet_timestamp$_walletAdType');
        timeLeft.value = 0;
        _loadInterstitialAd();
      } else {
        timeLeft.value = remainingTime;
      }
    });
  }

  /// Load the interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(), 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          log('Wallet InterstitialAd loaded for adType $_walletAdType.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          log('Wallet InterstitialAd failed to load: $error');
          _interstitialAd?.dispose();
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Handle watch ad button click
  Future<void> onWatchAdButtonClicked() async {
    if (timeLeft.value > 0) {
      onError("Ad is on cooldown. Please wait ${timeLeft.value} seconds.");
      return;
    }

    if (_interstitialAd == null) {
      log('Wallet InterstitialAd not loaded. Attempting to load...');
      _loadInterstitialAd();
      onError("Ad not ready yet. Please try again in a moment.");
      return;
    }

    // Show the ad
    _interstitialAd?.show();
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        log('Wallet Ad dismissed for adType $_walletAdType.');
        ad.dispose();

        // Start cooldown timer
        final prefs = await SharedPreferences.getInstance();
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('wallet_timestamp$_walletAdType', currentTime);

        timeLeft.value = _cooldownDuration;
        _startAdTimer(currentTime);

        // Grant reward
        onAdRewardGranted();

        _interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log('Wallet Ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        onError("Failed to show ad. Please try again.");
      },
      onAdImpression: (ad) => log('Wallet Ad impression recorded.'),
      onAdShowedFullScreenContent: (ad) => log('Wallet Ad showed full screen content.'),
      onAdWillDismissFullScreenContent: (ad) => log('Wallet Ad will dismiss full screen content.'),
    );
  }

  /// Get formatted cooldown time
  String getCooldownText() {
    if (timeLeft.value <= 0) return "Watch Ad";
    final minutes = timeLeft.value ~/ 60;
    final seconds = timeLeft.value % 60;
    return minutes > 0 
        ? "${minutes}m ${seconds}s" 
        : "${seconds}s";
  }
}

