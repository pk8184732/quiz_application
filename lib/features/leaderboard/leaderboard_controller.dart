import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import '../../mode/user_stats_model.dart';

class LeaderboardController extends GetxController {
  final tabs = const ['Today', 'Month', 'All Time'];
  final tabIndex = 0.obs;

  void setTab(int i) => tabIndex.value = i;

  // Observable players list
  var players = <UserStatsModel>[].obs;

  // Top 3 and the rest
  var top3 = <UserStatsModel>[].obs;
  var rest = <UserStatsModel>[].obs;

  // Confetti controller
  late ConfettiController confettiController;

  // Current user (example: Puja)
  var currentUser = UserStatsModel(
    name: 'Puja',
    totalQuizzesCompleted: 15,
    totalPoints: 1250,
    averageScore: 83.3,
    rank: 'Pro',
    streak: 5,
    achievements: ['Fast Learner', 'High Scorer'],
  ).obs;

  @override
  void onInit() {
    super.onInit();
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    generateDummyData();

    // Play confetti on screen open
    confettiController.play();
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }

  void generateDummyData() {
    final List<UserStatsModel> dummyData = [
      UserStatsModel(
        name: 'Moni',
        totalQuizzesCompleted: 20,
        totalPoints: 442,
        averageScore: 75.0,
        rank: 'Expert',
        streak: 3,
        achievements: ['Top Scorer'],
      ),
      UserStatsModel(
        name: 'Mobarak',
        totalQuizzesCompleted: 25,
        totalPoints: 453,
        averageScore: 80.0,
        rank: 'Master',
        streak: 6,
        achievements: ['High Scorer', 'Consistent'],
      ),
      UserStatsModel(
        name: 'Keya',
        totalQuizzesCompleted: 18,
        totalPoints: 373,
        averageScore: 77.5,
        rank: 'Expert',
        streak: 2,
        achievements: ['Quick Thinker'],
      ),
      UserStatsModel(
        name: 'Kaosar',
        totalQuizzesCompleted: 12,
        totalPoints: 224,
        averageScore: 70.0,
        rank: 'Intermediate',
        streak: 1,
        achievements: [],
      ),
      UserStatsModel(
        name: 'Shoaib',
        totalQuizzesCompleted: 10,
        totalPoints: 163,
        averageScore: 65.0,
        rank: 'Beginner',
        streak: 0,
        achievements: [],
      ),
      UserStatsModel(
        name: 'Muhib',
        totalQuizzesCompleted: 11,
        totalPoints: 131,
        averageScore: 68.0,
        rank: 'Intermediate',
        streak: 1,
        achievements: [],
      ),
      UserStatsModel(
        name: 'Shams',
        totalQuizzesCompleted: 9,
        totalPoints: 129,
        averageScore: 60.0,
        rank: 'Beginner',
        streak: 0,
        achievements: [],
      ),
    ];

    // Add current user also
    dummyData.add(currentUser.value);

    // Sort by points
    dummyData.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

    // Assign to players
    players.value = dummyData;

    // Top 3
    top3.value = players.take(3).toList();

    // Rest
    rest.value = players.length > 3 ? players.sublist(3) : [];
  }
}
