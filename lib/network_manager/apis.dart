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
  static const String createUpdateLikeUrl = '/api/app/teacher/community/createLike?=&=&=&=';
  static const String commentListUrl = '/api/app/student/comment/getComment/';
  static const String commentReplyListUrl = '/api/app/student/comment/getReply/';
  static const String createCommentUrl = '/api/app/student/comment/createComment';
  static const String createCommentReplyUrl = '/api/app/student/comment/createComment';

}
