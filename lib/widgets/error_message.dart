import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorMessage({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.errorColor,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.errorColor,
              fontSize: 14,
            ),
          ),
          if (onRetry != null) const SizedBox(height: 16),
          if (onRetry != null)
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
