// packages/features/feature_payment/lib/src/presentation/screens/transfer_screen.dart

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../bloc/transfer_bloc.dart";

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _targetController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController(text: "USD");

  @override
  void dispose() {
    _sourceController.dispose();
    _targetController.dispose();
    _amountController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Funds Transfer")),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state is TransferSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Success! Ref: ${state.receipt.transactionReference}"),
                backgroundColor: Colors.green,
              ),
            );
            _amountController.clear();
          } else if (state is TransferFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _sourceController,
                    decoration: const InputDecoration(
                      labelText: "Source Account Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Source account is required" : null,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _targetController,
                    decoration: const InputDecoration(
                      labelText: "Destination Account Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Destination account is required" : null,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: "Amount",
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return "Required";
                            final parsed = double.tryParse(val);
                            if (parsed == null || parsed <= 0) return "Invalid";
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _currencyController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: "Currency",
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) =>
                              val == null || val.trim().length != 3 ? "Invalid" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  state is TransferSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<TransferBloc>().add(
                                  SubmitTransferEvent(
                                    sourceId: _sourceController.text,
                                    targetId: _targetController.text,
                                    amount: double.parse(_amountController.text),
                                    currency: _currencyController.text,
                                  ),
                                );
                              }
                            },
                            child: const Text("Confirm and Authorize Transfer"),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

