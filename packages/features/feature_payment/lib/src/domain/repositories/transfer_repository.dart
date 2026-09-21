// packages/features/feature_payment/lib/src/domain/repositories/transfer_repository.dart

import "package:core_network/core_network.dart";
import "package:fpdart/fpdart.dart";
import "../entities/transfer_receipt.dart";
import "../value_objects/money.dart";

abstract class TransferRepository {
  Future<Either<Failure, TransferReceipt>> executeTransfer({
    required String sourceAccountId,
    required String targetAccountId,
    required Money amount,
  });
}

