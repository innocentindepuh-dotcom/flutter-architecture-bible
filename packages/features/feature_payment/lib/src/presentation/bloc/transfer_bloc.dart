// packages/features/feature_payment/lib/src/presentation/bloc/transfer_bloc.dart

import "dart:async";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../domain/entities/transfer_receipt.dart";
import "../../domain/usecases/execute_transfer_usecase.dart";

sealed class TransferState {
  const TransferState();
}

class TransferInitial extends TransferState {
  const TransferInitial();
}

class TransferSubmitting extends TransferState {
  const TransferSubmitting();
}

class TransferSuccess extends TransferState {
  final TransferReceipt receipt;
  const TransferSuccess({required this.receipt});
}

class TransferFailureState extends TransferState {
  final String error;
  const TransferFailureState({required this.error});
}

sealed class TransferEvent {
  const TransferEvent();
}

class SubmitTransferEvent extends TransferEvent {
  final String sourceId;
  final String targetId;
  final double amount;
  final String currency;

  const SubmitTransferEvent({
    required this.sourceId;
    required this.targetId;
    required this.amount;
    required this.currency;
  });
}

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final ExecuteTransferUseCase _executeTransferUseCase;

  TransferBloc({required ExecuteTransferUseCase executeTransferUseCase})
      : _executeTransferUseCase = executeTransferUseCase,
        super(const TransferInitial()) {
    on<SubmitTransferEvent>(_onSubmitTransfer);
  }

  Future<void> _onSubmitTransfer(
    SubmitTransferEvent event,
    Emitter<TransferState> emit,
  ) async {
    emit(const TransferSubmitting());

    final result = await _executeTransferUseCase(
      TransferParams(
        sourceAccountId: event.sourceId,
        targetAccountId: event.targetId,
        amountRaw: event.amount,
        currencyRaw: event.currency,
      ),
    );

    result.fold(
      (failure) => emit(TransferFailureState(error: failure.message)),
      (receipt) => emit(TransferSuccess(receipt: receipt)),
    );
  }
}

