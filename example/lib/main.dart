import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rawg_api/game.dart' as RAWG;

void main() => runApp(MyApp());

//TODO use LovelyDialog to choose 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => MainBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
					//brightness: Brightness.dark
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainBloc>(builder: (BuildContext context, MainBloc bloc) {
      return Scaffold(
				extendBody: true,
        appBar: AppBar(
					backgroundColor: Colors.purple,
          title: TextField(
						decoration: InputDecoration(
							prefixIcon: Icon(Icons.search),
						),
            onSubmitted: (s) {
              if (bloc.token != s) {
                bloc.token = s;
              }
            },
          ),
					//actions:[
						//Icon(Icons.close)
					//]
        ),
        body: (bloc.token == '')
            ? Text('Insert some token')
            : ListView.builder(
                itemCount: bloc.games.length,
                itemBuilder: (BuildContext context, int index) {
									return GameWidget(bloc.games[index]);
                }),
				floatingActionButton: FloatingActionButton(
					child: Icon(Icons.search),
					onPressed: (){},
				),
				bottomNavigationBar: BottomAppBar(
					//color: Colors.black,
					shape: CircularNotchedRectangle(),
					child: Container(
						height: 50.0,
					),
				),
				floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}

class GameWidget extends StatelessWidget {
  GameWidget(this.gameString, {this.color});

  final Color color;
  final String gameString;

  @override
  Widget build(BuildContext context) {
		return Consumer<MainBloc>(builder: (BuildContext context, MainBloc bloc) {
			return bloc.gameCache.containsKey(gameString)?
				bloc.gameCache[gameString]:
				FutureBuilder(
					future: RAWG.Game.fromId(gameString),
					builder: (context, snapshot){
						if(snapshot.connectionState == ConnectionState.done){
							bloc.gameCache.putIfAbsent(gameString, () => loaded(snapshot.data));
							return bloc.gameCache[gameString];//loaded(snapshot.data);
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
