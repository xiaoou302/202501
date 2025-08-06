import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

/// 隐私说明页面
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('隐私说明'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.midnightBlue,
                AppColors.midnightBlue.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CoinAtlas隐私政策',
              style: AppStyles.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              '最后更新日期：2023年12月1日',
              style: TextStyle(
                color: AppColors.stardustWhite.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildPrivacyIntro(),
            _buildSection(
              title: '1. 我们收集的信息',
              content: '我们可能会收集以下类型的信息：\n\n'
                  '**个人信息**：当您注册账户或使用特定功能时，我们可能会收集您的姓名、电子邮件地址、手机号码等个人信息。\n\n'
                  '**设备信息**：我们可能会收集您使用的设备型号、操作系统版本、设备标识符、IP地址等信息。\n\n'
                  '**使用数据**：我们会收集您如何使用我们的应用，包括您查看的页面、点击的功能、使用的时间等。\n\n'
                  '**位置信息**：在您授权的情况下，我们可能会收集您的位置信息，以提供基于位置的服务。',
            ),
            _buildSection(
              title: '2. 信息使用',
              content: '我们使用收集的信息主要用于以下目的：\n\n'
                  '• 提供、维护和改进我们的服务\n'
                  '• 开发新功能和产品\n'
                  '• 个性化您的体验，包括提供定制内容和推荐\n'
                  '• 进行数据分析，了解用户如何使用我们的应用\n'
                  '• 与您沟通，包括发送服务通知和更新\n'
                  '• 保障账户安全，防止欺诈和滥用',
            ),
            _buildSection(
              title: '3. 信息共享',
              content: '我们重视您的隐私，不会出售您的个人信息。但在以下情况下，我们可能会共享您的信息：\n\n'
                  '**服务提供商**：我们可能会与帮助我们提供服务的第三方共享信息，如云服务提供商、数据分析服务商等。这些服务提供商仅能按照我们的指示处理您的信息，不得将其用于其他目的。\n\n'
                  '**法律要求**：如果法律要求或政府机构要求，我们可能会披露您的信息。\n\n'
                  '**业务转让**：如果我们参与合并、收购或资产出售，您的信息可能会作为交易的一部分被转让。\n\n'
                  '**经您同意**：在其他情况下，如果我们需要共享您的信息，我们会事先获取您的同意。',
            ),
            _buildSection(
              title: '4. 数据安全',
              content:
                  '我们采取适当的技术和组织措施来保护您的个人信息，防止未经授权的访问、使用或披露。这些措施包括加密传输数据、安全存储数据以及限制内部访问您的个人信息。\n\n'
                  '虽然我们努力保护您的个人信息，但请注意，没有任何安全措施是完全不可破解的。因此，我们不能保证您的个人信息在所有情况下都是绝对安全的。',
            ),
            _buildSection(
              title: '5. 您的权利',
              content: '根据适用的隐私法律，您可能拥有以下权利：\n\n'
                  '• 访问您的个人信息\n'
                  '• 更正不准确的个人信息\n'
                  '• 删除您的个人信息\n'
                  '• 限制或反对我们处理您的个人信息\n'
                  '• 数据可携带性\n'
                  '• 撤回同意\n\n'
                  '如需行使这些权利，请通过本隐私政策末尾提供的联系方式与我们联系。',
            ),
            _buildSection(
              title: '6. Cookie和类似技术',
              content:
                  '我们可能使用Cookie和类似技术来收集信息并改善您的体验。您可以通过浏览器设置来控制Cookie，但请注意，禁用Cookie可能会影响您使用我们应用的某些功能。',
            ),
            _buildSection(
              title: '7. 儿童隐私',
              content:
                  '我们的服务不面向13岁以下的儿童。我们不会故意收集13岁以下儿童的个人信息。如果您发现我们可能收集了13岁以下儿童的个人信息，请立即联系我们，我们会采取措施删除这些信息。',
            ),
            _buildSection(
              title: '8. 隐私政策的变更',
              content:
                  '我们可能会不时更新本隐私政策。当我们进行重大更改时，我们会通过应用内通知或其他适当方式通知您。我们鼓励您定期查看本隐私政策，以了解我们如何保护您的信息。',
            ),
            _buildSection(
              title: '9. 联系我们',
              content: '如果您对本隐私政策或我们的隐私实践有任何疑问或意见，请联系我们：\n\n'
                  '电子邮件：privacy@CoinAtlas-app.com\n'
                  '客服电话：400-123-4567',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 构建隐私政策介绍
  Widget _buildPrivacyIntro() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.coolBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.coolBlue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield,
                color: AppColors.coolBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '隐私保护承诺',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.coolBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'CoinAtlas重视并保护您的隐私。本隐私政策旨在帮助您了解我们如何收集、使用、共享和保护您的个人信息。请您在使用我们的服务前仔细阅读本隐私政策，以便做出明智的选择。',
            style: AppStyles.bodyText.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  // 构建隐私政策章节
  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppStyles.bodyText.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
