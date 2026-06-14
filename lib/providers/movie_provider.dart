// lib/providers/movie_provider.dart
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import '../models/showtime_model.dart';
import '../models/seat_model.dart';
import '../models/booking_model.dart';
import '../models/ticket_model.dart';
import '../services/movie_service.dart';
import '../services/api_service.dart';

class MovieProvider extends ChangeNotifier {
  final _service = MovieService();

  List<MovieModel> _movies = [];
  List<MovieModel> _filtered = [];
  MovieModel? _selectedMovie;
  MovieShowtimes? _showtimes;
  List<SeatModel> _seats = [];
  BookingResult? _booking;
  List<TicketModel> _tickets = [];

  bool _loading = false;
  String? _error;
  String _query = '';

  List<MovieModel> get movies => _query.isEmpty ? _movies : _filtered;
  MovieModel? get selectedMovie => _selectedMovie;
  MovieShowtimes? get showtimes => _showtimes;
  List<SeatModel> get seats => _seats;
  BookingResult? get booking => _booking;
  List<TicketModel> get tickets => _tickets;
  bool get loading => _loading;
  String? get error => _error;

  List<SeatModel> get selectedSeats => _seats.where((s) => s.isSelected).toList();
  double get totalPrice {
    // price will be from showtime, so we use the seats count * price from booking or calculate later
    return 0;
  }

  void search(String q) {
    _query = q;
    _filtered = _movies.where((m) => m.title.toLowerCase().contains(q.toLowerCase())).toList();
    notifyListeners();
  }

  Future<void> loadMovies() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _movies = await _service.getMovies();
      _loading = false;
      notifyListeners();
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMovie(int id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _selectedMovie = await _service.getMovie(id);
      _loading = false;
      notifyListeners();
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadShowtimes(int movieId, String date) async {
    _loading = true;
    _error = null;
    _showtimes = null;
    notifyListeners();
    try {
      _showtimes = await _service.getShowtimes(movieId, date);
      _loading = false;
      notifyListeners();
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadSeats(int showtimeId) async {
    _loading = true;
    _error = null;
    _seats = [];
    notifyListeners();
    try {
      _seats = await _service.getSeats(showtimeId);
      _loading = false;
      notifyListeners();
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
    }
  }

  void toggleSeat(SeatModel seat) {
    if (seat.isBooked) return;
    if (seat.isSelected) {
      seat.uiStatus = SeatStatus.available;
    } else {
      seat.uiStatus = SeatStatus.selected;
    }
    notifyListeners();
  }

  Future<BookingResult?> createBooking(int showtimeId) async {
    final seatIds = selectedSeats.map((s) => s.seatId).toList();
    if (seatIds.isEmpty) return null;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _booking = await _service.createBooking(showtimeId, seatIds);
      _loading = false;
      notifyListeners();
      return _booking;
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<PaymentResult?> createPayment(int bookingId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _service.createPayment(bookingId);
      _loading = false;
      notifyListeners();
      return result;
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> mockPaySuccess(int bookingId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.mockPaySuccess(bookingId);
      _loading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadTickets() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _tickets = await _service.getMyTickets();
      _loading = false;
      notifyListeners();
    } on DioException catch (e) {
      _error = ApiService().errorMessage(e);
      _loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
