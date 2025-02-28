import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../data/models/characters.dart';

class CharacterItem extends StatelessWidget {
  final Character character;
  const CharacterItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
          color: MyColors.greyColor, borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        //argument character object that we accessed for image and text
        onTap: () => Navigator.pushNamed(context, characterDetailsScreen,
            arguments: character),
        child: GridTile(
          //use hero for animation
          child: Hero(
            tag: character.charId,
            child: Container(
                color: MyColors.whiteColor,
                child: character.image.isNotEmpty
                    ? FadeInImage.assetNetwork(
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: 'assets/images/loading.gif',
                        image: character.image)
                    : Image.asset('assets/images/placeholder.png')),
          ),
          footer: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            color: MyColors.primaryColor,
            alignment: Alignment.bottomCenter,
            child: Text(
              character.charName,
              style: TextStyle(
                  height: 1.3,
                  fontSize: 16,
                  color: MyColors.whiteColor,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
