// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) {
  return Game(
    id: json['id'] as int,
    slug: json['slug'] as String,
    name: json['name'] as String,
    nameOriginal: json['nameOriginal'] as String,
    description: json['description'] as String,
    metacritic: json['metacritic'] as int,
    released: json['released'] == null
        ? null
        : DateTime.parse(json['released'] as String),
    tba: json['tba'] as bool,
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    backgroundImage: json['backgroundImage'] as String,
    backgroundImageAdditional: json['backgroundImageAdditional'] as String,
    website: json['website'] as String,
    screenshotsCount: json['screenshotsCount'] as int,
    moviesCount: json['moviesCount'] as int,
    creatorsCount: json['creatorsCount'] as int,
    achievementsCount: json['achievementsCount'] as int,
    redditUrl: json['redditUrl'] as String,
    alternativeNames:
        (json['alternativeNames'] as List)?.map((e) => e as String)?.toList(),
    metacriticUrl: json['metacriticUrl'] as String,
  );
}

TrailerData _$TrailerDataFromJson(Map<String, dynamic> json) {
  return TrailerData(
    json['name'] as String,
    json['preview'] as String,
    TrailerData.func(json['data'] as Map<String, dynamic>),
  );
}
