import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/playlist_details_model.dart';
import 'package:graduationprojct/features/home/data/services/playlist_details_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistDetailsProvider with ChangeNotifier {
final PlayListDetailsService _service =
PlayListDetailsService();

bool _isLoading = false;
String? _errorMessage;
bool _isSuccess = false;

PlayListDetailsModel? _playListDetails;

int? _loadedPlaylistId;

bool get isLoading => _isLoading;

String? get errorMessage => _errorMessage;

bool get isSuccess => _isSuccess;

PlayListDetailsModel? get playListDetails =>
_playListDetails;

int? get loadedPlaylistId => _loadedPlaylistId;

Future<void> getDetails({
required int id,
bool forceRefresh = false,
}) async {
/*
     * إذا كانت نفس Playlist محملة مسبقاً،
     * لا نعيد الطلب إلا عند استخدام forceRefresh.
     */
if (!forceRefresh &&
_loadedPlaylistId == id &&
_playListDetails != null) {
debugPrint(
'Playlist details already loaded for ID: $id',
);

return;
}

_isLoading = true;
_errorMessage = null;
_isSuccess = false;

/*
     * مهم جداً:
     * نحذف بيانات Playlist السابقة قبل تحميل الجديدة،
     * حتى لا تظهر نفس التفاصيل القديمة.
     */
_playListDetails = null;
_loadedPlaylistId = null;

notifyListeners();

try {
debugPrint(
'Getting playlist details for ID: $id',
);

final prefs =
await SharedPreferences.getInstance();

final token =
prefs.getString('auth_token');

if (token == null || token.isEmpty) {
throw Exception(
'Authentication token not found',
);
}

final response =
await _service.getDetails(
token: token,
id: id,
);

/*
       * نتأكد أن النتيجة المحفوظة تخص الـ id
       * الذي طلبناه حالياً.
       */
_playListDetails = response;
_loadedPlaylistId = id;
_isSuccess = true;
_errorMessage = null;

debugPrint(
'Playlist loaded successfully:',
);

debugPrint(
'Requested ID: $id',
);

debugPrint(
'Response ID: ${_playListDetails?.id}',
);

debugPrint(
'Playlist name: ${_playListDetails?.name}',
);
} catch (e, stackTrace) {
_errorMessage =
_cleanErrorMessage(e.toString());

_isSuccess = false;

/*
       * لا نترك بيانات Playlist قديمة
       * عند فشل الطلب.
       */
_playListDetails = null;
_loadedPlaylistId = null;

debugPrint(
'Playlist details error for ID $id: $e',
);

debugPrintStack(
stackTrace: stackTrace,
);
} finally {
_isLoading = false;
notifyListeners();
}
}

/*
   * تستخدم عند الحاجة لإعادة تحميل
   * تفاصيل الـ Playlist الحالية من السيرفر.
   */
Future<void> refreshDetails({
required int id,
}) async {
await getDetails(
id: id,
forceRefresh: true,
);
}

/*
   * التحقق أن البيانات الموجودة تخص
   * Playlist معينة.
   */
bool hasDetailsFor(int id) {
return _loadedPlaylistId == id &&
_playListDetails != null;
}

void reset() {
_isLoading = false;
_errorMessage = null;
_isSuccess = false;
_playListDetails = null;
_loadedPlaylistId = null;

notifyListeners();
}

String _cleanErrorMessage(String error) {
return error
    .replaceFirst('Exception:', '')
    .replaceFirst('DioException:', '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
}
}
