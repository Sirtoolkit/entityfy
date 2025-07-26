import 'package:test/test.dart';
import 'package:entityfy_generator/src/entityfy_generator.dart';

void main() {
  group('CombinedEntityfyGenerator', () {
    test('should be a valid generator', () {
      expect(CombinedEntityfyGenerator, isNotNull);
    });

    test('should create generator instance', () {
      final generator = CombinedEntityfyGenerator();
      expect(generator, isNotNull);
      expect(generator, isA<CombinedEntityfyGenerator>());
    });
  });
}
