import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:example/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rawg_api/game.dart' as RAWG;
import 'package:cached_network_image/cached_network_image.dart';

class GameWidget extends StatelessWidget {
  GameWidget(this.gameString, {this.color});

  final Color color;
  final String gameString;

  @override
  Widget build(BuildContext context) {
		return Consumer<MainBloc>(builder: (BuildContext context, MainBloc bloc) {
			return bloc.cache.containsKey(gameString)?
				bloc.cache[gameString]:
				FutureBuilder(
					future: RAWG.Game.fromId(gameString),
					builder: (context, snapshot){
						if(snapshot.connectionState == ConnectionState.done){
							bloc.cache.putIfAbsent(gameString, () => loaded(snapshot.data));
							return bloc.cache[gameString];//loaded(snapshot.data);
						}
						else
							return Container(
								height: 300,
								child: Center(
									child: CircularProgressIndicator(),
								)
								
							);
					},
				);
			});
	}

	Widget loaded(RAWG.Game game){
		print(game.backgroundImage);
    return Container(
        height: 300,
        child: InkWell(
          child: Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: 
											CachedNetworkImage(
												placeholder: (context, url) => Opacity(
													opacity: .4,
													child: Container(
														color: Colors.blue,
													),
												),
												imageUrl: game.backgroundImage,
												width: double.maxFinite,
												fit: BoxFit.fill,
											)
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                    title: Text(game.name),
                  )
                ],
              )),
        ));
  }
}