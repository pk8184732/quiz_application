

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/quiz_models.dart';
import 'category_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.86);
  Timer? _autoPageTimer;
  int _currentPage = 0;

  final List<QuizCategory> categories = [
    QuizCategory(
      id: 'gk',
      title: 'General Knowledge',
      imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b',
      isPaid: false,
      color: const Color(0xFF6D5DF6),
    ),
    QuizCategory(
      id: 'sci',
      title: 'Science',
      imageUrl: 'https://images.unsplash.com/photo-1541534401786-3b5c2a1750b2',
      isPaid: true,
      color: const Color(0xFFff7eb3),
    ),
    QuizCategory(
      id: 'math',
      title: 'Mathematics',
      imageUrl: 'https://images.unsplash.com/photo-1518976024611-488f71e5a2b7',
      isPaid: false,
      color: const Color(0xFF00d2ff),
    ),
    QuizCategory(
      id: 'art',
      title: 'Art & Color',
      imageUrl: 'https://images.unsplash.com/photo-1496318447583-f524534e9ce1',
      isPaid: true,
      color: const Color(0xFFf6d365),
    ),
    QuizCategory(
      id: 'skill',
      title: 'Skills',
      imageUrl: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c',
      isPaid: false,
      color: const Color(0xFF84fab0),
    ),
    QuizCategory(
      id: 'history',
      title: 'History',
      imageUrl: 'https://images.unsplash.com/photo-1509228468518-180dd4864904',
      isPaid: false,
      color: const Color(0xFFa18cd1),
    ),
    QuizCategory(
      id: 'tech',
      title: 'Technology',
      imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475',
      isPaid: true,
      color: const Color(0xFF00c6ff),
    ),
    QuizCategory(
      id: 'random',
      title: 'Random Trivia',
      imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40',
      isPaid: false,
      color: const Color(0xFFf093fb),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoPageTimer = Timer.periodic(const Duration(seconds: 3), (t) {
      if (_pageCtrl.hasClients) {
        _currentPage = (_currentPage + 1) % categories.length;
        _pageCtrl.animateToPage(_currentPage, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _autoPageTimer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  // Build category card
  Widget _buildCategoryCard(QuizCategory c) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: c)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [c.color.withOpacity(0.95), c.color.withOpacity(0.65)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(2, 4))],
        ),
        child: Stack(
          children: [
            // background image faded
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Opacity(
                  opacity: 0.15,
                  child: Image.network(c.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // left: text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(c.isPaid ? "Premium - Paid" : "Free", style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text("10 Questions • 5 pts each", style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ),
                  ),
                  // right: image avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(c.imageUrl, width: 96, height: 96, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
            // paid/free tag bottom-left
            Positioned(
              left: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: c.isPaid ? Colors.orangeAccent.withOpacity(0.95) : Colors.greenAccent.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(c.isPaid ? "PAID" : "FREE", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(categories.length, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: (_currentPage == i) ? 12 : 8,
          height: (_currentPage == i) ? 12 : 8,
          decoration: BoxDecoration(
            color: (_currentPage == i) ? Colors.white : Colors.white54,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  // Leaderboard widget
  Widget _buildLeaderboard() {
    // sort copy
    final sorted = List<LeaderboardEntry>.from(gLeaderboard);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    final top3 = sorted.take(3).toList();

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Leaderboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (i) {
              if (i < top3.length) {
                final e = top3[i];
                return Column(children: [
                  CircleAvatar(radius: 28, backgroundColor: Colors.blue[(i + 4) * 100], child: Text("${i + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 6),
                  Text(e.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("${e.score}", style: const TextStyle(color: Colors.grey)),
                ]);
              } else {
                return Column(children: [
                  CircleAvatar(radius: 28, backgroundColor: Colors.grey[300], child: Text("${i + 1}", style: const TextStyle(color: Colors.black))),
                  const SizedBox(height: 6),
                  const Text("—"),
                  const Text("—", style: TextStyle(color: Colors.grey)),
                ]);
              }
            }),
          ),
          const Divider(),
          const Text("Recent Players", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Column(
            children: gLeaderboard.map((e) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(e.name),
              trailing: Text("${e.score} pts"),
              subtitle: Text(DateFormat('dd MMM').format(e.time)),
            )).toList(),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // maintain current page index for dots when manual swipe
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF2C5364)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text("Quizify", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white)),
                ]),
              ),

              // carousel
              SizedBox(
                height: 170,
                child: PageView.builder(
                  controller: _pageCtrl,
                  onPageChanged: (i) => setState(() { _currentPage = i; }),
                  itemCount: categories.length,
                  itemBuilder: (context, idx) {
                    return _buildCategoryCard(categories[idx]);
                  },
                ),
              ),

              const SizedBox(height: 8),
              _buildDots(),

              const SizedBox(height: 12),

              // leaderboard & list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLeaderboard(),
                      const SizedBox(height: 12),
                      const Text("All Quizzes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // grid/list of categories
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 0.95,
                        padding: const EdgeInsets.only(top: 8),
                        children: categories.map((c) {
                          return InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryDetailScreen(category: c))),
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(colors: [c.color.withOpacity(0.95), c.color.withOpacity(0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(c.imageUrl, height: 80, width: double.infinity, fit: BoxFit.cover)),
                                      const SizedBox(height: 8),
                                      Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                      const Spacer(),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)), child: Text(c.isPaid ? "Paid" : "Free", style: const TextStyle(color: Colors.white))),
                                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


