import '../models/characters.dart';
import '../models/quotes.dart';
import '../web_services/characters_web_services.dart';

class CharactersRepo {
  final CharactersWebServices charactersWebServices;

  CharactersRepo({required this.charactersWebServices});

  Future<List<Character>> fetchAllCharacters() async {
    // in characters the return of the getAllCharacters future method in characters_web_services
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> fetchAllQuotes() async {
    final quotes = await charactersWebServices.getCharactersQuotes();
    return quotes.map((charQuote) => Quote.fromJson(charQuote)).toList();
  }
}
