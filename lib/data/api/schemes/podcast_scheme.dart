class PodcastScheme {
  String title;
  String subtitle;
  int podcastId;
  String imageUrl;
  String thumbUrl;
  List<int> categories;
  DateTime lastPub;
  String description;
  int episodeCount;
  String language;

  PodcastScheme.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    podcastId = map['id'];
    imageUrl = map['imgURL'];
    thumbUrl = map['thumbImageURL'];
    language = map['language'];
    categories = List.from(map['categories']);
    lastPub = DateTime.parse(map['lastpub']);
    description = map['description'];
    subtitle = map['subtitle'];
    episodeCount = int.tryParse(map['episode_count']);
  }
}