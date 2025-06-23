import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];

  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';
  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  String? _searchQuery;
  Timer? _searchDeboubce;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
    await _loadNextPage();
  }

  Future<PopularMovieResponse> _loadMovies(int page, String locale) async {
    final query = _searchQuery;
    if (query == null) {
      return await _apiClient.popularMovie(page, locale);
    } else {
      return await _apiClient.searchMovie(page, locale, query);
    }
  }

  Future<void> searchMovie(String text) async {
    _searchDeboubce?.cancel();
    _searchDeboubce = Timer(const Duration(seconds: 1), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await _resetList();
    });
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final moviesResponse = await _loadMovies(nextPage, _locale);
      _currentPage = moviesResponse.page;
      _totalPage = moviesResponse.totalPages;
      _movies.addAll(moviesResponse.movies);
      _isLoadingInProgress = false;
      notifyListeners();
    } on Exception catch (_) {
      _isLoadingInProgress = false;
    }
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(
      context,
    ).pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  void showMoviedAtIndex(int index) {
    if (index < _movies.length) return;
    _loadNextPage();
  }
}
