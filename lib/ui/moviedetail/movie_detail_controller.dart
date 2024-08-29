import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_flutter_riverpod/data/mapper/movie_mapper.dart';
import 'package:movies_flutter_riverpod/data/remote/service_api.dart';
import 'package:movies_flutter_riverpod/ui/moviedetail/model/movie_detail.dart';

class MovieDetailController extends StateNotifier<MovieDetail> {
  MovieDetailController(super.state);

  bool isInitialized = true;

  void getMovieDetail(int? movieId) async {
    try {
      final movieResponse = await ServiceApi().getMovieDetail(movieId);
      // Update the state here
      state = MovieMapper().toMovieDetail(movieResponse);
    } catch (e) {
      // Handle error
      debugPrint("error ${e.toString()}");
    }
  }
}

// Define a provider for MovieDetailController
final movieDetailProvider =
    StateNotifierProvider.autoDispose<MovieDetailController, MovieDetail>((ref) {
  return MovieDetailController(MovieDetail());
});
