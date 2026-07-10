import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GlobalKey<NavigatorState> navigatorKey;
  late Widget defaultApp;
  setUp(() {
    navigatorKey = GlobalKey<NavigatorState>();
    defaultApp = MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Container(),
      ),
    );
  });

  testWidgets('should return scaffoldMessenger', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    expect(context.scaffoldMessenger, isA<ScaffoldMessengerState>());
    expect(context.scaffoldMessenger, ScaffoldMessenger.of(context));
  });

  testWidgets('should show snackbar', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    final snackBar = SnackBar(content: Text('test'));
    final scaffoldFeatureController = context.showSnackbar(snackBar);
    expect(
      scaffoldFeatureController,
      isA<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>(),
    );
  });

  testWidgets('should remove and hide current snackbar', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    context.showSnackbar(const SnackBar(content: Text('to-remove')));
    await tester.pump();
    expect(find.text('to-remove'), findsOneWidget);

    context.removeCurrentSnackBar();
    await tester.pump();
    expect(find.text('to-remove'), findsNothing);

    context.showSnackbar(const SnackBar(content: Text('to-hide')));
    await tester.pump();
    expect(find.text('to-hide'), findsOneWidget);

    context.hideCurrentSnackBar();
    await tester.pumpAndSettle();
    expect(find.text('to-hide'), findsNothing);
  });

  testWidgets('should return if system is on dark mode', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    expect(context.isSystemDarkTheme, isA<bool>());
    expect(context.isSystemDarkTheme, MediaQuery.of(context).platformBrightness == Brightness.dark);
  });

  testWidgets('should return if theme is on dark mode', (tester) async {
    await tester.pumpWidget(defaultApp);

    final context = navigatorKey.currentContext!;
    expect(context.isDarkTheme, isA<bool>());
    expect(context.isDarkTheme, Theme.of(context).brightness == Brightness.dark);
  });

  testWidgets('exposes media query and theme values', (tester) async {
    late BuildContext context;
    final theme = ThemeData(
      platform: TargetPlatform.linux,
      primaryColor: Colors.purple,
      scaffoldBackgroundColor: Colors.orange,
    );
    const mediaQueryData = MediaQueryData(
      size: Size(800, 600),
      padding: EdgeInsets.all(8),
      viewPadding: EdgeInsets.all(12),
      viewInsets: EdgeInsets.only(bottom: 24),
      platformBrightness: Brightness.dark,
      devicePixelRatio: 2,
      textScaler: TextScaler.linear(1.5),
      alwaysUse24HourFormat: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: MediaQuery(
          data: mediaQueryData,
          child: Builder(
            builder: (builderContext) {
              context = builderContext;
              return const Scaffold();
            },
          ),
        ),
      ),
    );

    expect(context.mediaQuerySize, mediaQueryData.size);
    expect(context.mediaQueryPadding, mediaQueryData.padding);
    expect(context.mediaQueryViewPadding, mediaQueryData.viewPadding);
    expect(context.mediaQueryViewInsets, mediaQueryData.viewInsets);
    expect(context.platformBrightness, Brightness.dark);
    expect(context.devicePixelRatio, 2);
    expect(context.alwaysUse24HourFormat, isTrue);
    expect(context.textScaler, mediaQueryData.textScaler);
    expect(context.textScaleFactor, 1.5);
    expect(context.mediaQueryShortestSide, 600);
    expect(context.isLandscape, isTrue);
    expect(context.isPortrait, isFalse);
    expect(context.isSmallTablet, isTrue);
    expect(context.theme, Theme.of(context));
    expect(context.textTheme, Theme.of(context).textTheme);
    expect(context.primaryTextTheme, Theme.of(context).primaryTextTheme);
    expect(context.backgroundColor, theme.colorScheme.surface);
    expect(context.primaryColor, Colors.purple);
    expect(context.scaffoldBackgroundColor, Colors.orange);
    expect(context.appBarTheme, theme.appBarTheme);
    expect(context.bottomAppBarTheme, theme.bottomAppBarTheme);
    expect(context.bottomSheetTheme, theme.bottomSheetTheme);
    expect(context.platform, TargetPlatform.linux);
    expect(context.isLinux, isTrue);
    expect(context.isAndroid, isFalse);
    expect(context.headline1, Theme.of(context).textTheme.displayLarge);
    expect(context.bodyText1, Theme.of(context).textTheme.bodyLarge);
    expect(context.caption, Theme.of(context).textTheme.bodySmall);
  });

  testWidgets('classifies device breakpoints by shortest side', (tester) async {
    Future<BuildContext> pumpWithSize(Size size) async {
      late BuildContext context;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: size),
          child: Builder(
            builder: (builderContext) {
              context = builderContext;
              return const SizedBox();
            },
          ),
        ),
      );
      return context;
    }

    final phone = await pumpWithSize(const Size(599, 800));
    expect(phone.isPhone, isTrue);
    expect(phone.isSmallTablet, isFalse);
    expect(phone.isLargeTablet, isFalse);
    expect(phone.isPortrait, isTrue);
    expect(phone.isLandscape, isFalse);

    final smallTablet = await pumpWithSize(const Size(600, 800));
    expect(smallTablet.isPhone, isFalse);
    expect(smallTablet.isSmallTablet, isTrue);
    expect(smallTablet.isLargeTablet, isFalse);

    final largeTablet = await pumpWithSize(const Size(720, 1024));
    expect(largeTablet.isPhone, isFalse);
    expect(largeTablet.isSmallTablet, isTrue);
    expect(largeTablet.isLargeTablet, isTrue);
  });

  testWidgets('delegates navigator helpers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/': (_) => const Scaffold(body: Text('home')),
          '/next': (_) => const Scaffold(body: Text('next')),
        },
      ),
    );

    final BuildContext context = tester.element(find.text('home'));

    expect(context.canPop(), isFalse);

    context.pushNamed('/next');
    await tester.pumpAndSettle();
    expect(find.text('next'), findsOneWidget);
    expect(tester.element(find.text('next')).canPop(), isTrue);

    tester.element(find.text('next')).pop();
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);

    tester.element(find.text('home')).push(
          MaterialPageRoute<String?>(builder: (_) => const Scaffold(body: Text('pushed'))),
        );
    await tester.pumpAndSettle();
    expect(find.text('pushed'), findsOneWidget);

    tester.element(find.text('pushed')).pop<String?>(null);
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);

    tester.element(find.text('home')).pushNamed('/next');
    await tester.pumpAndSettle();
    tester.element(find.text('next')).popUntil((route) => route.isFirst);
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    expect(find.text('next'), findsNothing);
  });

  testWidgets('delegates form and focus scope operations', (tester) async {
    late BuildContext context;
    var saved = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: Builder(
              builder: (builderContext) {
                context = builderContext;
                return TextFormField(
                  initialValue: 'value',
                  validator: (value) => value == null ? 'required' : null,
                  onSaved: (_) => saved = true,
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(context.form.validate(), isTrue);
    context.form.save();
    expect(saved, isTrue);
    context.form.reset();
    expect(context.focusScope.canRequestFocus, isTrue);
    context.focusScope.unfocus();
    context.closeKeyboard();
  });

  testWidgets('exposes modal route and snackbar helpers', (tester) async {
    late BuildContext context;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (builderContext) {
              context = builderContext;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(context.modalRoute, isNotNull);
    expect(context.routeSettings, context.modalRoute?.settings);

    context.showSnackbar(const SnackBar(content: Text('message')));
    await tester.pump();
    expect(find.text('message'), findsOneWidget);
  });

  testWidgets('opens drawers and shows bottom sheet', (tester) async {
    late BuildContext bodyContext;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          drawer: const Drawer(child: Text('start-drawer')),
          endDrawer: const Drawer(child: Text('end-drawer')),
          body: Builder(
            builder: (context) {
              bodyContext = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    bodyContext.openDrawer();
    await tester.pumpAndSettle();
    expect(find.text('start-drawer'), findsOneWidget);

    Navigator.of(bodyContext).pop();
    await tester.pumpAndSettle();

    bodyContext.openEndDrawer();
    await tester.pumpAndSettle();
    expect(find.text('end-drawer'), findsOneWidget);

    Navigator.of(bodyContext).pop();
    await tester.pumpAndSettle();

    bodyContext.showBottomSheet((_) => const Text('bottom-sheet'));
    await tester.pumpAndSettle();
    expect(find.text('bottom-sheet'), findsOneWidget);
  });
}
