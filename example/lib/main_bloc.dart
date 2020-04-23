import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rawg_api/game.dart' as RAWG;
import 'package:rawg_api/developer.dart' as RAWG_D;
import 'package:flutter/material.dart';

enum SearchType{
	Games,Developers
}

class MainBloc extends BlocBase{
	SearchType _searchType = SearchType.Games;
	
	String _token = '';



	List<String> results = [];
	Map<String,Widget> cache = {};
	
	bool _isSearching = false;
	get isSearching => _isSearching;
	set isSearching (bool value){
		_isSearching = value;
		notifyListeners();
	}

	get token => _token;
	
	set token(String token){
		_token = token;
		if(_searchType == SearchType.Games)
			setGames(token);
		else
			setDevelopers();
		
		notifyListeners();
	}

	setGames(String token) async{
		cache.clear();
		results = await RAWG.Game.search(
			token: token,
			dates: [DateTime.utc(1989, 11, 9), DateTime.now()],
			ordering: RAWG.Ordering.added,
			reverseOrdering: false,
		);
		notifyListeners();
	}

	setDevelopers() async{
		cache.clear();
		results = await RAWG_D.Developer.search();
		notifyListeners();
	}

}