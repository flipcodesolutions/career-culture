import '../environment_helper/environment_helper.dart';

class ApiHelper {
  static String baseUrl = Environment.baseUrl;

  /// on boarding
  static String onBoarding = "$baseUrl/onboardings";

  /// programs
  static String programs = "$baseUrl/programs";
  static String sliders = "$baseUrl/sliders";
  static String programById({required String id}) =>
      "$baseUrl/programs?programId=$id";

  /// chapter
  static String getChapters({required String id}) =>
      "$baseUrl/chapters?programId=$id";
  static String getAllChapters = "$baseUrl/all-chapters";

  /// posts
  static String getPostById({required String id}) =>
      "$baseUrl/posts?chapterId=$id";

  /// events
  static String getAllEvents({required String id}) =>
      "$baseUrl/events?eventId=$id";
  static String myParticipation = "$baseUrl/my-participation";

  /// assessments questions
  static String getAssessmentQuestionsByPostId({required String id}) =>
      "$baseUrl/questions?postId=$id";
  static String postAssessmentQuestionsByPostId = "$baseUrl/questions/reply";

  /// wall
  static String getWallPosts({required String uId}) =>
      "$baseUrl/wall?user_id=$uId";
  static String likeWallPost = "$baseUrl/wall/like";

  /// login
  static String login = "$baseUrl/login";

  /// signup
  static String signUp = "$baseUrl/register";

  /// signup
  static String updateUserInfo({required String uId}) =>
      "$baseUrl/update-user-profile/$uId";

  /// email send otp
  static String sendEmailOtp = "$baseUrl/sendEmailOtp";

  /// delete
  static String deleteUser({required String uId}) =>
      "$baseUrl/delete-user/$uId";

  /// sent otp to mobile
  static String sentOtpToMobile = "$baseUrl/sendOtp";

  /// verify otp
  static String verifyOtpOfMobile = "$baseUrl/verifyOtp";

  /// verify otp
  static String verifyOtpOfEmail = "$baseUrl/verifyEmailOtp";

  /// event participation
  static String eventParticipation = "$baseUrl/event-participation";

  /// verify email
  static String verifyEmail = "$baseUrl/verifyEmail";

  ///
  static String getScoreBoard = "$baseUrl/userTopperList";

  ///
  static String getUserProgress = "$baseUrl/getoverallList/";

  /// get products
  static String getProducts = "$baseUrl/getproduts";

  /// get convener
  static String getConvener = "$baseUrl/conveners-list";

  /// get total score
  static String getTotalScore = "$baseUrl/user_overall_list";

  /// get total score
  static String uploadProfilePic = "$baseUrl/user/profile/update";

  /// create order
  static String createOrder = "$baseUrl/order";

  /// create order
  static String orderList = "$baseUrl/user/orders";

  /// create order
  static String screenTime = "$baseUrl/screenTime";

  /// create order
  static String sendFcmToken = "$baseUrl/fcm-token";

  /// create order
  static String getCounselingDatesAndSlots = "$baseUrl/slots";

  /// create order
  static String createCounselingAppointment = "$baseUrl/appointment";
  /// create order
  static String referCode = "$baseUrl/";
}
