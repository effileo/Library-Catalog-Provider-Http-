import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
