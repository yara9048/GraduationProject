import 'package:dio/dio.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_favourite_model.dart';

class DisplayFavouriteService {
  Future<List<DisplayFavouriteModel>> getFavourites({required String token}) async {
    final response = await DioHelper().get(
      ApiEndpoints.favourites,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return List<DisplayFavouriteModel>.from(
      response.data.map(
            (x) => DisplayFavouriteModel.fromJson(x),
      ),
    );
  }
}