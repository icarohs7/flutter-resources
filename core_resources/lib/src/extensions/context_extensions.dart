import 'package:flutter/material.dart';

extension CRContextExtensions on BuildContext {
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(SnackBar snackBar) {
    return scaffoldMessenger.showSnackBar(snackBar);
  }

  void removeCurrentSnackBar({SnackBarClosedReason reason = SnackBarClosedReason.remove}) {
    scaffoldMessenger.removeCurrentSnackBar(reason: reason);
  }

  void hideCurrentSnackBar({SnackBarClosedReason reason = SnackBarClosedReason.hide}) {
    scaffoldMessenger.hideCurrentSnackBar(reason: reason);
  }

  bool get isSystemDarkTheme => platformBrightness == Brightness.dark;

  bool get isDarkTheme => theme.brightness == Brightness.dark;
}

extension CRMediaQueryExtensions on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;

  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;

  EdgeInsets get mediaQueryViewPadding => MediaQuery.of(this).viewPadding;

  EdgeInsets get mediaQueryViewInsets => MediaQuery.of(this).viewInsets;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  bool get alwaysUse24HourFormat => MediaQuery.of(this).alwaysUse24HourFormat;

  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;

  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1);

  TextScaler get textScaler => MediaQuery.of(this).textScaler;

  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  bool get isPhone => mediaQueryShortestSide < 600;

  bool get isSmallTablet => mediaQueryShortestSide >= 600;

  bool get isLargeTablet => mediaQueryShortestSide >= 720;
}

extension CRNavigatorExtensions on BuildContext {
  Future<T?> push<T>(Route<T> route) => Navigator.push(this, route);

  void pop<T extends Object?>([T? result]) => Navigator.pop(this, result);

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T?>(this, routeName, arguments: arguments);
  }

  bool canPop() => Navigator.canPop(this);

  void popUntil(RoutePredicate predicate) => Navigator.popUntil(this, predicate);
}

extension CRThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  TextTheme get primaryTextTheme => theme.primaryTextTheme;

  BottomAppBarThemeData get bottomAppBarTheme => theme.bottomAppBarTheme;

  BottomSheetThemeData get bottomSheetTheme => theme.bottomSheetTheme;

  Color get backgroundColor => theme.colorScheme.surface;

  Color get primaryColor => theme.primaryColor;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  AppBarThemeData get appBarTheme => theme.appBarTheme;

  TargetPlatform get platform => theme.platform;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isIOS => platform == TargetPlatform.iOS;

  bool get isMacOS => platform == TargetPlatform.macOS;

  bool get isWindows => platform == TargetPlatform.windows;

  bool get isFuchsia => platform == TargetPlatform.fuchsia;

  bool get isLinux => platform == TargetPlatform.linux;

  TextStyle? get headline1 => textTheme.displayLarge;

  TextStyle? get headline2 => textTheme.displayMedium;

  TextStyle? get headline3 => textTheme.displaySmall;

  TextStyle? get headline4 => textTheme.headlineMedium;

  TextStyle? get headline5 => textTheme.headlineSmall;

  TextStyle? get headline6 => textTheme.titleLarge;

  TextStyle? get subtitle1 => textTheme.titleMedium;

  TextStyle? get bodyText1 => textTheme.bodyLarge;

  TextStyle? get bodyText2 => textTheme.bodyMedium;

  TextStyle? get caption => textTheme.bodySmall;

  TextStyle? get button => textTheme.labelLarge;

  TextStyle? get subtitle2 => textTheme.titleSmall;

  TextStyle? get overline => textTheme.labelSmall;
}

extension CRScaffoldExtensions on BuildContext {
  void openDrawer() => Scaffold.of(this).openDrawer();

  void openEndDrawer() => Scaffold.of(this).openEndDrawer();

  void showBottomSheet(
    WidgetBuilder builder, {
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehaviour,
  }) {
    Scaffold.of(this).showBottomSheet(
      builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehaviour,
    );
  }
}

class _Form {
  const _Form(this._context);

  final BuildContext _context;

  bool validate() => Form.of(_context).validate();

  void reset() => Form.of(_context).reset();

  void save() => Form.of(_context).save();
}

extension CRFormExtensions on BuildContext {
  _Form get form => _Form(this);
}

class _FocusScope {
  const _FocusScope(this._context);

  final BuildContext _context;

  FocusScopeNode get _node => FocusScope.of(_context);

  bool get hasFocus => _node.hasFocus;

  bool get isFirstFocus => _node.isFirstFocus;

  bool get hasPrimaryFocus => _node.hasPrimaryFocus;

  bool get canRequestFocus => _node.canRequestFocus;

  void nextFocus() => _node.nextFocus();

  void requestFocus([FocusNode? node]) => _node.requestFocus(node);

  void previousFocus() => _node.previousFocus();

  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    _node.unfocus(disposition: disposition);
  }

  void setFirstFocus(FocusScopeNode scope) => _node.setFirstFocus(scope);

  bool consumeKeyboardToken() => _node.consumeKeyboardToken();
}

extension CRFocusScopeExtensions on BuildContext {
  _FocusScope get focusScope => _FocusScope(this);

  void closeKeyboard() => focusScope.requestFocus(FocusNode());
}

extension CRModalRouteExtensions<T> on BuildContext {
  ModalRoute<T>? get modalRoute => ModalRoute.of<T>(this);

  RouteSettings? get routeSettings => modalRoute?.settings;
}
