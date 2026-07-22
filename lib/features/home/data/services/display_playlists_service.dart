import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../models/display_playlists_model.dart';
import '../../../auth/data/models/profile_model.dart';

class DisplayPlaylistsService {

  Future<List<DisplayPlaylistsModel>> getPlayLists() async {
    final response = await DioHelper().get(
      "playlists/",
    );
     print(response.data);
    return List<DisplayPlaylistsModel>.from(
      response.data.map(
            (x) => DisplayPlaylistsModel.fromJson(x),
      ),
    );
  }
}
