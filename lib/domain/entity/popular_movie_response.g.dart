// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularMovieResponse _$PopularMovieResponseFromJson(
  Map<String, dynamic> json,
) => PopularMovieResponse(
  page: (json['page'] as num).toInt(),
  movies:
      (json['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalResults: (json['total_results'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$PopularMovieResponseToJson(
  PopularMovieResponse instance,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.movies.map((e) => e.toJson()).toList(),
  'total_results': instance.totalResults,
  'total_pages': instance.totalPages,
};
