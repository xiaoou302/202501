import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';

/// 图片预览页面
class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;
  final bool isLocalImage;
  final String? title;

  const ImagePreviewScreen({
    super.key,
    required this.imageUrl,
    this.isLocalImage = false,
    this.title,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // 重置缩放
  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() {
      _isZoomed = false;
    });
  }

  // 处理缩放变化
  void _onInteractionUpdate(ScaleUpdateDetails details) {
    if (_transformationController.value.getMaxScaleOnAxis() > 1.0) {
      setState(() {
        _isZoomed = true;
      });
    } else {
      setState(() {
        _isZoomed = false;
      });
    }
  }

  // 处理缩放结束
  void _onInteractionEnd(ScaleEndDetails details) {
    if (_transformationController.value.getMaxScaleOnAxis() <= 1.0) {
      setState(() {
        _isZoomed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorUtils.withOpacity(Colors.black, 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: widget.title != null
            ? Text(widget.title!, style: const TextStyle(color: Colors.white))
            : null,
        actions: [
          if (_isZoomed)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorUtils.withOpacity(Colors.black, 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
              onPressed: _resetZoom,
            ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5,
          maxScale: 3.0,
          onInteractionUpdate: _onInteractionUpdate,
          onInteractionEnd: _onInteractionEnd,
          child: Hero(
            tag: 'image_preview_${widget.imageUrl}',
            child: widget.isLocalImage
                ? Image.file(
                    File(widget.imageUrl),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget();
                    },
                  )
                : Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildLoadingWidget(loadingProgress);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget();
                    },
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: ColorUtils.withOpacity(Colors.black, 0.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.share,
              label: '分享',
              onTap: () {
                // 分享功能
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('分享功能即将上线'),
                    backgroundColor: AppTheme.champagne,
                  ),
                );
              },
            ),
            _buildActionButton(
              icon: Icons.save_alt,
              label: '保存',
              onTap: () {
                // 保存功能
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('保存功能即将上线'),
                    backgroundColor: AppTheme.champagne,
                  ),
                );
              },
            ),
            _buildActionButton(
              icon: Icons.edit,
              label: '编辑',
              onTap: () {
                // 编辑功能
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('编辑功能即将上线'),
                    backgroundColor: AppTheme.champagne,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 构建操作按钮
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 构建加载中组件
  Widget _buildLoadingWidget(ImageChunkEvent loadingProgress) {
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
            : null,
        color: AppTheme.champagne,
      ),
    );
  }

  // 构建错误组件
  Widget _buildErrorWidget() {
    return Container(
      color: AppTheme.silverstone,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, color: AppTheme.moonlight, size: 60),
            const SizedBox(height: 16),
            const Text(
              '图片加载失败',
              style: TextStyle(color: AppTheme.moonlight, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.champagne,
                foregroundColor: AppTheme.deepSpace,
              ),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}
