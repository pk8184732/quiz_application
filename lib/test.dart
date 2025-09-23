import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz & Leaderboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C46FF)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F2FF),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      home: const ScoreScreen(),
    );
  }
}

// ===================== Data & Controllers =====================

class PlayerScore {
  final String name;
  final int points;
  final String? avatar; // optional local asset/network
  PlayerScore(this.name, this.points, {this.avatar});
}

class QuizController extends GetxController {
  final score = 150.obs;
  final totalQuestions = 20.obs;
  final correct = 13.obs;
  final wrong = 7.obs;

  double get completion =>
      totalQuestions.value == 0 ? 0 : correct.value / totalQuestions.value;
}

class LeaderboardController extends GetxController {
  final tabs = const ['Today', 'Month', 'All Times'];
  final currentTab = 0.obs;

  final scores = <PlayerScore>[
    PlayerScore('Mobarak', 453),
    PlayerScore('Moni', 442),
    PlayerScore('Keya', 373),
    PlayerScore('Kaosar', 224),
    PlayerScore('Shoaib', 163),
    PlayerScore('Muhib', 131),
    PlayerScore('Shams', 129),
    PlayerScore('You', 124),
    PlayerScore('Akin', 118),
    PlayerScore('Luna', 113),
  ].obs;

  List<PlayerScore> get sorted {
    final list = scores.toList();
    list.sort((a, b) => b.points.compareTo(a.points));
    return list;
  }

  List<PlayerScore> get top3 => sorted.take(3).toList();
  List<PlayerScore> get rest => sorted.skip(3).toList();

  void switchTab(int index) => currentTab.value = index;
}

// ===================== Common UI Helpers =====================

const _bgTop = Color(0xFF8D68FF);
const _bgBottom = Color(0xFF6C46FF);
const _card = Colors.white;

BoxDecoration gradientBg() => const BoxDecoration(
  gradient: LinearGradient(
    colors: [_bgTop, _bgBottom],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

class IconAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const IconAction(
      {super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: cs.primary, size: 24),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ===================== Score Screen =====================

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final qc = Get.put(QuizController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: gradientBg(),
        child: SafeArea(
          child: Column(
            children: [
              // App bar row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _GlassIconButton(
                      icon: Icons.arrow_back,
                      onTap: () {},
                    ),
                    const Spacer(),
                    _GlassIconButton(
                      icon: Icons.more_horiz,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Score ring
              const SizedBox(height: 8),
              Obx(
                    () => _ScoreRing(
                  score: qc.score.value,
                  completion: qc.completion,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),

              // Stats card
              Obx(
                    () => _StatsCard(
                  completionPct: (qc.completion * 100).round(),
                  total: qc.totalQuestions.value,
                  correct: qc.correct.value,
                  wrong: qc.wrong.value,
                ),
              ),
              const SizedBox(height: 12),

              // Actions grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  children: [
                    IconAction(
                      icon: Icons.refresh_rounded,
                      label: 'Play Again',
                      onTap: () {},
                    ),
                    IconAction(
                      icon: Icons.visibility_rounded,
                      label: 'Review Answer',
                      onTap: () {},
                    ),
                    IconAction(
                      icon: Icons.share_rounded,
                      label: 'Share Score',
                      onTap: () {},
                    ),
                    IconAction(
                      icon: Icons.picture_as_pdf_rounded,
                      label: 'Generate PDF',
                      onTap: () {},
                    ),
                    IconAction(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      onTap: () {},
                    ),
                    IconAction(
                      icon: Icons.emoji_events_rounded,
                      label: 'Leaderboard',
                      onTap: () => Get.to(() => const LeaderboardScreen(),
                          transition: Transition.cupertino),
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final int score;
  final double completion;
  final Color color;
  const _ScoreRing(
      {required this.score, required this.completion, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(
              value: completion.clamp(0.0, 1.0),
              strokeWidth: 14,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your Score',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '$score pt',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int completionPct;
  final int total;
  final int correct;
  final int wrong;
  const _StatsCard(
      {required this.completionPct,
        required this.total,
        required this.correct,
        required this.wrong});

  Widget _dot(Color c) => Container(
    width: 8,
    height: 8,
    decoration:
    BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
              title: 'Completion',
              value: '$completionPct%',
              color: Colors.purple),
          _StatItem(
              title: 'Total Question', value: '$total', color: Colors.deepPurple),
          _StatItem(title: 'Correct', value: '$correct', color: Colors.green),
          _StatItem(title: 'Wrong', value: '$wrong', color: Colors.redAccent),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatItem(
      {required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: color, fontSize: 16)),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.20),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

// ===================== Leaderboard Screen =====================

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lb = Get.put(LeaderboardController());

    return Scaffold(
      body: Container(
        decoration: gradientBg(),
        child: SafeArea(
          child: Column(
            children: [
              // App bar row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _GlassIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => Get.back(),
                    ),
                    const Spacer(),
                    _GlassIconButton(
                      icon: Icons.person_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Tabs
              const SizedBox(height: 6),
              Obx(
                    () => SegmentedTabs(
                  labels: lb.tabs,
                  currentIndex: lb.currentTab.value,
                  onChanged: lb.switchTab,
                ),
              ),
              const SizedBox(height: 18),

              // Podium top 3
              Obx(
                    () => TopThreePodium(players: lb.top3),
              ),

              const SizedBox(height: 12),

              // Remaining list
              Expanded(
                child: Obx(
                      () {
                    final rest = lb.rest;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListView.separated(
                        itemCount: rest.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final player = rest[index];
                          final rank = index + 4; // 1..3 on podium
                          return ListTile(
                            leading: Text(
                              rank.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            title: Text(player.name),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE7FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${player.points} pt',
                                  style: const TextStyle(
                                      color: _bgBottom,
                                      fontWeight: FontWeight.w700)),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class SegmentedTabs extends StatelessWidget {
  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const SegmentedTabs(
      {super.key,
        required this.labels,
        required this.currentIndex,
        required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: active ? _bgBottom : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TopThreePodium extends StatelessWidget {
  final List<PlayerScore> players; // exactly 3
  const TopThreePodium({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    // ensure we have 3 slots
    final p = players.length == 3
        ? players
        : [
      ...players,
      ...List.generate(3 - players.length, (_) => PlayerScore('-', 0))
    ];

    // heights proportional to points with min/max caps for a nice look
    int maxPts = p.map((e) => e.points).fold(1, (a, b) => a > b ? a : b);
    double h(int pts) {
      final frac = (pts / maxPts).clamp(0.0, 1.0);
      return 140 + 70 * frac; // 140..210
    }

    Widget col(PlayerScore ps, int place, Color c) {
      return Expanded(
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Text(
                ps.name.isNotEmpty ? ps.name[0] : '-',
                style:
                const TextStyle(fontWeight: FontWeight.w700, color: _bgBottom),
              ),
            ),
            const SizedBox(height: 8),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: h(ps.points),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Positioned(
                  top: 8,
                  child: Text(
                    '$place',
                    style: const TextStyle(
                        color: _bgBottom,
                        fontWeight: FontWeight.w900,
                        fontSize: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ps.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              '${ps.points} pt',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 260,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            col(p[1], 2, const Color(0xFFB39DDB)),
            const SizedBox(width: 10),
            col(p[0], 1, const Color(0xFF9575CD)),
            const SizedBox(width: 10),
            col(p[2], 3, const Color(0xFFD1C4E9)),
          ],
        ),
      ),
    );
  }
}
