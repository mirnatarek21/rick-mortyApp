import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/colors.dart';
import '../../data/models/characters.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  const CharacterDetailsScreen({super.key, required this.character});

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 700,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.whiteColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.charName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        background: Hero(
            tag: character.charId,
            child: Image.network(
              character.image,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget characterInfo(String key, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
            text: key,
            style: TextStyle(
                color: MyColors.greyColor,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        TextSpan(
            text: value,
            style: TextStyle(color: MyColors.greyColor, fontSize: 20))
      ]),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      height: 30,
      color: MyColors.primaryColor,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomOrEmptySpace(state);
    } else
      return showProgressIndicator();
  }

  Widget displayRandomOrEmptySpace(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      //make sure randimly generated number doesn't exceed the list length
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: MyColors.greyColor, shadows: [
              Shadow(
                  blurRadius: 7,
                  color: MyColors.primaryColor,
                  offset: Offset(0, 0))
            ]),
            child: AnimatedTextKit(repeatForever: true, animatedTexts: [
              FlickerAnimatedText(quotes[randomQuoteIndex].quote),
            ])),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes();
    return Scaffold(
      backgroundColor: MyColors.whiteColor,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  characterInfo('gender: ', character.gender),
                  buildDivider(290),
                  characterInfo('Species: ', character.speciesHumanOrWhat),
                  buildDivider(280),
                  characterInfo('Status: ', character.statsAliveOrDead),
                  buildDivider(300),
                  characterInfo('created: ', character.created),
                  buildDivider(290),
                  character.type.isEmpty
                      ? Container()
                      : characterInfo('type: ', character.type),
                  character.type.isEmpty ? Container() : buildDivider(325),
                  characterInfo('episodes: ', character.episodes.join(' / ')),
                  buildDivider(270),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<CharactersCubit, CharactersState>(
                      builder: (context, state) {
                    return checkIfQuotesAreLoaded(state);
                  })
                ],
              ),
            ),
            SizedBox(
              height: 500,
            )
          ]))
        ],
      ),
    );
  }
}
