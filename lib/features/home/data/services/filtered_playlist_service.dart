import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../models/filtered_playlist_model.dart';

class FilteredPlaylistService {
  Future<List<FilteredPlayListsModel>> getFilteredPlayLists(String token) async {
    try {
      print("========== SERVICE START ==========");
      print("Request => playlists/for_you/");
      print("Token => $token");

      final response = await DioHelper().get(
        "playlists/for_you/",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      print("Status Code => ${response.statusCode}");
      print("Response Type => ${response.data.runtimeType}");
      print("Response Data => ${response.data}");

      final data = List<FilteredPlayListsModel>.from(
        response.data.map(
              (x) => FilteredPlayListsModel.fromJson(x),
        ),
      );

      print("Parsed Length => ${data.length}");
      print("========== SERVICE END ==========");

      return data;
    } catch (e, s) {
      print("SERVICE ERROR => $e");
      print(s);
      rethrow;
    }
  }
}