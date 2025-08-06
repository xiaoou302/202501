import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

/// 用户协议页面
class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('用户协议'),
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
              'CoinAtlas用户协议',
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
            _buildSection(
              title: '1. 协议接受',
              content:
                  '欢迎使用CoinAtlas应用（以下简称"本应用"）。本用户协议（以下简称"本协议"）是您与本应用开发者之间关于使用本应用服务所订立的协议。请您在使用本应用前，仔细阅读本协议的全部内容。如您不同意本协议的任何内容，请不要安装或使用本应用。您安装或使用本应用的行为将视为对本协议的接受，并同意受本协议各项条款的约束。',
            ),
            _buildSection(
              title: '2. 服务内容',
              content:
                  '本应用提供金融市场数据、分析工具和资讯服务，旨在帮助用户了解市场动态和趋势。本应用所提供的数据和分析仅供参考，不构成任何投资建议或交易指导。用户应对自己的投资决策和交易行为负全部责任。',
            ),
            _buildSection(
              title: '3. 用户行为规范',
              content:
                  '用户在使用本应用时，必须遵守中华人民共和国相关法律法规，不得利用本应用从事任何违法或不当的活动，包括但不限于：\n\n'
                  '• 传播违法、有害、淫秽、暴力、侮辱、诽谤等信息\n'
                  '• 侵犯他人知识产权、商业秘密或其他合法权益\n'
                  '• 干扰或破坏本应用的正常运行\n'
                  '• 未经授权访问本应用的系统或数据\n'
                  '• 其他违反法律法规或侵犯他人合法权益的行为',
            ),
            _buildSection(
              title: '4. 知识产权',
              content:
                  '本应用及其所有内容，包括但不限于文字、图片、音频、视频、软件、程序、数据等，均受知识产权法律法规保护。未经本应用开发者明确书面许可，用户不得以任何方式复制、修改、传播或使用上述内容，否则将承担相应的法律责任。',
            ),
            _buildSection(
              title: '5. 免责声明',
              content:
                  '本应用提供的市场数据和分析工具仅供参考，不构成任何投资建议。用户应对自己的投资决策负责，并承担相应风险。本应用开发者不对用户因使用本应用而产生的任何直接或间接损失承担责任，包括但不限于财产损失、数据丢失等。\n\n'
                  '本应用将尽力确保服务的连续性和安全性，但不保证服务不会中断，也不保证服务的及时性、安全性、准确性。',
            ),
            _buildSection(
              title: '6. 协议修改',
              content:
                  '本应用开发者有权在必要时修改本协议条款。您可以在本应用的设置页面查阅最新版本的协议条款。本协议条款变更后，如果您继续使用本应用，即视为您已接受修改后的协议。如果您不接受修改后的协议，您应当停止使用本应用。',
            ),
            _buildSection(
              title: '7. 适用法律与争议解决',
              content:
                  '本协议的订立、执行和解释及争议的解决均应适用中华人民共和国法律。如发生本协议相关的任何争议或纠纷，应友好协商解决；协商不成的，任何一方均有权将争议提交至有管辖权的人民法院诉讼解决。',
            ),
            _buildSection(
              title: '8. 联系方式',
              content: '如您对本协议或本应用的使用有任何问题，可以通过以下方式联系我们：\n\n'
                  '电子邮件：support@CoinAtlas-app.com\n'
                  '客服电话：400-123-4567',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 构建协议章节
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
