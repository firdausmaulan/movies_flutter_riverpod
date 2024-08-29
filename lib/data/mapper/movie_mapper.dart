import 'package:movies_flutter_riverpod/data/remote/response/genres_response.dart';
import 'package:movies_flutter_riverpod/data/remote/response/movies_response.dart';
import 'package:movies_flutter_riverpod/ui/movielist/model/movie_item.dart';

class MovieMapper {
  List<MovieItem> toMovieList(
      MoviesResponse moviesResponse, List<Genres> genres) {
    List<MovieItem> list = [];
    moviesResponse.results?.forEach((element) {
      var movieItem = toMovie(element);
      movieItem.genres = getGenresIds(genres, element.genreIds);
      list.add(movieItem);
    });
    return list;
  }

  MovieItem toMovie(Results results) {
    return MovieItem.fromJson(results.toJson());
  }

  String getGenresIds(List<Genres> genres, List<int>? genreIds) {
    if (genreIds == null || genreIds.isEmpty) {
      return ""; // Handle empty or null genreIds gracefully
    }

    final formattedGenres = genreIds
        .map((id) => genres.firstWhere((genre) => genre.id == id).name ?? "")
        .join(", "); // Use join for efficient concatenation

    return formattedGenres.trimRight(); // Remove trailing comma if present
  }
}
