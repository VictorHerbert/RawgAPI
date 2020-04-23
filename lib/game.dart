import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

enum Ordering{
	name,relesead,added,created,rating
}

class Game{

	static String source = 'https://api.rawg.io/api/games';
	final int id;
	final String slug;
	final String name;
	final String nameOriginal;
	final String description;
	final int metacritic;
	final DateTime released;
	final bool tba;
	final DateTime updated;
	final String backgroundImage;
	final String backgroundImageAdditional;
	final String website;
	final int screenshotsCount;
	final int moviesCount;
	final int creatorsCount;
	final int achievementsCount;
	final String redditUrl;
	final List<String> alternativeNames;
	final String metacriticUrl;
	
	Game({
		this.id,
		this.slug,
		this.name,
		this.nameOriginal,
		this.description,
		this.metacritic,
		this.released,
		this.tba,
		this.updated,
		this.backgroundImage,
		this.backgroundImageAdditional,
		this.website,
		this.screenshotsCount,
		this.moviesCount,
		this.creatorsCount,
		this.achievementsCount,
		this.redditUrl,
		this.alternativeNames,
		this.metacriticUrl,
	});

	//TODO change Jiffy https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
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
		String token,
		List<DateTime> dates,
		Ordering ordering,
		bool reverseOrdering = false,
		int page,
		int pageSize,
		String genre,
		List<String> developers,
		List<String> publishers,
	}) async{
		Map<String,dynamic> params = {
			'search' : token,
			'ordering' : (reverseOrdering? '-' + ordering.toString().split('.').last:ordering.toString().split('.').last),
			'page' : page,
			'page_size' : pageSize,
			'genre' : genre,
			'developers' : developers,
			'publishers' : publishers,
			'dates' : dates,
		};
		
		String path;

		path = source + '?';
		
		params.forEach(
			(key,value){
				if(value != null)
					path += (key + '=' + _format(value) + '&');
			}
		);
		print(path);
		
		List<String> gamesFound = [];
		
		var response = (await http.get(path.substring(0,path.length-1), headers: {'Content-Type': 'application/json'})).bodyBytes;
		var responseMap = json.decode(utf8.decode(response))['results'];

		for (var result in responseMap) 
      gamesFound.add(result['slug']);
    
    return gamesFound;
	}

	static Game fromJson(Map<String, dynamic> json){
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

	static Future<Game> fromId(String slug,{bool populateScreenshoots = false, bool populateTrailers = false}) async{
		Game game = fromJson(json.decode(utf8.decode((await http.get(source + '/' + slug, headers: {'Content-Type': 'application/json'})).bodyBytes)));
		
		if(populateScreenshoots) game.populateScreenshots();
		if(populateTrailers) game.populateTrailers();
		
		return game;
	}
	

	List<String> _screenshotUrls;
	List<String> get screenshotUrls => _screenshotUrls;

	void populateScreenshots() async{
		_screenshotUrls = [];

		var responseData = (await http.get(source + slug + '/screenshots', headers: {'Content-Type': 'application/json'})).bodyBytes;
		var responseMap = json.decode(utf8.decode(responseData))['results'];
		
		for (var response in responseMap)
			_screenshotUrls.add(response['image']);	
	}

	

	List<TrailerData> _trailers;
	List<TrailerData> get trailers => _trailers;
	
	void populateTrailers() async{
		_trailers = [];

		var responseData = (await http.get(source + slug + '/movies', headers: {'Content-Type': 'application/json'})).bodyBytes;
		var responseMap = json.decode(utf8.decode(responseData))['results'];
		
		for (var response in responseMap)
			_trailers.add(TrailerData.fromJson(response));	
	}

}

class TrailerData{
	final String name;
	final String preview;
	final String video;

	static String func(Map<String, dynamic> data) => (data['max'] as String);

	TrailerData(this.name,this.preview,this.video);
	static TrailerData fromJson(Map<String, dynamic> json){
		return TrailerData(
			json['name'] as String,
			json['preview'] as String,
			TrailerData.func(json['data'] as Map<String, dynamic>),
		);
	}
}