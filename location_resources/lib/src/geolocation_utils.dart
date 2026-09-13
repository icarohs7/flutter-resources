import 'package:geolocator/geolocator.dart';
import 'package:reactor_fp_resources/reactor_fp_resources.dart';

/// Reads the device location through [Geolocator].
///
/// The failure callbacks keep the package independent from an application's
/// failure hierarchy. Use them to translate plugin failures into the type
/// used by the calling application.
abstract class GeolocationUtils() {
  /// Returns the current latitude and longitude.
  ///
  /// When [askPermission] is true, permission is checked before requesting a
  /// position. [onDenied] receives a message when the permission remains
  /// denied, [onServiceDisabled] receives a message when location services are
  /// disabled, and [onError] translates plugin exceptions.
  static TaskEither<F, LocationTuple> getCurrentLocation<F>({
    bool askPermission = true,
    required F Function(String message) onDenied,
    required F Function(String message) onServiceDisabled,
    required F Function(Object error, StackTrace stackTrace) onError,
  }) {
    final location = TaskEither.tryCatch(() async {
      final LocationSettings settings = .new(accuracy: .high);
      final position = await Geolocator.getCurrentPosition(locationSettings: settings);
      return (lat: position.latitude, lng: position.longitude);
    }, onError);

    if (!askPermission) return location;

    return askForLocationPermission<F>(
      onServiceDisabled: onServiceDisabled,
      onError: onError,
    ).flatMap(
      (permission) => permission.isDenied
          ? TaskEither.left(onDenied('Location permission was denied.'))
          : location,
    );
  }

  /// Checks location services and requests permission when needed.
  ///
  /// A denied permission is returned as a successful [LocationPermission]
  /// value so callers can decide how to present the permission state.
  static TaskEither<F, LocationPermission> askForLocationPermission<F>({
    required F Function(String message) onServiceDisabled,
    required F Function(Object error, StackTrace stackTrace) onError,
  }) {
    final serviceEnabled = TaskEither.tryCatch(Geolocator.isLocationServiceEnabled, onError);

    return serviceEnabled.flatMap((enabled) {
      if (!enabled) {
        return TaskEither.left(onServiceDisabled('Location services are disabled.'));
      }

      return TaskEither.tryCatch(() async {
        var permission = await Geolocator.checkPermission();
        if (permission.isDenied) {
          permission = await Geolocator.requestPermission();
        }
        return permission;
      }, onError);
    });
  }

  /// Requests permission and collapses failures to [LocationPermission.denied].
  static Task<LocationPermission> askForLocationPermissionValue<F>({
    required F Function(String message) onServiceDisabled,
    required F Function(Object error, StackTrace stackTrace) onError,
  }) => askForLocationPermission<F>(
    onServiceDisabled: onServiceDisabled,
    onError: onError,
  ).match((_) => LocationPermission.denied, (permission) => permission);

  /// Returns whether the device location service is enabled.
  static Task<bool> isLocationServiceEnabled() => Task(Geolocator.isLocationServiceEnabled);
}

/// Latitude and longitude returned by [GeolocationUtils.getCurrentLocation].
typedef LocationTuple = ({double lat, double lng});

/// Convenience checks for permission states returned by [Geolocator].
extension LocationPermissionX on LocationPermission {
  /// Whether the permission is denied or permanently denied.
  bool get isDenied =>
      this == LocationPermission.denied || this == LocationPermission.deniedForever;

  /// Whether the permission is not denied.
  bool get isNotDenied => !isDenied;
}
