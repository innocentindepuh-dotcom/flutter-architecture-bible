// packages/features/feature_payment/lib/src/data/repositories/transfer_repository_impl.dart

import "package:core_network/core_network.dart";
import "package:fpdart/fpdart.dart";
import "../../domain/entities/transfer_receipt.dart";
import "../../domain/repositories/transfer_repository.dart";
import "../../domain/value_objects/money.dart";
import "../datasources/transfer_remote_datasource.dart";

class TransferRepositoryImpl implements TransferRepository {
  final TransferRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const TransferRepositoryImpl({
    required TransferRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, TransferReceipt>> executeTransfer({
    required String sourceAccountId,
    required String targetAccountId,
    required Money amount,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: "No active internet connection available. Operation aborted."),
      );
    }

    try {
      final model = await _remoteDataSource.postTransfer(
        sourceId: sourceAccountId,
        targetId: targetAccountId,
        amount: amount.amount,
        currency: amount.currency,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: "Unexpected processing error during transaction: $e"),
      );
    }
  }
}

