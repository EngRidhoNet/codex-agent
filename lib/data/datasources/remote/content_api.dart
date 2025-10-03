/// Handles retrieval of content packs from remote or local asset sources.
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Thin abstraction around `dio` for optional remote content distribution.
class ContentApi {
  /// Creates an instance with an optional [client].
  ContentApi({Dio? client}) : _client = client ?? Dio();

  final Dio _client;

  /// Loads a JSON manifest from bundled assets.
  Future<Map<String, dynamic>> loadAssetJson(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Fetches remote JSON from [url].
  Future<Map<String, dynamic>> fetchRemoteJson(String url) async {
    final response = await _client.get(url);
    return response.data as Map<String, dynamic>;
  }
}
