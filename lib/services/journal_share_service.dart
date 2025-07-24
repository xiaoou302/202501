import '../models/journal_entry.dart';
import '../models/share_card.dart';
import 'journal_repository.dart';
import 'share_service.dart';
import 'package:uuid/uuid.dart';

class JournalShareService {
  final JournalRepository _journalRepository = JournalRepository();
  final ShareService _shareService = ShareService();

  // 将日记条目转换为分享卡片
  Future<ShareCard> convertJournalToShareCard(JournalEntry entry) async {
    // 使用日记的文本内容
    String textToShare = entry.text;

    // 如果有标题，添加标题
    if (entry.title != null && entry.title!.isNotEmpty) {
      textToShare = '${entry.title}\n\n$textToShare'; //sdsdsdsd
    }

    // 生成二维码URL
    final qrCodeUrl = _shareService.generateQrCodeUrl(textToShare);

    // 创建分享卡片
    final shareCard = ShareCard(
      id: Uuid().v4(),
      text: textToShare,
      qrCodeUrl: qrCodeUrl,
      createdAt: DateTime.now(),
      colorHex: entry.colorHex, // 使用相同的颜色
    );

    // 保存分享卡片
    await _shareService.saveShareCard(shareCard);

    return shareCard;
  }

  // 获取最近的日记条目
  Future<List<JournalEntry>> getRecentJournalEntries() async {
    return await _journalRepository.getAllEntries();
  }
}
