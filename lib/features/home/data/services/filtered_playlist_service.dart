import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/filtered_playlist_model.dart';

class FilteredPlaylistService {
  Future<List<FilteredPlayListsModel>> getFilteredPlayLists(
      String token,
      ) async {
    try {
      final response = await DioHelper().get(
        ApiEndpoints.filteredPlaylists,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Type: ${response.data.runtimeType}");
      debugPrint("Response Data: ${response.data}");

      final responseData = response.data;

      if (responseData is! List) {
        throw FormatException(
          "Expected List but received ${responseData.runtimeType}",
        );
      }

      final playlists = responseData.map((item) {
        if (item is! Map) {
          throw FormatException(
            "Expected playlist object but received ${item.runtimeType}",
          );
        }

        return FilteredPlayListsModel.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();

      debugPrint("Parsed playlists: ${playlists.length}");

      return playlists;
    } catch (e, stackTrace) {
      debugPrint("FilteredPlaylistService error: $e");
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }
}