# Cinema Booking Mobile App

A mobile cinema ticket booking application built with **Flutter**.
The app allows users to register, log in, browse movies, view movie details, select showtimes, choose seats, create bookings, make mock payments, and view purchased tickets.

## 1. Technologies Used

* Flutter
* Dart
* Dio
* Provider
* Shared Preferences
* Cached Network Image
* URL Launcher
* QR Flutter

## 2. Backend API

The application connects to a backend API deployed on Render:

```txt
https://cinema-be-2-jsnq.onrender.com/api
```

The base URL is configured in:

```txt
lib/utils/app_config.dart
```

## 3. Main Features

### Authentication

* Register a new account
* Log in with email and password
* Store JWT token after login
* Automatically attach token to authenticated API requests
* Log out and clear saved user data

### Movies

* Display movie list
* Search movies
* View movie details
* Open movie trailer
* Select movie date
* Display showtimes by cinema and room

### Seat Selection

* Display seat map by showtime
* Show different seat types: normal and VIP
* Show seat status: available, selected, and booked
* Allow users to select multiple seats
* Calculate total ticket price automatically

### Booking

* Create booking from selected seats
* Hold selected seats for 10 minutes
* Display booking details, selected seats, total price, and countdown timer

### Payment

* Create payment request
* Display payment pending status
* Support mock payment success
* Update booking status to PAID after successful mock payment

### Tickets

* View purchased ticket history
* Display movie title, cinema, room, showtime, selected seats, and payment status
* Generate QR code based on booking ID

### Profile

* Display logged-in user information
* Support logout function

## 4. Project Structure

```txt
lib/
  models/        # Data models
  services/      # API services using Dio
  providers/     # State management using Provider
  screens/       # Application screens
  widgets/       # Reusable UI components
  utils/         # App config, theme, formatters, and helpers
```

## 5. Main Screens

* Splash Screen
* Login Screen
* Register Screen
* Home / Movie List Screen
* Movie Detail Screen
* Seat Selection Screen
* Checkout Screen
* Payment Pending Screen
* Payment Success Screen
* My Tickets Screen
* Profile Screen

## 6. Installation and Setup

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

For Android, make sure the Internet permission is added in:

```txt
android/app/src/main/AndroidManifest.xml
```

Add this line before the `<application>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 7. Data Handling

* Format Vietnamese currency, for example: `90000` → `90.000đ`
* Display showtime in `HH:mm - dd/MM/yyyy` format
* Show loading state when calling APIs
* Show snackbar messages when errors occur
* Automatically log out when the token expires or the API returns 401

## 8. User Interface

The application uses a dark cinema-style theme.
The main color is red combined with a dark background, creating a modern interface suitable for a movie ticket booking app.

## 9. Future Improvements

In the future, the application can be improved with:

* Real payment integration such as MoMo, VNPay, or ZaloPay
* Push notifications when the booking hold time is about to expire
* Movie rating and review features
* Advanced movie search and filtering
* Better QR check-in support
* UI optimization for different screen sizes

## 10. Conclusion

This project successfully builds a mobile frontend for a cinema ticket booking system using Flutter.
The application connects to a real backend API and supports the complete basic booking flow, including browsing movies, selecting showtimes, choosing seats, creating bookings, making mock payments, and viewing purchased tickets.

