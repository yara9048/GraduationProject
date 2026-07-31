import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/wallet_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_favourite_model.dart';

class WalletService {
  Future<WalletModel> getWallet({required String token}) async {
    final response = await DioHelper().get(
      ApiEndpoints.wallet,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return WalletModel.fromJson(response.data);
  }
}