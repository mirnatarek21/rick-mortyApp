import 'package:dio/dio.dart';

import '../../constants/strings.dart';

class CharactersWebServices {
  late Dio dio1;
  late Dio dio2;

  CharactersWebServices() {
    // Initialize Dio instance for baseUrl
    dio1 = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    ));

    // Initialize Dio instance for baseUrl2
    dio2 = Dio(BaseOptions(
      baseUrl: baseUrl2,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    ));
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio1.get('character');
      print(response.data.toString());
      return response.data['results'];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getCharactersQuotes() async {
    try {
      Response response = await dio2.get('quotes');
      print(response.data.toString());
      return response.data['quotes'];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
