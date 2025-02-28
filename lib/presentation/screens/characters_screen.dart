import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/colors.dart';
import '../../data/models/characters.dart';
import '../widgets/character_item.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedForCharacters;
  bool _isSearching = false;
  bool noResultsFound = false; // Track if no results are found
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.whiteColor,
      decoration: InputDecoration(
        hintText: 'Find a character',
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColors.greyColor, fontSize: 18),
      ),
      style: TextStyle(color: MyColors.whiteColor, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedItemsToSearchedList(String searchedCharacter) {
    searchedForCharacters = allCharacters
        .where((character) =>
            character.charName.toLowerCase().startsWith(searchedCharacter))
        .toList();

    // Check if the search result is empty
    noResultsFound =
        searchedForCharacters.isEmpty && searchedCharacter.isNotEmpty;

    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearchText();
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
          color: MyColors.whiteColor,
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(Icons.search),
          color: MyColors.whiteColor,
        )
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearch));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    _clearSearchText();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchText() {
    setState(() {
      _searchTextController.clear();
      noResultsFound = false;
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).retreiveAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        allCharacters = state.characters;
        return buildLoadedListWidget();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.primaryColor,
      ),
    );
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.whiteColor,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    if (noResultsFound) {
      return Container(
        height:
            MediaQuery.of(context).size.height * 1, // Adjust height dynamically
        color: Colors.white,
        child: Center(
          child: Text(
            "No character found",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _searchTextController.text.isEmpty
          ? allCharacters.length
          : searchedForCharacters.length,
      itemBuilder: (context, index) {
        return CharacterItem(
          character: _searchTextController.text.isEmpty
              ? allCharacters[index]
              : searchedForCharacters[index],
        );
      },
    );
  }

  Widget _buildAppBarTitle() {
    return Text(
      "Characters",
      style: TextStyle(
        color: MyColors.whiteColor,
      ),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              textAlign: TextAlign.center,
              "Can\'t connect! Check your Internet Connection",
              style: TextStyle(fontSize: 22, color: MyColors.greyColor),
            ),
            Image.asset('assets/images/noo_internet.png')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          List<ConnectivityResult> connectivity,
          Widget child,
        ) {
          final bool connected =
              !connectivity.contains(ConnectivityResult.none);
          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }
}
