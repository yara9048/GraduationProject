import 'package:dio/dio.dart';
import 'package:graduationprojct/features/home/data/models/wallet_transactions_model.dart';

import '../../../../core/dio.dart';
import '../../../../core/end_points.dart';
import '../models/display_favourite_model.dart';
import '../models/display_playlist_by_subject_model.dart';

class WalletTransactionsService {
  Future<List<WalletTransactionsModel>> getTransactions({required String token}) async {
    final response = await DioHelper().get(
      ApiEndpoints.walletTransactions,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print(response.data);

    return List<WalletTransactionsModel>.from(
      response.data.map(
            (x) => WalletTransactionsModel.fromJson(x),
      ),
    );
  }
}