import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pasal_pro/core/database/database_service.dart';
import 'package:pasal_pro/core/utils/result.dart';
import 'package:pasal_pro/features/cheques/data/datasources/cheque_local_datasource_impl.dart';
import 'package:pasal_pro/features/cheques/data/repositories/cheque_repository_impl.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/domain/usecases/add_cheque.dart';
import 'package:pasal_pro/features/cheques/domain/usecases/delete_cheque.dart';
import 'package:pasal_pro/features/cheques/domain/usecases/get_all_cheques.dart';
import 'package:pasal_pro/features/cheques/domain/usecases/get_cheques_by_status.dart';
import 'package:pasal_pro/features/cheques/domain/usecases/update_cheque_status.dart';

// ─────────────────────────────────────────────────────────────────────────
// Database & Repository Providers
// ─────────────────────────────────────────────────────────────────────────

/// Provides DatabaseService instance
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});

/// Provides Isar instance from database
final isarProvider = FutureProvider<Isar>((ref) async {
  final dbService = ref.watch(databaseServiceProvider);
  return dbService.database;
});

/// Provides cheque repository instance
final chequeRepositoryProvider = FutureProvider((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final localDataSource = ChequeLocalDataSourceImpl(isar);
  return ChequeRepositoryImpl(localDataSource);
});

// ─────────────────────────────────────────────────────────────────────────
// Use Case Providers
// ─────────────────────────────────────────────────────────────────────────

final addChequeUseCaseProvider = FutureProvider((ref) async {
  final repository = await ref.watch(chequeRepositoryProvider.future);
  return AddCheque(repository);
});

final getAllChequesUseCaseProvider = FutureProvider((ref) async {
  final repository = await ref.watch(chequeRepositoryProvider.future);
  return GetAllCheques(repository);
});

final updateChequeStatusUseCaseProvider = FutureProvider((ref) async {
  final repository = await ref.watch(chequeRepositoryProvider.future);
  return UpdateChequeStatus(repository);
});

final deleteChequeUseCaseProvider = FutureProvider((ref) async {
  final repository = await ref.watch(chequeRepositoryProvider.future);
  return DeleteCheque(repository);
});

final getChequesByStatusUseCaseProvider = FutureProvider((ref) async {
  final repository = await ref.watch(chequeRepositoryProvider.future);
  return GetChequesByStatus(repository);
});

// ─────────────────────────────────────────────────────────────────────────
// State Providers
// ─────────────────────────────────────────────────────────────────────────

/// Provides all cheques, sorted by due date
final allChequesProvider = FutureProvider<List<Cheque>>((ref) async {
  final useCase = await ref.watch(getAllChequesUseCaseProvider.future);
  final result = await useCase.call();

  return result.fold(
    onSuccess: (cheques) => cheques,
    onError: (failure) => throw Exception(failure.toString()),
  );
});

/// Provides cheques filtered by status
/// Status can be: 'all', 'pending', 'cleared', 'overdue', 'due_soon'
final filteredChequesProvider = FutureProvider.family<List<Cheque>, String>((
  ref,
  status,
) async {
  final useCase = await ref.watch(getChequesByStatusUseCaseProvider.future);

  if (status == 'all') {
    final allCheques = await ref.watch(allChequesProvider.future);
    return allCheques;
  }

  final result = await useCase.call(status);

  return result.fold(
    onSuccess: (cheques) => cheques,
    onError: (failure) => throw Exception(failure.toString()),
  );
});

/// Current selected filter status
final selectedChequeFilterProvider = StateProvider<String>((ref) => 'all');

/// Display-ready filtered cheques with current filter
final displayChequesProvider = FutureProvider<List<Cheque>>((ref) async {
  final filter = ref.watch(selectedChequeFilterProvider);
  return ref
      .watch(filteredChequesProvider(filter))
      .when(
        data: (data) => data,
        loading: () => [],
        error: (error, stack) => [],
      );
});

// ─────────────────────────────────────────────────────────────────────────
// Action Providers
// ─────────────────────────────────────────────────────────────────────────

/// Add a new cheque and refresh the list
final addNewChequeProvider = FutureProvider.family<void, Cheque>((
  ref,
  cheque,
) async {
  final useCase = await ref.watch(addChequeUseCaseProvider.future);
  final result = await useCase.call(cheque);

  result.fold(
    onSuccess: (_) {
      // Refresh the all cheques list
      ref.invalidate(allChequesProvider);
      ref.invalidate(displayChequesProvider);
    },
    onError: (failure) {
      throw Exception(failure.toString());
    },
  );
});

/// Update cheque status and refresh the list
final updateStatusProvider = FutureProvider.family<void, (int, String)>((
  ref,
  params,
) async {
  final useCase = await ref.watch(updateChequeStatusUseCaseProvider.future);
  final (id, newStatus) = params;
  final result = await useCase.call(id, newStatus);

  result.fold(
    onSuccess: (_) {
      // Refresh the lists
      ref.invalidate(allChequesProvider);
      ref.invalidate(displayChequesProvider);
    },
    onError: (failure) {
      throw Exception(failure.toString());
    },
  );
});

/// Delete cheque and refresh the list
final deleteChequeProvider = FutureProvider.family<void, int>((ref, id) async {
  final useCase = await ref.watch(deleteChequeUseCaseProvider.future);
  final result = await useCase.call(id);

  result.fold(
    onSuccess: (_) {
      // Refresh the lists
      ref.invalidate(allChequesProvider);
      ref.invalidate(displayChequesProvider);
    },
    onError: (failure) {
      throw Exception(failure.toString());
    },
  );
});
