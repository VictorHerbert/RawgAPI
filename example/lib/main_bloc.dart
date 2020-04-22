import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rawg_api/game.dart' as RAWG;
import 'package:flutter/material.dart';

class MainBloc extends BlocBase{
	
	String _token = '';
	List<String> games = [];
	Map<String,Widget> gameCache = {};
	

	get token => _token;
	
	set token(String token){
		_token = token;
		setGames(token);
		
		notifyListeners();
	}

	setGames(String token) async{
		gameCache.clear();
		games = await RAWG.Game.search(
			token: token,
			dates: [DateTime.utc(1989, 11, 9), DateTime.now()],
			ordering: RAWG.Ordering.added,
			reverseOrdering: false,
		);
		notifyListeners();
	} 

}