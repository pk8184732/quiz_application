import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:quiz_application/utils/colors.dart';
import 'leaderboard_controller.dart';
import '../../mode/user_stats_model.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LeaderboardController());
    return Scaffold(
      body: Stack(
        children: [
          const _PurpleBackground(),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: c.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 25,
              maxBlastForce: 20,
              minBlastForce: 8,
              gravity: 0.2,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _FrostIcon(
                        icon: Icons.arrow_back,
                        onTap: () {
                          Get.back();
                        },
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
                Obx(() {
                  if (c.top3.length < 3) return const SizedBox();
                  return _PodiumSection(top3: c.top3);
                }),

                // List
                const SizedBox(height: 14),
                Expanded(
                  child: _RankingList(rest: c.rest),
                ),
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
            darkRed,
            lightRed,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(left: -30, top: 60, child: _bubble(140, 0.10)),
          Positioned(right: -20, top: 40, child: _bubble(90, 0.14)),
          Positioned(right: 40, top: 180, child: _bubble(60, 0.10)),
          Positioned(left: 20, top: 220, child: _bubble(40, 0.12)),
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

// ---------------------- Frost Controls ----------------------
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
  const _Tabs(
      {required this.labels, required this.index, required this.onChanged});

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
                      color: active ? darkRed : Colors.white,
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

// ---------------------- Podium ----------------------
class _PodiumSection extends StatelessWidget {
  final List<UserStatsModel> top3;
  const _PodiumSection({required this.top3});

  @override
  Widget build(BuildContext context) {
    final p2 = top3[0];
    final p1 = top3[1];
    final p3 = top3[2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        height: 260,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _PodiumCard(
              name: p2.name,
              place: 2,
              points: p2.totalPoints,
              height: 140,
              shade: 0.28,
              topAvatarOffset: 4,
            ),
            const SizedBox(width: 10),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                _PodiumCard(
                  name: p1.name,
                  place: 1,
                  points: p1.totalPoints,
                  height: 170,
                  shade: 0.40,
                  topAvatarOffset: -2,
                  isCenter: true,
                ),
                Positioned(
                  top: -2,
                  child: Icon(Icons.workspace_premium_sharp,
                      color: Colors.deepOrangeAccent, size: 32),
                ),
              ],
            ),
            const SizedBox(width: 10),
            _PodiumCard(
              name: p3.name,
              place: 3,
              points: p3.totalPoints,
              height: 120,
              shade: 0.22,
              topAvatarOffset: 5,
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
                        color: darkRed, fontWeight: FontWeight.w800),
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
          Container(
            height: height,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(14),
            ),
            padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
  final List<UserStatsModel> rest;
  const _RankingList({required this.rest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        itemCount: rest.length,
        separatorBuilder: (_, __) =>
        const Divider(height: 1, color: Color(0xFFF0EAFE)),
        itemBuilder: (context, i) {
          final u = rest[i];
          return ListTile(
            leading: Text(
              (i + 4).toString().padLeft(2, '0'), // Rank after top3
              style:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFF1ECFF),
                  child: Text(
                    u.name[0],
                    style: const TextStyle(
                        color: darkRed, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 10),
                Text(u.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            trailing: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: u.totalPoints.toString(),
                      style: const TextStyle(
                        color: darkRed,
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
                            color: darkRed,
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
    );
  }
}
