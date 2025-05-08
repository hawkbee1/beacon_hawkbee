import 'package:beacon_hawkbee/beacon_hawkbee.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late Beacon beacon;

    setUp(() async {
      // Initialize Beacon SDK with test app metadata
      beacon = await Beacon.init(
        appMetadata: AppMetadata(
          name: 'Test App',
          iconUrl: '',
          url: 'https://test.app',
        ),
      );
    });

    test('First Test', () {
      expect(beacon.appMetadata.name, equals('Test App'));
    });
  });
}
