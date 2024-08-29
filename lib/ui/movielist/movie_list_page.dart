import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_flutter_riverpod/ui/common/search/search_field.dart';
import 'package:movies_flutter_riverpod/ui/movielist/widget/movie_card.dart';
import 'package:movies_flutter_riverpod/util/constant.dart';

import 'movie_list_controller.dart';

class MovieListPage extends ConsumerWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the list of movies from the provider
    final movies = ref.watch(movieListProvider);
    // Access the controller to call methods like searchMovies
    final movieListController = ref.read(movieListProvider.notifier);

    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (movies.isNotEmpty) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          movieListController.loadMore();
        }
      }
    });

    if (movieListController.isInitialize) {
      movieListController.isInitialize = false;
      Future.delayed(const Duration(seconds: 1), () {
        movieListController.searchMovies(Constant.defaultQuery);
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Movie List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SearchField(
                hintText: "Search Movie",
                onSearch: (query) => {movieListController.searchMovies(query)},
              ),
              Expanded(
                child: movies.isEmpty
                    ? const Text('No movies found')
                    : ListView.builder(
                        itemCount: movies.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          final movieItem = movies[index];
                          return MovieCard(
                            movieItem: movieItem,
                          );
                        },
                      ),
              )
            ],
          ),
        ));
  }
}
