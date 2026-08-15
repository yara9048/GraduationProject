import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/notifications_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_favourite_model.dart';
import '../models/display_playlist_by_subject_model.dart';

class NotificationsService {
  Future<List<NotificationsModel>> getNotifications({required String token}) async {
    final response = await DioHelper().get(
      ApiEndpoints.notifications,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return List<NotificationsModel>.from(
      response.data.map(
            (x) => NotificationsModel.fromJson(x),
      ),
    );
  }
}