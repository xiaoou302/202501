import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/memory_model.dart';
import 'package:soli/presentation/screens/image_preview_screen.dart';
import 'package:intl/intl.dart';

/// 回忆卡片组件
class MemoryCard extends StatelessWidget {
  final MemoryModel memory;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MemoryCard({
    super.key,
    required this.memory,
    this.onTap,
    this.onLongPress,
  });

  // 检查图片是否是本地路径
  bool _isLocalImage() {
    return !memory.imageUrl.startsWith('http');
  }

  // 打开图片预览
  void _openImagePreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          imageUrl: memory.imageUrl,
          isLocalImage: _isLocalImage(),
          title: memory.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: () => _openImagePreview(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorUtils.withOpacity(Colors.black, 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // 图片
              Hero(
                tag: 'memory_image_${memory.id}',
                child: _isLocalImage()
                    ? Image.file(
                        File(memory.imageUrl),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.silverstone,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppTheme.moonlight,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      )
                    : Image.network(
                        memory.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppTheme.silverstone,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppTheme.moonlight,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // 渐变遮罩
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        ColorUtils.withOpacity(Colors.black, 0.8),
                        ColorUtils.withOpacity(Colors.black, 0.4),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memory.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Color.fromARGB(150, 0, 0, 0),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(memory.date),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // 双击提示
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorUtils.withOpacity(Colors.black, 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Double tap',
                        style: TextStyle(
                          color: ColorUtils.withOpacity(Colors.white, 0.9),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 标签指示器
              if (memory.tags.isNotEmpty)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorUtils.withOpacity(AppTheme.champagne, 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      memory.tags.first,
                      style: TextStyle(
                        color: AppTheme.deepSpace,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
