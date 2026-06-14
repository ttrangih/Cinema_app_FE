// lib/services/movie_service.dart
import '../models/movie_model.dart';
import '../models/showtime_model.dart';
import '../models/seat_model.dart';
import '../models/booking_model.dart';
import '../models/ticket_model.dart';
import 'api_service.dart';

class MovieService {
  final _api = ApiService();

  Future<List<MovieModel>> getMovies() async {
    final res = await _api.get('/movies');
    final List data = res.data is List
        ? res.data
        : (res.data['items'] ?? res.data['movies'] ?? res.data['data'] ?? []);

    return data
        .map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<MovieModel> getMovie(int id) async {
    final res = await _api.get('/movies/$id');
    final data = res.data is Map ? res.data : res.data['movie'];
    return MovieModel.fromJson(data);
  }

  Future<MovieShowtimes> getShowtimes(int movieId, String date) async {
    final res = await _api.get('/movies/$movieId/showtimes', params: {'date': date});
    return MovieShowtimes.fromJson(res.data);
  }

  Future<List<SeatModel>> getSeats(int showtimeId) async {
    final res = await _api.get('/showtimes/$showtimeId/seats');
    final List data = res.data is List ? res.data : (res.data['seats'] ?? res.data['data'] ?? []);
    return data.map((e) => SeatModel.fromJson(e)).toList();
  }

  Future<BookingResult> createBooking(int showtimeId, List<int> seatIds) async {
    final res = await _api.post('/bookings', data: {'showtimeId': showtimeId, 'seatIds': seatIds});
    return BookingResult.fromJson(res.data);
  }

  Future<PaymentResult> createPayment(int bookingId) async {
    final res = await _api.post('/payments/create', data: {'bookingId': bookingId});
    return PaymentResult.fromJson(res.data);
  }

  Future<void> mockPaySuccess(int bookingId) async {
    await _api.post('/payments/mock-success/$bookingId');
  }

  Future<List<TicketModel>> getMyTickets() async {
    final res = await _api.get('/bookings/my-tickets');
    final List data = res.data['tickets'] ?? [];
    return data.map((e) => TicketModel.fromJson(e)).toList();
  }
}
