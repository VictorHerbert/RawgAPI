import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:example/main_bloc.dart';
import 'package:example/widgets/game_widget.dart';
import 'package:flutter/material.dart';
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
        appBar: bloc.isSearching ? 
					AppBar(
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
					) :
					AppBar(
						backgroundColor: Colors.purple,
						title: Text('RawgApi'),
						actions:[
							Icon(Icons.menu)
						]
					),
        body: (bloc.token == '')
            ? Center(child: Text('Insert some token'))
            : ListView.builder(
                itemCount: bloc.results.length,
                itemBuilder: (BuildContext context, int index) {
									return GameWidget(bloc.results[index]);
                }),
				floatingActionButton: FloatingActionButton(
					child: Icon(Icons.search),
					onPressed: (){bloc.isSearching = true;}
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


