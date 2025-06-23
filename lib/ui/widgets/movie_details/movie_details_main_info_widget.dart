import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/library/widgets/inherited/provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_main_screen_cast_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      const _TopPosterWidget(),
      const Padding(
        padding: const EdgeInsets.all(10.0),
        child: _MovieTitleWidget(),
      ),
      _ScoreWidget(precent: 12),
      const Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: _SummaryWidget(),
      ),
      const _Tagline(),
      const Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          textAlign: TextAlign.start,
          "Overview",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const _Overview(),
      const _Peoples(),
      const SizedBox(height: 20),
      const MovieDetailsMainScreenCastWidget(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _Peoples extends StatelessWidget {
  const _Peoples({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);

    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    if (crew.length < 4) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crew[0].originalName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    crew[0].job,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crew[2].originalName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    crew[2].job,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 70),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crew[1].originalName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    crew[1].job,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crew[3].originalName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    crew[3].job,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final overview = model?.movieDetails?.overview ?? '';
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        overview,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final tagline = model?.movieDetails?.tagline;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        tagline ?? '',
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  final int precent;

  _ScoreWidget({required this.precent});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return SizedBox.shrink();
    final voteAverage = model.movieDetails?.voteAverage ?? 0;
    final voteAveragePercent = (voteAverage / 10 * 100).round();
    final videos = model.movieDetails?.videos.results.where(
      (video) => video.type == 'Trailer' && video.site == 'YouTube',
    );
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Text(
              "$voteAveragePercent % ",
              style: TextStyle(
                color:
                    precent >= 0 && precent < 50
                        ? Colors.red
                        : (precent >= 50 && precent < 75
                            ? Colors.orange
                            : Colors.green),
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "User Score",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
            ),
          ],
        ),
        Container(width: 1, height: 15, color: Colors.grey),
        if (trailerKey != null)
          TextButton(
            onPressed:
                () => Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.movieDetailsTrailer,
                  arguments: trailerKey,
                ),
            child: Text(
              "Play trailer",
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          )
        else
          SizedBox.shrink(),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget();

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDuration = model?.movieDetails?.runtime;
    final movieGenres = model?.movieDetails?.genres
        .map((genre) => genre.name)
        .toList()
        .join(',');
    final releaseDate = model?.stringFromDate(model.movieDetails?.releaseDate);
    final productionCountries = model?.movieDetails?.productionCountries
        .map((country) => country.iso)
        .toList()
        .join(',');
    return RichText(
      textAlign: TextAlign.center,
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: "M",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: releaseDate != null ? ' $releaseDate' : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: productionCountries != null ? ' ($productionCountries)' : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: " ⦿ ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text:
                movieDuration != null
                    ? '${(movieDuration / 60).toInt()}h ${movieDuration % 60}m'
                    : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: movieGenres != null ? ' $movieGenres' : '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieTitleWidget extends StatelessWidget {
  const _MovieTitleWidget();

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final title = model?.movieDetails?.title ?? '';
    final releaseYear = model?.movieDetails?.releaseDate?.year.toString();
    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            TextSpan(
              text: releaseYear != null ? ' ($releaseYear)' : '',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget();

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image.network(ApiClient.imageUrl(backdropPath))
          else
            const SizedBox.shrink(),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child:
                posterPath != null
                    ? Image.network(ApiClient.imageUrl(posterPath))
                    : const SizedBox.shrink(),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () {
                model?.toggleFavorite();
              },
              icon: Icon(
                model?.isFavorite == true
                    ? Icons.favorite
                    : Icons.favorite_outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
