class ApiEndpoints {
  static const login = '/login/';
  static const register = '/register/';
  static const resendOtp = '/resend-otp/';
  static const sendOtp = '/verify-otp/';
  static const passwordResetRequest = '/reset-password/request/';
  static const passwordResetOtp = '/reset-password/verify/';
  static const newPassword = '/reset-password/confirm/';

  static const filteredPaylists = 'playlists/for_you/';
  static const playlists = 'playlists/';
  static const favourite = 'favorites/';

  static String toggleVideoFavorite(int id) =>
      'videos/$id/toggle_favorite/';

  static String togglePlaylistFavorite(int id) =>
      'playlists/$id/toggle_favorite/';
}