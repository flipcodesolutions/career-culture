import '../environment_helper/environment_helper.dart';

class ApiHelper {
  static String baseUrl = Environment.baseUrl;

  /// on boarding
  static String onBoarding = "$baseUrl/onboardings";

  /// programs
  static String programs = "$baseUrl/programs";
  static String programById({required String id}) =>
      "$baseUrl/programs?programId=$id";

  /// chapter
  static String getChapters({required String id}) =>
      "$baseUrl/chapters?programId=$id";

  /// posts
  static String getPostById({required String id}) =>
      "$baseUrl/posts?chapterId=$id";

  /// events
  static String getAllEvents({required String id}) =>
      "$baseUrl/events?eventId=$id";

  /// assessments questions
  static String getAssessmentQuestionsByPostId({required String id}) =>
      "$baseUrl/questions?postId=$id";
}
