// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/movie_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/movie_card.dart';
import '../widgets/app_widgets.dart';
import 'movie_detail_screen.dart';
import 'my_tickets_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovies();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _tabIndex,
        children: const [_MovieListTab(), MyTicketsScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.movie_outlined), activeIcon: Icon(Icons.movie), label: 'Phim'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), activeIcon: Icon(Icons.confirmation_number), label: 'Vé của tôi'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Tài khoản'),
          ],
        ),
      ),
    );
  }
}

class _MovieListTab extends StatefulWidget {
  const _MovieListTab();

  @override
  State<_MovieListTab> createState() => _MovieListTabState();
}

class _MovieListTabState extends State<_MovieListTab> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MovieProvider>(
        builder: (_, mp, __) {
          return RefreshIndicator(
            color: AppTheme.primary,
            backgroundColor: AppTheme.surfaceLight,
            onRefresh: () => mp.loadMovies(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppTheme.background,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    title: const Text('🎬 Cinema', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppTheme.primary.withOpacity(0.15), AppTheme.background],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: TextField(
                      controller: _searchCtrl,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      onChanged: mp.search,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm phim...',
                        prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  mp.search('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                if (mp.loading)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.primary)))
                else if (mp.error != null)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off, color: AppTheme.textSecondary, size: 48),
                          const SizedBox(height: 12),
                          Text(mp.error!, style: const TextStyle(color: AppTheme.textSecondary), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          TextButton(onPressed: mp.loadMovies, child: const Text('Thử lại', style: TextStyle(color: AppTheme.primary))),
                        ],
                      ),
                    ),
                  )
                else if (mp.movies.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('Không có phim nào.', style: TextStyle(color: AppTheme.textSecondary))),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.58,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => MovieCard(
                          movie: mp.movies[i],
                          onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: mp.movies[i].id))),
                        ),
                        childCount: mp.movies.length,
                      ),
                    ),
                  ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}
