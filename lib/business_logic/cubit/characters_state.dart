part of 'characters_cubit.dart';

sealed class CharactersState {}

final class CharactersInitial extends CharactersState {}

final class CharactersLoaded extends CharactersState {
  final List<Character> characters;

  CharactersLoaded({required this.characters});
}

final class QuotesLoaded extends CharactersState {
  final List<Quote> quotes;

  QuotesLoaded({required this.quotes});
}
