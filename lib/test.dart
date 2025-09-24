// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leaderboard',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0EAFE),
        fontFamily: 'Roboto',
      ),
      home: const LeaderboardScreen(),
    );
  }
}

// ---------------------- Controller (GetX) ----------------------
class LeaderboardController extends GetxController {
  final tabs = const ['Today', 'Month', 'All Times'];
  final tabIndex = 0.obs;

  void setTab(int i) => tabIndex.value = i;

  // Exact demo data to match UI
  final top = const [
    _TopUser(name: 'Moni', score: 442),
    _TopUser(name: 'Mobarak', score: 453, isWinner: true),
    _TopUser(name: 'Keya', score: 373),
  ];

  final rows = const <_RowUser>[
    _RowUser(rank: 1, name: 'Kaosar', score: 224),
    _RowUser(rank: 5, name: 'Shoaib', score: 163),
    _RowUser(rank: 6, name: 'Muhib', score: 131),
    _RowUser(rank: 7, name: 'Shams', score: 129),
    _RowUser(rank: 18, name: 'You', score: 124),
  ];
}

class _TopUser {
  final String name;
  final int score;
  final bool isWinner;
  const _TopUser({required this.name, required this.score, this.isWinner = false});
}

class _RowUser {
  final int rank;
  final String name;
  final int score;
  const _RowUser({required this.rank, required this.name, required this.score});
}

// ---------------------- Screen (Stateless) ----------------------
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LeaderboardController());
    return Scaffold(
      body: Stack(
        children: [
          const _PurpleBackground(),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _FrostIcon(
                        icon: Icons.arrow_back,
                        onTap: () {},
                      ),
                      const Spacer(),
                      _FrostCircle(
                        child: Icon(Icons.person, color: Colors.white.withOpacity(0.95)),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // Tabs
                const SizedBox(height: 6),
                Obx(
                      () => _Tabs(
                    labels: c.tabs,
                    index: c.tabIndex.value,
                    onChanged: c.setTab,
                  ),
                ),

                // Podium
                const SizedBox(height: 10),
                _PodiumSection(),

                // List
                const SizedBox(height: 14),
                const _RankingList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- Background ----------------------
class _PurpleBackground extends StatelessWidget {
  const _PurpleBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF9269FF), // top
            Color(0xFF7C4DFF), // bottom
          ],
        ),
      ),
      child: Stack(
        children: [
          // Soft circular bubbles
          Positioned(
            left: -30,
            top: 60,
            child: _bubble(140, 0.10),
          ),
          Positioned(
            right: -20,
            top: 40,
            child: _bubble(90, 0.14),
          ),
          Positioned(
            right: 40,
            top: 180,
            child: _bubble(60, 0.10),
          ),
          Positioned(
            left: 20,
            top: 220,
            child: _bubble(40, 0.12),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double s, double o) => Container(
    width: s,
    height: s,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(o),
      shape: BoxShape.circle,
    ),
  );
}

// ---------------------- Frosted small controls ----------------------
class _FrostIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _FrostIcon({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return _FrostCircle(
      onTap: onTap,
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _FrostCircle extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _FrostCircle({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

// ---------------------- Tabs ----------------------
class _Tabs extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  const _Tabs({required this.labels, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final bool active = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: active ? const Color(0xFF7C4DFF) : Colors.white,
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

// ---------------------- Podium Section ----------------------
class _PodiumSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<LeaderboardController>();
    final p2 = c.top[0]; // left
    final p1 = c.top[1]; // center
    final p3 = c.top[2]; // right

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        height: 260,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Left (2)
            _PodiumCard(
              name: p2.name,
              place: 2,
              points: p2.score,
              height: 150,
              shade: 0.28,
              topAvatarOffset: 6,
            ),
            const SizedBox(width: 10),
            // Center (1) with crown
            Stack(
              alignment: Alignment.topCenter,
              children: [
                _PodiumCard(
                  name: p1.name,
                  place: 1,
                  points: p1.score,
                  height: 190,
                  shade: 0.40,
                  topAvatarOffset: -2,
                  isCenter: true,
                ),
                Positioned(
                  top: -2,
                  child: Icon(Icons.workspace_premium_rounded,
                      color: const Color(0xFFFFE066), size: 22),
                ),
              ],
            ),
            const SizedBox(width: 10),
            // Right (3)
            _PodiumCard(
              name: p3.name,
              place: 3,
              points: p3.score,
              height: 130,
              shade: 0.22,
              topAvatarOffset: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final String name;
  final int place;
  final int points;
  final double height;
  final double shade;
  final bool isCenter;
  final double topAvatarOffset;
  const _PodiumCard({
    required this.name,
    required this.place,
    required this.points,
    required this.height,
    required this.shade,
    this.isCenter = false,
    this.topAvatarOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = Colors.white.withOpacity(shade);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Avatar and name
          Transform.translate(
            offset: Offset(0, topAvatarOffset),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Text(
                    name.isEmpty ? '?' : name[0],
                    style: const TextStyle(
                        color: Color(0xFF7C4DFF), fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Bar with big number and score
          Container(
            height: height,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$place',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCenter ? 64 : 46,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                _ScoreSmall(points: points),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreSmall extends StatelessWidget {
  final int points;
  const _ScoreSmall({required this.points});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: points.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 4)),
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: Text(
                'pt',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- Ranking List ----------------------
class _RankingList extends StatelessWidget {
  const _RankingList();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LeaderboardController>();
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 8, bottom: 12),
          itemCount: c.rows.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0EAFE)),
          itemBuilder: (context, i) {
            final u = c.rows[i];
            return ListTile(
              leading: Text(
                u.rank.toString().padLeft(2, '0'),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFF1ECFF),
                    child: Text(
                      u.name[0],
                      style: const TextStyle(
                          color: Color(0xFF7C4DFF), fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(u.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: u.score.toString(),
                        style: const TextStyle(
                          color: Color(0xFF7C4DFF),
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 2)),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(0, -2),
                          child: const Text(
                            'pt',
                            style: TextStyle(
                              color: Color(0xFF7C4DFF),
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            );
          },
        ),
      ),
    );
  }
}
