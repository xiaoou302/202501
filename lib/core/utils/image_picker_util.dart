import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';

/// 图片选择工具类
class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// 显示图片选择底部菜单
  static Future<String?> showImagePickerOptions(BuildContext context) async {
    debugPrint('ImagePickerUtil: Displaying image picker menu');

    // 使用Completer模式，确保异步操作完成后返回结果
    final source = await showModalBottomSheet<ImageSource?>(
      context: context,
      backgroundColor: AppTheme.silverstone,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Select Image Source',
                style: TextStyle(
                  color: AppTheme.moonlight,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppTheme.champagne,
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: AppTheme.moonlight),
                ),
                onTap: () {
                  debugPrint(
                    'ImagePickerUtil: User chose to pick from gallery',
                  );
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppTheme.champagne,
                ),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(color: AppTheme.moonlight),
                ),
                onTap: () {
                  debugPrint('ImagePickerUtil: User chose to take photo');
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtils.withOpacity(
                      AppTheme.deepSpace,
                      0.8,
                    ),
                    foregroundColor: AppTheme.moonlight,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    // 如果用户取消选择，返回null
    if (source == null) {
      debugPrint('ImagePickerUtil: 用户取消了选择');
      return null;
    }

    // 根据选择的来源获取图片
    String? imagePath;
    if (source == ImageSource.gallery) {
      imagePath = await _pickImageFromGallery();
    } else if (source == ImageSource.camera) {
      imagePath = await _pickImageFromCamera();
    }

    debugPrint('ImagePickerUtil: 最终返回的图片路径: $imagePath');
    return imagePath;
  }

  /// 从相册选择图片
  static Future<String?> _pickImageFromGallery() async {
    try {
      debugPrint('ImagePickerUtil: 正在打开相册...');
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        debugPrint('ImagePickerUtil: 成功从相册选择图片: ${pickedFile.path}');
        // 将图片保存到应用目录
        final savedPath = await _saveImageToAppDirectory(pickedFile);
        debugPrint('ImagePickerUtil: 图片已保存到应用目录: $savedPath');
        return savedPath;
      } else {
        debugPrint('ImagePickerUtil: 用户取消了图片选择');
      }
    } catch (e) {
      debugPrint('ImagePickerUtil: 从相册选择图片时出错: $e');
    }
    return null;
  }

  /// 使用相机拍摄图片
  static Future<String?> _pickImageFromCamera() async {
    try {
      debugPrint('ImagePickerUtil: 正在打开相机...');
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        debugPrint('ImagePickerUtil: 成功拍摄照片: ${pickedFile.path}');
        // 将图片保存到应用目录
        final savedPath = await _saveImageToAppDirectory(pickedFile);
        debugPrint('ImagePickerUtil: 照片已保存到应用目录: $savedPath');
        return savedPath;
      } else {
        debugPrint('ImagePickerUtil: 用户取消了拍照');
      }
    } catch (e) {
      debugPrint('ImagePickerUtil: 拍摄照片时出错: $e');
    }
    return null;
  }

  /// 将图片保存到应用目录
  static Future<String> _saveImageToAppDirectory(XFile pickedFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
      final savedFile = File('${directory.path}/$fileName');

      debugPrint('ImagePickerUtil: 正在保存图片到: ${savedFile.path}');

      // 复制图片到应用目录
      final bytes = await pickedFile.readAsBytes();
      await savedFile.writeAsBytes(bytes);

      // 验证文件是否存在
      final exists = await savedFile.exists();
      debugPrint(
        'ImagePickerUtil: 文件是否存在: $exists, 文件大小: ${await savedFile.length()} 字节',
      );

      // 返回文件路径
      return savedFile.path;
    } catch (e) {
      debugPrint('ImagePickerUtil: 保存图片到应用目录时出错: $e');
      // 如果保存失败，返回原始路径
      return pickedFile.path;
    }
  }

  /// 验证图片URL是否有效
  static bool isValidImageUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) return false;

    final lowerCaseUrl = url.toLowerCase();
    return lowerCaseUrl.endsWith('.jpg') ||
        lowerCaseUrl.endsWith('.jpeg') ||
        lowerCaseUrl.endsWith('.png') ||
        lowerCaseUrl.endsWith('.gif') ||
        lowerCaseUrl.endsWith('.webp') ||
        lowerCaseUrl.contains('unsplash.com') ||
        lowerCaseUrl.contains('images.pexels.com');
  }
}
