import 'package:movies_flutter_riverpod/data/remote/network_api.dart';
import 'package:movies_flutter_riverpod/data/remote/request/movies_request.dart';
import 'package:movies_flutter_riverpod/data/remote/response/genres_response.dart';
import 'package:movies_flutter_riverpod/data/remote/response/movie_response.dart';
import 'package:movies_flutter_riverpod/data/remote/response/movies_response.dart';
import 'package:movies_flutter_riverpod/util/constant.dart';

class ServiceApi {
  final _networkHttp = NetworkApi();

  Future<GenresResponse> getGenres() async {
    var result = await _networkHttp.get(Constant.pathGenre, {});
    return GenresResponse.fromJson(result);
  }

  Future<MoviesResponse> getMovies(MoviesRequest request) async {
    var result = await _networkHttp.get(Constant.pathMovieList, request.toJson());
    return MoviesResponse.fromJson(result);
  }

  Future<MovieResponse> getMovieDetail(int? movieId) async {
    var result = await _networkHttp.get(Constant.pathMovieDetail + movieId.toString(), {});
    return MovieResponse.fromJson(result);
  }
}
