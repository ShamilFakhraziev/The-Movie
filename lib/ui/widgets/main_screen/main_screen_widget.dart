import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/library/widgets/inherited/provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  final movieListModel = MovieListModel();

  // static final List<Widget> _widgetsOptions = <Widget>[
  //   Text("News"),
  //   const MovieListWidget(),
  //   Text("Serials"),
  // ];

  int _selectedTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    movieListModel.setupLocale(context);
  }

  void _selectTab(int index) {
    if (_selectedTab == index) return;
    _selectedTab = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TMDB', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              SessionDataProvider().setSessionId(null);
              Navigator.of(
                context,
              ).pushReplacementNamed(MainNavigationRouteNames.auth);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "News"),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Serials"),
        ],
        onTap: _selectTab,
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const Text("News"),
          NotifierProvider<MovieListModel>(
            child: const MovieListWidget(),
            create: () => movieListModel,
            isManageModel: false,
          ),
          const Text("Serials"),
        ],
      ),
    );
  }
}
