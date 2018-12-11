
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/podcasts/podcast.dart';

mixin PodcastModel on Model {
  List<Podcast> podcasts = [
    Podcast(author: 'Daniel Korth', name: 'Finanzrocker'),
    Podcast(author: 'Seth Rogan', name: 'Smart Passive Incode', imageUrl: 'https://cdn.smartpassiveincome.com/wp-content/themes/rocket/img/podcast-tile-spi@2x.jpg'),
  ];

  List<Podcast> searchResults = [];
}