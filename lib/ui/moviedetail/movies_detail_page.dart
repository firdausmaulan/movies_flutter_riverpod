import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_flutter_riverpod/ui/moviedetail/movie_detail_controller.dart';
import 'package:movies_flutter_riverpod/util/constant.dart';

class MovieDetailPage extends ConsumerWidget {
  final int? movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the list of movies from the provider
    final movie = ref.watch(movieDetailProvider);
    // Access the controller to call methods like getMovieDetail
    final movieDetailController = ref.read(movieDetailProvider.notifier);
    if (movieDetailController.isInitialized) {
      movieDetailController.isInitialized = false;
      movieDetailController.getMovieDetail(movieId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Detail"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            height: 240,
            fit: BoxFit.cover,
            imageUrl: "${Constant.imageUrl}${movie.backdropPath}",
            placeholder: (context, url) => const Center(
                child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            )),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text("Title",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(movie.title.toString()),
                const SizedBox(height: 8),
                const Text("Overview",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(movie.overview.toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
