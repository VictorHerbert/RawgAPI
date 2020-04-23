import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class Developer {
	static String source = 'https://api.rawg.io/api/developers';
  final int id;	
  final String name;
  final String slug;
  final int gamesCount;
  final String imageBackground;
  final String description;

  Developer({
		this.id,
		this.name,
		this.slug,
		this.gamesCount,
		this.imageBackground,
		this.description
	});

  Developer fromJson(Map<String, dynamic> json) {
		return Developer(
			id: json['id'],
			name: json['name'],
			slug: json['slug'],
			gamesCount: json['games_count'],
			imageBackground: json['image_background'],
			description: json['description'],
		);
  }  

	Future<Developer> fromId(String slug) async => fromJson(json.decode(utf8.decode((await http.get(source + '/' + slug, headers: {'Content-Type': 'application/json'})).bodyBytes)));
}