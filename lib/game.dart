import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

part 'game.g.dart';

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

 //https://api.rawg.io/api/games?saerch=doom&ordering=-Ordering.added&page=doom&dates=&dates=1989-11-09,2020-04-21&
		
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

	static Game fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

	static Future<Game> fromId(String slug,{bool populateScreenshoots = false, bool populateTrailers = false}) async{
		print(source + '/' + slug);
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
	static TrailerData fromJson(Map<String, dynamic> json) => _$TrailerDataFromJson(json);
}