import 'package:flutter_test/flutter_test.dart';
import 'package:location_resources/location_resources.dart';

void main() {
  late GeolocatorPlatform originalPlatform;

  setUp(() {
    originalPlatform = GeolocatorPlatform.instance;
  });

  tearDown(() {
    GeolocatorPlatform.instance = originalPlatform;
  });

  test('returns the current location as a tuple', () async {
    GeolocatorPlatform.instance = _FakeGeolocatorPlatform(
      permission: LocationPermission.always,
      position: _position,
    );

    final result = await GeolocationUtils.getCurrentLocation<String>(
      onDenied: (message) => message,
      onServiceDisabled: (message) => message,
      onError: (error, _) => '$error',
    ).run();

    expect(result.match((failure) => failure, (location) => location), (lat: 12.5, lng: -45.25));
  });

  test('returns the denied-permission callback result', () async {
    GeolocatorPlatform.instance = _FakeGeolocatorPlatform(
      permission: LocationPermission.deniedForever,
    );

    final result = await GeolocationUtils.getCurrentLocation<String>(
      onDenied: (message) => message,
      onServiceDisabled: (message) => message,
      onError: (error, _) => '$error',
    ).run();

    expect(
      result.match((failure) => failure, (location) => '$location'),
      'Location permission was denied.',
    );
  });

  test('returns the service-disabled callback result', () async {
    GeolocatorPlatform.instance = _FakeGeolocatorPlatform(serviceEnabled: false);

    final result = await GeolocationUtils.askForLocationPermission<String>(
      onServiceDisabled: (message) => message,
      onError: (error, _) => '$error',
    ).run();

    expect(
      result.match((failure) => failure, (permission) => '$permission'),
      'Location services are disabled.',
    );
  });

  test('returns the plugin-error callback result', () async {
    GeolocatorPlatform.instance = _FakeGeolocatorPlatform(
      permission: LocationPermission.always,
      positionError: StateError('location unavailable'),
    );

    final result = await GeolocationUtils.getCurrentLocation<String>(
      onDenied: (message) => message,
      onServiceDisabled: (message) => message,
      onError: (error, _) => '$error',
    ).run();

    expect(
      result.match((failure) => failure, (location) => '$location'),
      'Bad state: location unavailable',
    );
  });
}

final _position = Position(
  latitude: 12.5,
  longitude: -45.25,
  timestamp: DateTime(2026),
  accuracy: 1,
  altitude: 2,
  altitudeAccuracy: 3,
  heading: 4,
  headingAccuracy: 5,
  speed: 6,
  speedAccuracy: 7,
);

class _FakeGeolocatorPlatform({
  final bool serviceEnabled = true,
  final LocationPermission permission = LocationPermission.denied,
  final Position? position,
  final Object? positionError,
}) extends GeolocatorPlatform {
  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) async {
    if (positionError != null) throw positionError!;
    return position!;
  }
}
