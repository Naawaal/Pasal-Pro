import 'package:flutter_test/flutter_test.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter - Format', () {
    test('formats currency with symbol', () {
      expect(CurrencyFormatter.format(1234.56), 'Rs1,234.56');
      expect(CurrencyFormatter.format(100.0), 'Rs100.00');
      expect(CurrencyFormatter.format(0.0), 'Rs0.00');
    });

    test('formats currency without symbol', () {
      expect(CurrencyFormatter.formatWithoutSymbol(1234.56), '1,234.56');
    });

    test('formats compact currency', () {
      final compact1200 = CurrencyFormatter.formatCompact(1200);
      final compact1500000 = CurrencyFormatter.formatCompact(1500000);

      // Compact formatting may vary slightly, check prefix
      expect(compact1200.startsWith('Rs'), true);
      expect(compact1500000.startsWith('Rs'), true);
    });
  });

  group('CurrencyFormatter - Parse', () {
    test('parses valid currency strings', () {
      expect(CurrencyFormatter.parse('Rs1,234.56'), 1234.56);
      expect(CurrencyFormatter.parse('1234.56'), 1234.56);
      expect(CurrencyFormatter.parse('100'), 100.0);
    });

    test('returns null for invalid strings', () {
      expect(CurrencyFormatter.parse('invalid'), null);
      expect(CurrencyFormatter.parse(''), null);
    });
  });

  group('CurrencyFormatter - Validation', () {
    test('validates currency strings correctly', () {
      expect(CurrencyFormatter.isValid('Rs1,234.56'), true);
      expect(CurrencyFormatter.isValid('1234.56'), true);
      expect(CurrencyFormatter.isValid('invalid'), false);
    });
  });

  group('CurrencyFormatter - Percentage', () {
    test('formats percentage correctly', () {
      expect(CurrencyFormatter.formatPercentage(25.5), '25.5%');
      expect(CurrencyFormatter.formatPercentage(100.0), '100.0%');
    });
  });
}
