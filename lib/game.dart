import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

part 'game.g.dart';

enum Ordering{
	name,relesead,added,created,rating
}
//TO Generate
//flutter packages pub run build_runner build
@JsonSerializable(createToJson: false)
class Game{

	static String source = 'https://api.rawg.io/api/games/';
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

	static Future<List<String>> search(String token,{
		DateTime dateBegin,
		DateTime dateEnd,
	}) async{
		
		String path;

		path = source;
		
		if(token = null)
			path += '';
		else
			path += 'search=' + token + '&';
		
		if(dateBegin!= null)
			path += 'dates=' +
				Jiffy(dateBegin).format('yyyy-MM-dd') +
				',' +
				Jiffy(dateEnd).format('yyyy-MM-dd');

		
		List<String> gamesFound = [];
		
		var response = (await http.get(path, headers: {'Content-Type': 'application/json'})).bodyBytes;
		var responseMap = json.decode(utf8.decode(response))['results'];

		for (var result in responseMap) 
      gamesFound.add(result['slug']);
    

    return gamesFound;
	}

	static Game fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

	static Future<Game> fromId(String slug,{bool populateScreenshoots = false, bool populateTrailers = false}) async{
		Game game = fromJson(json.decode(utf8.decode((await http.get(source + slug, headers: {'Content-Type': 'application/json'})).bodyBytes)));
		
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

@JsonSerializable(createToJson: false)
class TrailerData{
	final String name;
	final String preview;
	@JsonKey(name: 'data', fromJson: func)
	final String video;

	static String func(Map<String, dynamic> data) => (data['max'] as String);

	TrailerData(this.name,this.preview,this.video);
	static TrailerData fromJson(Map<String, dynamic> json) => _$TrailerDataFromJson(json);
}