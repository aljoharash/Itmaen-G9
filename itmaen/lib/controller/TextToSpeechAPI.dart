import 'dart:io';

import 'dart:async';

import 'dart:convert' show Base64Decoder, json, utf8;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:path_provider/path_provider.dart';

import '../model/Voice.dart';

// import 'package:flutter_wavenet/voice.dart';

class TextToSpeechAPI {
  static final TextToSpeechAPI _singleton = TextToSpeechAPI._internal();

  final _httpClient = HttpClient();

  static const _apiKey =
      "AIzaSyAiNdHCwWO0vLBwgRFhiQHPuYijnlM4ySQ"; // google text to speech api key

  static const _apiURL = "texttospeech.googleapis.com";

  //language name to send it to the api

  static const _voiceName =
      "ar-XA-Wavenet-D"; //en-US-Wavenet-D / ar-XA-Wavenet-C

  //language code to sent it to the api

  static const _languageCode = "ar-XA"; //en-US / ar-XA

  String isPlaying = "";

  AudioPlayer myplayer = AudioPlayer();

  factory TextToSpeechAPI() {
    return _singleton;
  }

  TextToSpeechAPI._internal();

  //

  Future<dynamic> synthesizeText(String text) async {
    try {
      final uri = Uri.https(_apiURL, '/v1beta1/text:synthesize');

      final Map json = {
        'input': {'text': text},
        'voice': {'name': _voiceName, 'languageCode': _languageCode},
        'audioConfig': {'audioEncoding': 'MP3', "speakingRate": 0.85}
      };

      final jsonResponse = await _postJson(uri, json);

      if (jsonResponse == null) return null;

      final String audioContent = await jsonResponse['audioContent'];

      return audioContent;
    } on Exception catch (e) {
      print("$e");

      return null;
    }
  }

  void AppShowToast(
      {required String text, ToastGravity position = ToastGravity.CENTER}) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.black.withOpacity(0.8),
        gravity: position);
  }

  Future<void> playVoice(
      String medDoc, String text, AudioPlayer audioController) async {
    AudioPlayer audioPlugin = audioController;
    //print(audioPlugin.state);
    //print(AudioPlayer().state);
    if (audioPlugin.state == PlayerState.playing) return;
    /*if (audioPlugin.state == PlayerState.playing) {
      await audioPlugin.stop();
    }*/

// جدبي

// متداخل

    final String audioContent = await synthesizeText(text);

    if (audioContent == null) return;

    final bytes = Base64Decoder().convert(audioContent, 0, audioContent.length);

    if (Platform.isAndroid) {
      final dir = await getTemporaryDirectory();

      final file = File('${dir.path}/${medDoc}.mp3');

      await file.writeAsBytes(bytes);

      UrlSource fileSource = new UrlSource(file.path);

      await audioPlugin.play(fileSource, mode: PlayerMode.mediaPlayer);
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/${medDoc}.mp3');

      await file.writeAsBytes(bytes);

      DeviceFileSource deviceFileSource = new DeviceFileSource(file.path);

      await audioPlugin.play(deviceFileSource);
    }

    // audioPlugin.onPlayerComplete.listen((event) {
    //   isPlaying = "";
    // });
  }

  Future<List<Voice>> getVoices() async {
    try {
      final uri = Uri.https(_apiURL, '/v1beta1/voices');

      final jsonResponse = await _getJson(uri);

      if (jsonResponse == null) {
        List<Voice> voice_list = [];

        return voice_list;
      }

      final List<dynamic> voicesJSON = jsonResponse['voices'].toList();

      if (voicesJSON == null) {
        List<Voice> voice_list = [];

        return voice_list;
      }

      final voices = Voice.mapJSONStringToList(voicesJSON);

      return voices;
    } on Exception catch (e) {
      print("$e");

      List<Voice> voice_list = [];

      return voice_list;
    }
  }

  Future<Map<String, dynamic>> _postJson(Uri uri, Map jsonMap) async {
    try {
      final httpRequest = await _httpClient.postUrl(uri);

      final jsonData = utf8.encode(json.encode(jsonMap));

      final jsonResponse =
          await _processRequestIntoJsonResponse(httpRequest, jsonData);

      return jsonResponse;
    } on Exception catch (e) {
      print("$e");

      Map<String, dynamic> json_Map = {};

      return json_Map;
    }
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);

      final jsonResponse =
          await _processRequestIntoJsonResponse(httpRequest, []);

      return jsonResponse;
    } on Exception catch (e) {
      print(e);

      Map<String, dynamic> json_Map = {};

      return json_Map;
    }
  }

  Future<Map<String, dynamic>> _processRequestIntoJsonResponse(
      HttpClientRequest httpRequest, List<int> data) async {
    try {
      httpRequest.headers.add('X-Goog-Api-Key', _apiKey);

      httpRequest.headers
          .add(HttpHeaders.contentTypeHeader, 'application/json');

      if (data != null) {
        httpRequest.add(data);
      }

      final httpResponse = await httpRequest.close();

      if (httpResponse.statusCode != HttpStatus.OK) {
        throw Exception('Bad Response');
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();

      return json.decode(responseBody);
    } on Exception catch (e) {
      print("$e");

      Map<String, dynamic> json_Map = {};

      return json_Map;
    }
  }
}
