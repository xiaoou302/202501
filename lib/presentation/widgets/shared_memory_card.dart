import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/shared_memory_model.dart';

/// 网友分享的幸福时刻卡片组件
class SharedMemoryCard extends StatelessWidget {
  final SharedMemoryModel sharedMemory;
  final VoidCallback? onTap;

  const SharedMemoryCard({super.key, required this.sharedMemory, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppTheme.silverstone,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片部分
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    sharedMemory.imageAsset,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220,
                        color: AppTheme.silverstone,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: AppTheme.moonlight,
                            size: 50,
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
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ColorUtils.withOpacity(Colors.black, 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // 标题覆盖在图片上
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    sharedMemory.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3.0,
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 内容部分
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 内容
                  Text(
                    sharedMemory.content,
                    style: TextStyle(
                      color: ColorUtils.withOpacity(AppTheme.moonlight, 0.9),
                      fontSize: 15,
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),

                  // 作者和点赞
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 作者
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorUtils.withOpacity(
                                AppTheme.champagne,
                                0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppTheme.champagne,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            sharedMemory.author,
                            style: TextStyle(
                              color: ColorUtils.withOpacity(
                                AppTheme.moonlight,
                                0.8,
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // 点赞
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorUtils.withOpacity(
                                AppTheme.coral,
                                sharedMemory.isLiked ? 0.4 : 0.2,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: sharedMemory.isLiked
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.coral.withOpacity(0.3),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                sharedMemory.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey<bool>(sharedMemory.isLiked),
                                color: AppTheme.coral,
                                size: sharedMemory.isLiked ? 18 : 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              color: ColorUtils.withOpacity(
                                sharedMemory.isLiked
                                    ? AppTheme.coral
                                    : AppTheme.moonlight,
                                sharedMemory.isLiked ? 0.9 : 0.8,
                              ),
                              fontSize: sharedMemory.isLiked ? 15 : 14,
                              fontWeight: sharedMemory.isLiked
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                            child: Text('${sharedMemory.likeCount}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
