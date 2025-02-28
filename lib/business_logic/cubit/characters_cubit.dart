import 'package:bloc/bloc.dart';
import '../../data/models/characters.dart';
import '../../data/models/quotes.dart';
import '../../data/repository/characters_repo.dart';
part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepo charactersRepo;
  List<Character> characters = [];

  CharactersCubit(this.charactersRepo) : super(CharactersInitial());

  List<Character> retreiveAllCharacters() {
    //take the return of fetchAllCharacters from repo here in the cubit
    charactersRepo.fetchAllCharacters().then((characters) {
      emit(CharactersLoaded(characters: characters));
      this.characters = characters;
    });
    return characters;
  }

  void getQuotes() {
    //take the return of fetchAllCharacters from repo here in the cubit
    charactersRepo.fetchAllQuotes().then((quotes) {
      emit(QuotesLoaded(quotes: quotes));
    });
  }
}
