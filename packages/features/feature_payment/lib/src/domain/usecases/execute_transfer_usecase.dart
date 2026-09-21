// packages/features/feature_payment/lib/src/domain/usecases/execute_transfer_usecase.dart

import "package:core_network/core_network.dart";
import "package:fpdart/fpdart.dart";
import "../entities/transfer_receipt.dart";
import "../repositories/transfer_repository.dart";
import "../value_objects/money.dart";

class TransferParams {
  final String sourceAccountId;
  final String targetAccountId;
  final double amountRaw;
  final String currencyRaw;

  const TransferParams({
    required this.sourceAccountId;
    required this.targetAccountId;
    required this.amountRaw;
    required this.currencyRaw;
  });
}

class ExecuteTransferUseCase {
  final TransferRepository _repository;

  const ExecuteTransferUseCase({
    required TransferRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, TransferReceipt>> call(TransferParams params) async {
    final moneyValidation = Money.create(params.amountRaw, params.currencyRaw);

    return await moneyValidation.fold(
      (validationFailure) async => Left(validationFailure),
      (validMoney) async {
        if (params.sourceAccountId == params.targetAccountId) {
          return const Left(
            ValidationFailure(message: "Source and destination accounts must be distinct."),
          );
        }
        return await _repository.executeTransfer(
          sourceAccountId: params.sourceAccountId,
          targetAccountId: params.targetAccountId,
          amount: validMoney,
        );
      },
    );
  }
}

