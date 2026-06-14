// lib/screens/movie_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/movie_provider.dart';
import '../models/showtime_model.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/app_widgets.dart';
import 'seat_selection_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final mp = context.read<MovieProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mp.loadMovie(widget.movieId);
      mp.loadShowtimes(widget.movieId, Formatters.dateForApi(_selectedDate));
    });
  }

  void _onDateChanged(DateTime date) {
    setState(() => _selectedDate = date);
    context.read<MovieProvider>().loadShowtimes(widget.movieId, Formatters.dateForApi(date));
  }

  Future<void> _openTrailer(String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phim này chưa có trailer')),
      );
      return;
    }

    final uri = Uri.parse(url);

    final success = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở trailer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (_, mp, __) {
        final movie = mp.selectedMovie;
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                backgroundColor: AppTheme.background,
                flexibleSpace: FlexibleSpaceBar(
                  background: movie?.posterUrl != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(imageUrl: movie!.posterUrl!, fit: BoxFit.cover),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, AppTheme.background.withOpacity(0.6), AppTheme.background],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(color: AppTheme.surfaceLight),
                ),
              ),
              if (mp.loading && movie == null)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppTheme.primary)))
              else if (movie != null) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 12),
        Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
        if (movie.ageRating != null)
        _tag(movie.ageRating!, AppTheme.primary),

        if (movie.duration != null)
        _tag('⏱ ${Formatters.duration(movie.duration!)}', AppTheme.surfaceLight),

        if (movie.trailerUrl != null && movie.trailerUrl!.isNotEmpty)
        _trailerTag(movie.trailerUrl!),

        if (movie.genre != null)
        _tag(movie.genre!, AppTheme.surfaceLight),
        ],
        ),
                        if (movie.description != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            movie.description!,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              height: 1.6,
                              fontSize: 14,
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),
                        const SectionTitle('Chọn ngày'),
                        _DatePicker(selected: _selectedDate, onChanged: _onDateChanged),
                        const SizedBox(height: 24),
                        const SectionTitle('Lịch chiếu'),
                      ],
                    ),
                  ),
                ),
                _ShowtimeSection(mp: mp),
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _trailerTag(String url) {
    return GestureDetector(
      onTap: () => _openTrailer(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 13,
            ),
            SizedBox(width: 4),
            Text(
              'Trailer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _DatePicker extends StatelessWidget {
  final DateTime selected;
  final Function(DateTime) onChanged;

  const _DatePicker({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (_, i) {
          final date = DateTime.now().add(Duration(days: i));
          final isSelected = date.year == selected.year && date.month == selected.month && date.day == selected.day;
          final days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
          return GestureDetector(
            onTap: () => onChanged(date),
            child: Container(
              width: 56,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: const Color(0xFF2A2A4A)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(days[date.weekday % 7], style: TextStyle(color: isSelected ? Colors.white : AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('${date.day}', style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShowtimeSection extends StatelessWidget {
  final MovieProvider mp;
  const _ShowtimeSection({required this.mp});

  @override
  Widget build(BuildContext context) {
    if (mp.loading) {
      return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator(color: AppTheme.primary))));
    }
    final cinemas = mp.showtimes?.cinemas ?? [];
    if (cinemas.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('Không có suất chiếu nào.', style: TextStyle(color: AppTheme.textSecondary))),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => _CinemaCard(cinema: cinemas[i]),
        childCount: cinemas.length,
      ),
    );
  }
}

class _CinemaCard extends StatelessWidget {
  final CinemaShowtime cinema;
  const _CinemaCard({required this.cinema});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppTheme.primary, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text(cinema.cinemaName, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15))),
            ],
          ),
          if (cinema.cinemaAddress != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(cinema.cinemaAddress!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ],
          const SizedBox(height: 12),
          ...cinema.rooms.map((room) => _RoomRow(room: room)),
        ],
      ),
    );
  }
}

class _RoomRow extends StatelessWidget {
  final RoomShowtime room;
  const _RoomRow({required this.room});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(room.roomName, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: room.showtimes.map((st) => _ShowtimeChip(showtime: st)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ShowtimeChip extends StatelessWidget {
  final ShowtimeInfo showtime;
  const _ShowtimeChip({required this.showtime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SeatSelectionScreen(
            showtimeId: showtime.showtimeId,
            price: showtime.price,
            startTime: showtime.startTime,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(Formatters.timeVN(showtime.startTime), style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(Formatters.currency(showtime.price), style: const TextStyle(color: AppTheme.primary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
