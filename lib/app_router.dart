// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/business_logic/cubit/characters_cubit.dart';
import 'package:flutterbloc/constants/strings.dart';
import 'package:flutterbloc/data/models/characters.dart';
import 'package:flutterbloc/data/repository/characters_repo.dart';
import 'package:flutterbloc/data/web_services/characters_web_services.dart';
import 'package:flutterbloc/presentation/screens/character_details_screen.dart';
import 'package:flutterbloc/presentation/screens/characters_screen.dart';

class AppRouter {
  late CharactersRepo charactersRepo;
  late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepo =
        CharactersRepo(charactersWebServices: CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepo);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) => charactersCubit,
                  child: CharactersScreen(),
                ));
      case characterDetailsScreen:
        //pass character that i want to see its details to the details screen
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  //new cubit or (I can use the same cubit as the previous screen by using .value)
                  create: (BuildContext context) =>
                      CharactersCubit(charactersRepo),
                  child: CharacterDetailsScreen(
                    character: character,
                  ),
                ));
    }
  }
}
