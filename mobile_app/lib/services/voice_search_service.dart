import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

/// Voice search service using speech-to-text
class VoiceSearchService {
  static final VoiceSearchService _instance = VoiceSearchService._internal();
  factory VoiceSearchService() => _instance;
  VoiceSearchService._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get speechEnabled => _speechEnabled;

  /// Initialize the speech-to-text service
  Future<bool> initialize() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) => debugPrint('Speech status: $status'),
        onError: (error) => debugPrint('Speech error: $error'),
      );
      return _speechEnabled;
    } catch (e) {
      debugPrint('Failed to initialize speech: $e');
      return false;
    }
  }

  /// Start listening for voice input
  Future<void> startListening({
    required Function(String text) onResult,
    Function(String finalText)? onFinalResult,
    String localeId = 'en_US',
  }) async {
    if (!_speechEnabled) {
      final initialized = await initialize();
      if (!initialized) {
        debugPrint('Speech recognition not available');
        return;
      }
    }

    _isListening = true;

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords);

        if (result.finalResult && onFinalResult != null) {
          onFinalResult(result.recognizedWords);
          _isListening = false;
        }
      },
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.search,
        cancelOnError: true,
        partialResults: true,
      ),
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    _isListening = false;
    await _speechToText.stop();
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    _isListening = false;
    await _speechToText.cancel();
  }
}
