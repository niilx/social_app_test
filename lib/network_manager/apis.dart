/*
 *
 * @author Md. Touhidul Islam
 * @ updated at 12/14/21 4:26 PM.
 * /
 */

class ApiEnd {
  static const String baseUrl = 'https://ezycourse.com';

  ///Auth
  static const String loginUrl = '/api/app/student/auth/login';
  static const String logoutUrl = '/api/app/student/auth/logout';

  ///Others
  static const String feedListUrl = '/api/app/teacher/community/getFeed?status=feed&';
  static const String createPostUrl = '/api/app/teacher/community/createFeedWithUpload?';

}
