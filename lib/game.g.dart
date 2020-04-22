// GENERATED CODE _ DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) {
  return Game(
    id: json['id'] as int,
    slug: json['slug'] as String,
    name: json['name'] as String,
    nameOriginal: json['name_original'] as String,
    description: json['description'] as String,
    metacritic: json['metacritic'] as int,
    released: json['released'] == null
        ? null
        : DateTime.parse(json['released'] as String),
    tba: json['tba'] as bool,
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    backgroundImage: json['background_image'] as String,
    backgroundImageAdditional: json['background_image_additional'] as String,
    website: json['website'] as String,
    screenshotsCount: json['screenshots_count'] as int,
    moviesCount: json['movies_count'] as int,
    creatorsCount: json['creators_count'] as int,
    achievementsCount: json['achievements_count'] as int,
    redditUrl: json['reddit_url'] as String,
    alternativeNames:
        (json['alternative_names'] as List)?.map((e) => e as String)?.toList(),
    metacriticUrl: json['metacritic_url'] as String,
  );
}

TrailerData _$TrailerDataFromJson(Map<String, dynamic> json) {
  return TrailerData(
    json['name'] as String,
    json['preview'] as String,
    TrailerData.func(json['data'] as Map<String, dynamic>),
  );
}
