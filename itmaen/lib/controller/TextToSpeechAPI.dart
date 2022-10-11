import 'dart:io';
import 'dart:async';
import 'dart:convert' show json, utf8;
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
      "ar-XA-Wavenet-C"; //en-US-Wavenet-D / ar-XA-Wavenet-C
  //language code to sent it to the api
  static const _languageCode = "ar-XA"; //en-US / ar-XA

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
