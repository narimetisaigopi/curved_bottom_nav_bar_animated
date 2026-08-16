import 'package:curved_bottom_nav_bar/curved_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders all items and reports taps', (tester) async {
    var tapped = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CurvedBottomNavBar(
            currentIndex: 0,
            onTap: (i) => tapped = i,
            items: const [
              CurvedBottomNavItem(icon: Icons.call),
              CurvedBottomNavItem(icon: Icons.home_outlined),
              CurvedBottomNavItem(icon: Icons.chat_outlined),
            ],
          ),
        ),
      ),
    );

    // The active item's icon renders twice: hidden in the row and in the
    // floating bubble. Inactive items render once each.
    expect(find.byIcon(Icons.call), findsNWidgets(2));
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.chat_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chat_outlined));
    expect(tapped, 2);
  });

  test('requires at least two items', () {
    expect(
      () => CurvedBottomNavBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [CurvedBottomNavItem(icon: Icons.home)],
      ),
      throwsAssertionError,
    );
  });
}
