import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.softCoral),
          ),
          if (message != null) ...[
            const SizedBox(height: AppConstants.spacingM),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
