import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/subscribe_model.dart';
import 'package:graduationprojct/features/home/providers/subscribe_provider.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_playlists_model.dart';
import '../../../auth/data/models/profile_model.dart';
import '../models/subscriptions_model.dart';

class SubscriptionsService {

  Future<List<SubscriptionModel>> getSubscription({required String token}) async {
    final response = await DioHelper().get(
      ApiEndpoints.subscriptions,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
    print(response.data);
    return List<SubscriptionModel>.from(
      response.data.map(
            (x) => SubscriptionModel.fromJson(x),
      ),
    );
  }
}
