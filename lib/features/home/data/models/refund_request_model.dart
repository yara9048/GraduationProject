import 'package:graduationprojct/features/home/data/models/subscriptions_model.dart';

class RefundRequestModel {
  final int id;
  final int user;
  final int subscription;

  final RefundRequestDetailModel? subscriptionDetail;

  final double amount;
  final String status;
  final String reason;
  final String adminNote;

  final int? reviewedBy;
  final String? reviewedAt;

  final String createdAt;
  final String updatedAt;

  const RefundRequestModel({
    required this.id,
    required this.user,
    required this.subscription,
    required this.subscriptionDetail,
    required this.amount,
    required this.status,
    required this.reason,
    required this.adminNote,
    required this.reviewedBy,
    required this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RefundRequestModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final subscriptionDetailMap =
    JsonParser.toMap(json['subscription_detail']);

    return RefundRequestModel(
      id: JsonParser.toInt(json['id']),
      user: JsonParser.toInt(json['user']),
      subscription: JsonParser.toInt(
        json['subscription'],
      ),
      subscriptionDetail: subscriptionDetailMap == null
          ? null
          : RefundRequestDetailModel.fromJson(
        subscriptionDetailMap,
      ),
      amount: JsonParser.toDouble(json['amount']),
      status: JsonParser.toStringValue(
        json['status'],
      ),
      reason: JsonParser.toStringValue(
        json['reason'],
      ),
      adminNote: JsonParser.toStringValue(
        json['admin_note'],
      ),
      reviewedBy: JsonParser.toNullableInt(
        json['reviewed_by'],
      ),
      reviewedAt: JsonParser.toNullableString(
        json['reviewed_at'],
      ),
      createdAt: JsonParser.toStringValue(
        json['created_at'],
      ),
      updatedAt: JsonParser.toStringValue(
        json['updated_at'],
      ),
    );
  }

  static List<RefundRequestModel> fromJsonList(
      dynamic data,
      ) {
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map(
          (item) => RefundRequestModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }
}

class RefundRequestDetailModel {
  final int id;
  final int user;

  final UserDetailModel? userDetail;

  final int playlist;
  final PlaylistDetailModel? playlistDetail;

  final dynamic teacherDetail;

  final bool isActive;

  final double pricePaid;
  final double teacherAmount;
  final double adminAmount;

  final String createdAt;
  final String updatedAt;

  const RefundRequestDetailModel({
    required this.id,
    required this.user,
    required this.userDetail,
    required this.playlist,
    required this.playlistDetail,
    required this.teacherDetail,
    required this.isActive,
    required this.pricePaid,
    required this.teacherAmount,
    required this.adminAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RefundRequestDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final userDetailMap =
    JsonParser.toMap(json['user_detail']);

    final playlistDetailMap =
    JsonParser.toMap(json['playlist_detail']);

    return RefundRequestDetailModel(
      id: JsonParser.toInt(json['id']),

      // الـresponse يحتوي أحيانًا على " user" بمسافة.
      user: JsonParser.toInt(
        json['user'] ?? json[' user'],
      ),

      userDetail: userDetailMap == null
          ? null
          : UserDetailModel.fromJson(
        userDetailMap,
      ),

      playlist: JsonParser.toInt(
        json['playlist'],
      ),

      playlistDetail: playlistDetailMap == null
          ? null
          : PlaylistDetailModel.fromJson(
        playlistDetailMap,
      ),

      teacherDetail: json['teacher_detail'],

      isActive: JsonParser.toBool(
        json['is_active'],
      ),

      pricePaid: JsonParser.toDouble(
        json['price_paid'],
      ),

      teacherAmount: JsonParser.toDouble(
        json['teacher_amount'],
      ),

      adminAmount: JsonParser.toDouble(
        json['admin_amount'],
      ),

      createdAt: JsonParser.toStringValue(
        json['created_at'],
      ),

      updatedAt: JsonParser.toStringValue(
        json['updated_at'],
      ),
    );
  }
}