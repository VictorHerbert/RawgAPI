import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:example/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rawg_api/developer.dart' as RAWG;
import 'package:cached_network_image/cached_network_image.dart';

class DeveloperWidget extends StatelessWidget {
  DeveloperWidget(this.developString, {this.color});

  final Color color;
  final String developString;

  @override
  Widget build(BuildContext context) {
		return Consumer<MainBloc>(builder: (BuildContext context, MainBloc bloc) {
			return bloc.cache.containsKey(developString)?
				bloc.cache[developString]:
				FutureBuilder(
					future: RAWG.Developer.fromId(developString),
					builder: (context, snapshot){
						if(snapshot.connectionState == ConnectionState.done){
							bloc.cache.putIfAbsent(developString, () => loaded(snapshot.data));
							return bloc.cache[developString];//loaded(snapshot.data);
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

	Widget loaded(RAWG.Developer developer){
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
												imageUrl: developer.backgroundImage,
												width: double.maxFinite,
												fit: BoxFit.fill,
											)
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                    title: Text(developer.name),
                  )
                ],
              )),
        ));
  }
}