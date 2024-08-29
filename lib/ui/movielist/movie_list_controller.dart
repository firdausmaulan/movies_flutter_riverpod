import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_flutter_riverpod/data/mapper/movie_mapper.dart';
import 'package:movies_flutter_riverpod/data/remote/request/movies_request.dart';
import 'package:movies_flutter_riverpod/data/remote/response/genres_response.dart';
import 'package:movies_flutter_riverpod/data/remote/service_api.dart';
import 'package:movies_flutter_riverpod/ui/movielist/model/movie_item.dart';

class MovieListController extends StateNotifier<List<MovieItem>> {
  final MoviesRequest request = MoviesRequest();

  MovieListController() : super([]);
  bool isInitialize = true;
  bool isLoading = false;
  bool isLastPage = false;
  List<Genres> genres = [];

  void searchMovies(String query) async {
    if (isLoading) return;
    isLoading = true;
    isLastPage = false;
    request.query = query;
    request.page = 1;
    try {
      if (genres.isEmpty) {
        final genresResponse = await ServiceApi().getGenres();
        genres = genresResponse.genres ?? [];
      }
      final moviesResponse = await ServiceApi().getMovies(request);
      state = MovieMapper().toMovieList(moviesResponse, genres); // Update the state here
      debugPrint("state length ${state.length}");
    } catch (e) {
      // Handle error
      debugPrint("error ${e.toString()}");
    }
    isLoading = false;
  }

  void loadMore() async {
    if (isLoading || isLastPage) return;
    isLoading = true;
    request.page = (request.page ?? 0) + 1;
    try {
      final moviesResponse = await ServiceApi().getMovies(request);
      final newList = MovieMapper().toMovieList(moviesResponse, genres);
      final newState = [...state, ...newList]; // Combine lists
      state = newState;
      isLastPage = newList.isEmpty;
      debugPrint("state length ${state.length}");
    } catch (e) {
      // Handle error
      debugPrint("error ${e.toString()}");
    }
    isLoading = false;
  }
}

// Define a provider for MovieListController
final movieListProvider =
    StateNotifierProvider<MovieListController, List<MovieItem>>((ref) {
  return MovieListController();
});
