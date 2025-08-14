import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../theme/app_theme.dart';

/// 知识胶囊组件，显示学习资源
class KnowledgePodCard extends StatelessWidget {
  final KnowledgePod pod;
  final Function(KnowledgePod) onTap;

  const KnowledgePodCard({Key? key, required this.pod, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(pod),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    pod.title,
                    style: const TextStyle(color: AppTheme.primaryText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.secondaryText,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 知识胶囊列表组件
class KnowledgePodList extends StatelessWidget {
  final List<KnowledgePod> pods;
  final Function(KnowledgePod) onTap;
  final String title;

  const KnowledgePodList({
    Key? key,
    required this.pods,
    required this.onTap,
    this.title = 'Knowledge Pods',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // 胶囊列表
        if (pods.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No resources available',
                style: TextStyle(color: AppTheme.secondaryText),
              ),
            ),
          )
        else
          Column(
            children: pods
                .map((pod) => KnowledgePodCard(pod: pod, onTap: onTap))
                .toList(),
          ),
      ],
    );
  }
}

/// 知识胶囊详情对话框
class KnowledgePodDetailDialog extends StatelessWidget {
  final KnowledgePod pod;

  const KnowledgePodDetailDialog({Key? key, required this.pod})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.brandBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.brandBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pod.title,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 内容
            if (pod.description != null && pod.description!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.secondaryText.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 生成随机内容，实际应用中应该从API获取
                    Text(
                      pod.description!,
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 生成一些要点
                    _buildKeyPoints(),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // 关闭按钮
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.brandBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建知识要点
  Widget _buildKeyPoints() {
    // 根据知识胶囊的标题生成一些要点
    List<String> keyPoints = [];

    if (pod.title.contains('指南')) {
      keyPoints = [
        'Mastering the basics is key to success',
        'Regular practice can deepen understanding',
        'Find practical applications to reinforce what you learn',
        'Sharing knowledge with others helps with retention',
      ];
    } else if (pod.title.contains('技巧')) {
      keyPoints = [
        'Using the right tools can double your efficiency',
        'Establishing good habits is the foundation for continuous progress',
        'Regular review and summary can identify areas for improvement',
        'Learning from professionals can help avoid common mistakes',
      ];
    } else if (pod.title.contains('方法')) {
      keyPoints = [
        'Set clear goals and plans',
        'Break complex tasks into small steps',
        'Establish feedback mechanisms to verify results',
        'Stay flexible and adjust methods as needed',
      ];
    } else {
      keyPoints = [
        'Continuous learning is key to maintaining competitiveness',
        'Thinking about problems from multiple angles can lead to innovative solutions',
        'Collaborating with like-minded people can promote mutual growth',
        'Regular reflection and adjustment can optimize your learning path',
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Points:',
          style: TextStyle(
            color: AppTheme.brandBlue,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...keyPoints.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    color: AppTheme.accentOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
