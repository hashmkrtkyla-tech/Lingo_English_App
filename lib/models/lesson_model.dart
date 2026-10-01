class LessonModel {
  final String id, topic, title;
  final int order; // يبدأ من 1
  final List<Map<String, dynamic>> exercises;
  const LessonModel(
      {required this.id,
      required this.order,
      required this.topic,
      required this.title,
      this.exercises = const []});
}
