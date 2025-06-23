import 'dart:convert';
import 'dart:io';

import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';

enum ApiClientExeptionType { Network, Auth, Other }

class ApiClientExeption implements Exception {
  final ApiClientExeptionType type;

  ApiClientExeption(this.type);
}

class ApiClient {
  final _client = HttpClient();
  static const _host = "https://api.themoviedb.org/3";
  static const _apiKey = "d319ce7d1ae50772dfeca0be481816c8";
  static const _imageUrl = "https://image.tmdb.org/t/p/w500";

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth({
    required String username,
    required String password,
  }) async {
    final token = await _makeToken();
    final validatedToken = await _validateUser(
      login: username,
      password: password,
      requestToken: token,
    );
    final sessionId = await _makeSession(requestToken: validatedToken);
    return sessionId;
  }

  Uri _makeUri(String path, Map<String, dynamic>? params) {
    final uri = Uri.parse("$_host$path");
    if (params != null) {
      return uri.replace(queryParameters: params);
    } else {
      return uri;
    }
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        throw ApiClientExeption(ApiClientExeptionType.Auth);
      } else {
        throw ApiClientExeption(ApiClientExeptionType.Other);
      }
    }
  }

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? params,
  ]) async {
    final url = _makeUri(path, params);

    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = await response.jsonDecode();

      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.Network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
  }

  Future<T> _post<T>(
    String path,
    T Function(dynamic json) parser,
    Map<String, dynamic>? bodyParams, [
    Map<String, dynamic>? queryParams,
  ]) async {
    try {
      final url = _makeUri(path, queryParams);
      final request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParams));
      final response = await request.close();
      final dynamic json = await response.jsonDecode();
      _validateResponse(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiClientExeption(ApiClientExeptionType.Network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(ApiClientExeptionType.Other);
    }
  }

  Future<String> _makeToken() {
    final String _path = "/authentication/token/new";
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _get(_path, parser, <String, dynamic>{'api_key': _apiKey});
    return result;
  }

  Future<PopularMovieResponse> popularMovie(int page, String locale) async {
    final String _path = "/movie/popular";
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = PopularMovieResponse.fromJson(jsonMap);
      return result;
    }

    final result = _get<PopularMovieResponse>(_path, parser, <String, dynamic>{
      'api_key': _apiKey,
      'language': locale,
      'page': page,
    });
    return result;
  }

  Future<MovieDetails> movieDetails(int movieId, String locale) async {
    final String _path = "/movie/$movieId";
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = MovieDetails.fromJson(jsonMap);
      return result;
    }

    final result = _get<MovieDetails>(_path, parser, <String, dynamic>{
      'api_key': _apiKey,
      'language': locale,
      'append_to_response': 'credits',
    });
    return result;
  }

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async {
    final String _path = "/search/movie";
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = PopularMovieResponse.fromJson(jsonMap);
      return result;
    }

    final result = _get<PopularMovieResponse>(_path, parser, <String, dynamic>{
      'api_key': _apiKey,
      'language': locale,
      'page': page,
      'query': query,
      'include_adult': true.toString(),
    });
    return result;
  }

  Future<String> _validateUser({
    required String login,
    required String password,
    required String requestToken,
  }) {
    final _path = "/authentication/token/validate_with_login";
    final _bodyParams = <String, dynamic>{
      'username': login,
      'password': password,
      'request_token': requestToken,
    };
    final _queryParams = <String, dynamic>{'api_key': _apiKey};

    String _parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result = _post(_path, _parser, _bodyParams, _queryParams);
    return result;
  }

  Future<String> _makeSession({required String requestToken}) {
    final _path = "/authentication/session/new";
    final _bodyParams = <String, dynamic>{'request_token': requestToken};
    final _queryParams = <String, dynamic>{'api_key': _apiKey};

    String _parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final sessionId = jsonMap['session_id'] as String;
      return sessionId;
    }

    final result = _post(_path, _parser, _bodyParams, _queryParams);
    return result;
  }
}

extension HttpClientResponseJsonDecoder on HttpClientResponse {
  Future<dynamic> jsonDecode() {
    return transform(
      utf8.decoder,
    ).toList().then((v) => v.join()).then<dynamic>((v) => json.decode(v));
  }
}
