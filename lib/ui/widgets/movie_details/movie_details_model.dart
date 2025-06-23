import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final int _movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;
  late DateFormat _dateFormat;
  Future<void>? Function()? onSessiondExpired;
  MovieDetails? get movieDetails => _movieDetails;

  MovieDetailsModel(this._movieId);

  get toggleFavourite => null;

  String stringFromDate(DateTime? date) {
    return date != null ? _dateFormat.format(date) : '';
  }

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);

    await _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      _movieDetails = await _apiClient.movieDetails(_movieId, _locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      if (sessionId != null) {
        _isFavorite = await _apiClient.isFavorite(_movieId, sessionId);
      }
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  Future<void> toggleFavorite() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    if (sessionId == null || accountId == null) return;

    final newIsFavorite = !isFavorite;
    _isFavorite = newIsFavorite;
    notifyListeners();
    try {
      await _apiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.Movie,
        mediaId: _movieId,
        isFavorite: newIsFavorite,
      );
    } on ApiClientException catch (e) {
      _handleApiClientException(e);
    }
  }

  void _handleApiClientException(ApiClientException e) async {
    switch (e.type) {
      case ApiClientExceptionType.SessionExpired:
        await onSessiondExpired?.call();
      default:
        print(e);
    }
  }
}
