import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';

/// 错误处理工具类
class ErrorHandler {
  // 显示错误提示
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // 显示成功提示
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppTheme.deepSpace),
        ),
        backgroundColor: AppTheme.champagne,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // 显示信息提示
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppTheme.moonlight),
        ),
        backgroundColor: AppTheme.silverstone,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // 显示加载对话框
  static Future<void> showLoading(BuildContext context, {String? message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.silverstone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppTheme.champagne),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      color: AppTheme.moonlight,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // 显示确认对话框
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确认',
    String cancelText = '取消',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.silverstone,
          title: Text(
            title,
            style: const TextStyle(
              color: AppTheme.moonlight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: AppTheme.moonlight),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(
                  color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDangerous ? Colors.red : AppTheme.champagne,
                foregroundColor: isDangerous
                    ? Colors.white
                    : AppTheme.deepSpace,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // 显示错误页面
  static Widget buildErrorWidget({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.coral, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppTheme.moonlight, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.champagne,
                foregroundColor: AppTheme.deepSpace,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('重试'),
            ),
          ],
        ],
      ),
    );
  }

  // 显示空数据页面
  static Widget buildEmptyWidget({
    required String message,
    IconData icon = Icons.inbox,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.silverstone, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppTheme.moonlight, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.champagne,
                foregroundColor: AppTheme.deepSpace,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(actionText),
            ),
          ],
        ],
      ),
    );
  }

  // 处理异步操作，自动显示加载和错误
  static Future<T> handleAsync<T>({
    required BuildContext context,
    required Future<T> Function() asyncFunction,
    String loadingMessage = '请稍候...',
    String errorMessage = '操作失败',
    String successMessage = '操作成功',
    bool showLoadingDialog = true,
    bool showSuccessMessage = true,
  }) async {
    try {
      // 显示加载对话框
      if (showLoadingDialog) {
        await showLoading(context, message: loadingMessage);
      }

      // 执行异步操作
      final result = await asyncFunction();

      // 关闭加载对话框
      if (showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      // 显示成功消息
      if (showSuccessMessage && context.mounted) {
        showSuccess(context, successMessage);
      }

      return result;
    } catch (e) {
      // 关闭加载对话框
      if (showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      // 显示错误消息
      if (context.mounted) {
        showError(context, _getErrorMessage(e, errorMessage));
      }

      rethrow;
    }
  }

  // 获取友好的错误消息
  static String _getErrorMessage(Object error, String defaultMessage) {
    if (error is TimeoutException) {
      return '连接超时，请稍后再试';
    } else if (error is SocketException) {
      return '网络连接失败，请检查您的网络';
    } else if (error is FormatException) {
      return '数据格式错误';
    } else {
      return error.toString().contains('Exception:')
          ? error.toString().split('Exception:')[1].trim()
          : defaultMessage;
    }
  }

  // 处理表单验证
  static bool validateForm(GlobalKey<FormState> formKey, BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    } else {
      showError(context, '请检查表单填写是否正确');
      return false;
    }
  }
}
