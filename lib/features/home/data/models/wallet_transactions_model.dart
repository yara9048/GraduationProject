import 'package:graduationprojct/features/home/data/models/subscriptions_model.dart';

class WalletTransactionsModel {
  final int id;
  final int user;

  final UserDetailModel? userDetail;

  final String transactionType;

  final double amount;
  final double balanceAfter;

  final int? playlist;
  final PlaylistDetailModel? playlistDetail;

  final int? subscription;

  final int? relatedUser;
  final UserDetailModel? relatedUserDetail;

  final String note;
  final String createdAt;


  WalletTransactionsModel({
    required this.id,
    required this.user,
    required this.userDetail,
    required this.transactionType,
    required this.amount,
    required this.balanceAfter,
    required this.playlist,
    required this.playlistDetail,
    required this.subscription,
    required this.relatedUser,
    required this.relatedUserDetail,
    required this.note,
    required this.createdAt,
  });


  factory WalletTransactionsModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return WalletTransactionsModel(

      id: JsonParser.toInt(json['id']),

      user: JsonParser.toInt(json['user']),


      userDetail:
      JsonParser.toMap(json['user_detail']) == null
          ? null
          : UserDetailModel.fromJson(
        JsonParser.toMap(
            json['user_detail']
        )!,
      ),



      transactionType:
      JsonParser.toStringValue(
          json['transaction_type']
      ),



      amount:
      JsonParser.toDouble(
          json['amount']
      ),



      balanceAfter:
      JsonParser.toDouble(
          json['balance_after']
      ),



      playlist:
      JsonParser.toNullableInt(
          json['playlist']
      ),



      playlistDetail:
      JsonParser.toMap(json['playlist_detail']) == null
          ? null
          : PlaylistDetailModel.fromJson(
        JsonParser.toMap(
            json['playlist_detail']
        )!,
      ),



      subscription:
      JsonParser.toNullableInt(
          json['subscription']
      ),



      relatedUser:
      JsonParser.toNullableInt(
          json['related_user']
      ),



      relatedUserDetail:
      JsonParser.toMap(
          json['related_user_detail']
      ) == null
          ? null
          : UserDetailModel.fromJson(
        JsonParser.toMap(
            json['related_user_detail']
        )!,
      ),



      note:
      JsonParser.toStringValue(
          json['note']
      ),



      createdAt:
      JsonParser.toStringValue(
          json['created_at']
      ),

    );
  }



  static List<WalletTransactionsModel> fromJsonList(
      dynamic data,
      ) {

    if(data is! List){
      return [];
    }


    return data
        .whereType<Map>()
        .map(
          (item) =>
          WalletTransactionsModel.fromJson(
            Map<String,dynamic>.from(item),
          ),
    )
        .toList();
  }

}