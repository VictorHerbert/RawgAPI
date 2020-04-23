import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class Developer {
	static String source = 'https://api.rawg.io/api/developers';
  final int id;	
  final String name;
  final String slug;
  final int gamesCount;
  final String backgroundImage;
  final String description;

  Developer({
		this.id,
		this.name,
		this.slug,
		this.gamesCount,
		this.backgroundImage,
		this.description
	});

  static Developer fromJson(Map<String, dynamic> json) {
		return Developer(
			id: json['id'],
			name: json['name'],
			slug: json['slug'],
			gamesCount: json['games_count'],
			backgroundImage: json['image_background'],
			description: json['description'],
		);
  }  

	static Future<Developer> fromId(String slug) async => fromJson(json.decode(utf8.decode((await http.get(source + '/' + slug, headers: {'Content-Type': 'application/json'})).bodyBytes)));

		static String _format(dynamic value){
		if(value is String) return value;
		if(value is List<String>){
			String join ='';

			for(int i = 1; i < value.length; i++)
				join += ',' + value[i];
			
			return join;
		}	
		if(value is List<DateTime>){
			
			if(value.length == 1)
				value.add(DateTime.now());

			return
				Jiffy(value[0]).format('yyyy-MM-dd') +
				',' +
				Jiffy(value[1]).format('yyyy-MM-dd');
		}
		return '';
	}

	static Future<List<String>> search({
		int page,
		int pageSize,
	}) async{
		
		String path;

		path = source + '?';

		if(page != null)
			path += 'page=' + page.toString() + '&';
		if(pageSize != null)
			path += 'page_size=' + pageSize.toString();

		
		List<String> gamesFound = [];
		
		var response = (await http.get(path.substring(0,path.length-1), headers: {'Content-Type': 'application/json'})).bodyBytes;
		var responseMap = json.decode(utf8.decode(response))['results'];

		for (var result in responseMap) 
      gamesFound.add(result['slug']);
    
    return gamesFound;
	}
}