import 'package:agrisathi_ai/presentation/providers/dashboard_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('timeGreetingProvider returns valid non-empty greeting string', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final greeting = container.read(timeGreetingProvider);
    expect(greeting, isNotEmpty);
    expect(
      greeting == 'Good Morning' || greeting == 'Good Afternoon' || greeting == 'Good Evening',
      isTrue,
    );
  });
}
