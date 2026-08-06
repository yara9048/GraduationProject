class ApiEndpoints {
  static const login = 'login/';
  static const register = 'register/';
  static const resendOtp = 'resend-otp/';
  static const sendOtp = 'verify-otp/';
  static const passwordResetRequest = 'reset-password/request/';
  static const passwordResetOtp = 'reset-password/verify/';
  static const newPassword = 'reset-password/confirm/';
  static const logout = 'logout/';
  static const profile = 'profile/';
  static const courses = 'courses/';
  static const walletTransactions = 'wallet-transactions/';
  static const filteredPlaylists = 'courses/for_you/';
  static const subjects = 'subjects/';
  static const favourites = 'favorites/';
  static const ratings = 'ratings/';
  static String courseDetails(int id) =>
      'courses/$id/';
  static String courseVideos(int id) =>
      'courses/$id/videos/';
  static String coursesBySubject(int id) =>
      'courses/by-subject/$id/';
  static String togglePlaylistFavorite(int id) =>
      'courses/$id/toggle_favorite/';
  static String videoDetails(int id) =>
      'videos/$id/';
  static String toggleVideoFavorite(int id) =>
      'videos/$id/toggle_favorite/';
  static String videoAiFeatures(int videoId) =>
      'videos/$videoId/ai_features/';
  static const wallet = 'wallet/';
  static const refundRequest = 'refund-requests/';
  static const subscriptions = 'subscriptions/';
  static const fundingRequest = 'funding-requests/';
  static const watchingNow =
      'video-progress/watching_now/';
  static const watchingHistory =
      'video-progress/history/';
  static const purchaseSubscription =
      'subscriptions/purchase/';
  static const progress = 'video-progress/';
  static const chats = 'chats/';
  static const messages = 'messages/';


}