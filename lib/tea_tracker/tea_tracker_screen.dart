import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/app_colors.dart';
import '../shared/app_text_styles.dart';
import '../shared/glass_card_widget.dart';
import '../models/tea_record.dart';
import 'tea_tracker_controller.dart';

class TeaTrackerScreen extends StatefulWidget {
  const TeaTrackerScreen({Key? key}) : super(key: key);

  @override
  State<TeaTrackerScreen> createState() => _TeaTrackerScreenState();
}

class _TeaTrackerScreenState extends State<TeaTrackerScreen> {
  final TeaTrackerController _controller = TeaTrackerController();
  List<TeaRecord> _records = [];
  int _monthlyCount = 0;
  double _monthlySpending = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final records = await _controller.getRecentRecords();
    final stats = await _controller.getMonthlyStats();

    if (mounted) {
      setState(() {
        _records = records;
        _monthlyCount = stats['count'] ?? 0;
        _monthlySpending = stats['spending'] ?? 0;
      });
    }
  }

  void _showAddRecordDialog() {
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    final priceController = TextEditingController();
    int rating = 3;
    String type = 'Bubble Tea';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.brandDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 确保点击任何区域都能收起键盘
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New Beverage', style: AppTextStyles.headingMedium),
                const SizedBox(height: 16),

                // 饮品类型选择
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'Bubble Tea'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: type == 'Bubble Tea'
                                ? AppColors.brandTeal.withOpacity(0.3)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Bubble Tea',
                              style: TextStyle(
                                color: type == 'Bubble Tea'
                                    ? AppColors.brandTeal
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => type = 'Coffee'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: type == 'Coffee'
                                ? AppColors.brandTeal.withOpacity(0.3)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Coffee',
                              style: TextStyle(
                                color: type == 'Coffee'
                                    ? AppColors.brandTeal
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 饮品名称
                TextField(
                  controller: nameController,
                  style: AppTextStyles.bodyLarge,
                  maxLength: 30,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Beverage Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    counterText: '${nameController.text.length}/30',
                    counterStyle: TextStyle(
                      color: nameController.text.length > 25
                          ? (nameController.text.length > 28
                              ? Colors.red
                              : Colors.orange)
                          : Colors.grey,
                    ),
                    hintText: 'Enter beverage name',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    errorText: nameController.text.trim().isEmpty &&
                            nameController.text.isNotEmpty
                        ? 'Name cannot be just spaces'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // 品牌
                TextField(
                  controller: brandController,
                  style: AppTextStyles.bodyLarge,
                  maxLength: 20,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Brand',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    counterText: '${brandController.text.length}/20',
                    counterStyle: TextStyle(
                      color: brandController.text.length > 15
                          ? (brandController.text.length > 18
                              ? Colors.red
                              : Colors.orange)
                          : Colors.grey,
                    ),
                    hintText: 'Enter brand name',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    errorText: brandController.text.trim().isEmpty &&
                            brandController.text.isNotEmpty
                        ? 'Brand cannot be just spaces'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // 价格
                TextField(
                  controller: priceController,
                  style: AppTextStyles.bodyLarge,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  maxLength: 6,
                  textInputAction: TextInputAction.done,
                  onChanged: (text) => setState(() {}),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Price (\$)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    counterText: priceController.text.isEmpty
                        ? ''
                        : (double.tryParse(priceController.text) ?? 0) > 1000
                            ? 'High price!'
                            : 'Valid',
                    counterStyle: TextStyle(
                      color: (double.tryParse(priceController.text) ?? 0) > 1000
                          ? Colors.orange
                          : Colors.green,
                    ),
                    hintText: '0.00 - 9999.99',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    prefixText: '\$ ',
                    errorText: priceController.text.isNotEmpty &&
                            (double.tryParse(priceController.text) ?? 0) <= 0
                        ? 'Price must be greater than 0'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // 评分
                Text('Rating', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: index < rating ? Colors.amber : Colors.grey,
                        size: 32,
                      ),
                      onPressed: () => setState(() => rating = index + 1),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // 保存按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: nameController.text.trim().isEmpty ||
                            brandController.text.trim().isEmpty ||
                            priceController.text.isEmpty ||
                            (double.tryParse(priceController.text) ?? 0) <= 0
                        ? null // 禁用按钮如果输入无效
                        : () async {
                            final price =
                                double.tryParse(priceController.text) ?? 0;
                            final success = await _controller.addRecord(
                              name: nameController.text.trim(),
                              brand: brandController.text.trim(),
                              price: price,
                              rating: rating,
                              type: type,
                            );

                            if (success) {
                              Navigator.pop(context);
                              _loadData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Record saved'),
                                  backgroundColor: AppColors.brandTeal,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRecordDetails(TeaRecord record) {
    final DateTime recordDate = record.timestamp;
    final String formattedDate =
        '${recordDate.year}-${recordDate.month.toString().padLeft(2, '0')}-${recordDate.day.toString().padLeft(2, '0')}';
    final String formattedTime =
        '${recordDate.hour.toString().padLeft(2, '0')}:${recordDate.minute.toString().padLeft(2, '0')}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.brandDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 确保点击任何区域都能收起键盘
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Beverage Details', style: AppTextStyles.headingMedium),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(record);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.brandTeal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$formattedDate $formattedTime',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 饮品信息卡片
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            record.type == 'Bubble Tea'
                                ? Icons.wine_bar
                                : Icons.coffee,
                            color: AppColors.brandTeal,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.name,
                              style: AppTextStyles.headingSmall,
                            ),
                            Text(
                              record.brand,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type', style: AppTextStyles.bodySmall),
                            Text(record.type, style: AppTextStyles.bodyMedium),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Price', style: AppTextStyles.bodySmall),
                            Text(
                              '\$${record.price.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.brandTeal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Rating', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < record.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    if (record.notes != null && record.notes!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text('Notes', style: AppTextStyles.bodySmall),
                      const SizedBox(height: 4),
                      Text(record.notes!, style: AppTextStyles.bodyMedium),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecordOptions(TeaRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.brandDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text('Delete Record', style: AppTextStyles.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(record);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(TeaRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.brandDark,
        title: Text('Delete Record', style: AppTextStyles.headingMedium),
        content: Text(
          'Are you sure you want to delete this record? This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await _controller.deleteRecord(record.id);
              if (success && mounted) {
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Record deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Tea Tracker', style: AppTextStyles.headingLarge),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 确保点击任何区域都能收起键盘
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.brandGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your sweet daily ritual, every cup is worth recording.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 月度统计卡片
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '$_monthlyCount',
                                style: AppTextStyles.headingLarge,
                                children: [
                                  TextSpan(
                                    text: ' cups',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Text('This Month', style: AppTextStyles.bodySmall),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                text:
                                    '\$${_monthlySpending.toStringAsFixed(0)}',
                                style: AppTextStyles.headingLarge,
                              ),
                            ),
                            Text('Spent', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text('Recent Records', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 12),

                  // 记录列表
                  Expanded(
                    child: _records.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_cafe_outlined,
                                  size: 64,
                                  color: AppColors.brandTeal,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No records yet. Add your first cup!',
                                  style: AppTextStyles.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _records.length,
                            itemBuilder: (context, index) {
                              final record = _records[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () => _showRecordDetails(record),
                                    onLongPress: () =>
                                        _showRecordOptions(record),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Row(
                                      children: [
                                        // 图标
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            record.type == 'Bubble Tea'
                                                ? Icons.wine_bar
                                                : Icons.coffee,
                                            color: AppColors.brandTeal,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // 信息
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                record.name,
                                                style: AppTextStyles.bodyLarge
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${record.brand} · \$${record.price.toStringAsFixed(0)}',
                                                style: AppTextStyles.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // 评分和时间
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: List.generate(5, (
                                                index,
                                              ) {
                                                return Icon(
                                                  index < record.rating
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 14,
                                                );
                                              }),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              record.getFormattedTime(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // 添加按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Record'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _showAddRecordDialog,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
