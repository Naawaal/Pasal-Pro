import 'package:equatable/equatable.dart';

/// Base class for all failures in the app
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

/// Database-related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code, super.details});
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code, super.details});
}

/// Printer-related failures
class PrinterFailure extends Failure {
  const PrinterFailure({required super.message, super.code, super.details});
}

/// Backup/Cloud-related failures
class BackupFailure extends Failure {
  const BackupFailure({required super.message, super.code, super.details});
}

/// Business logic failures
class BusinessFailure extends Failure {
  const BusinessFailure({required super.message, super.code, super.details});
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code, super.details});
}
