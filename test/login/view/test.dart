import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class A {
  final B b;
  final String state;

  A(this.state, this.b);

  String calc() {
    b.calculate();
    return 'abcc';
  }
}

class B {
  void calculate() {
    debugPrint('1333' + '');
  }
}

class MockA extends Mock implements A {}

void main() {
  A mockA = MockA();
  when(() => mockA.calc()).thenReturn('abc');
  test('test', () {
    expect(mockA, isA<A>());
  });
}
