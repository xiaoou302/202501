import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/theme_service.dart';
import '../widgets/glass_panel.dart';
import '../utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../astriusAP/GetBasicParamGroup.dart';
import '../astriusAP/FinishBasicEqualizationGroup.dart';

class ControlHubScreen extends StatefulWidget {
  const ControlHubScreen({super.key});

  @override
  State<ControlHubScreen> createState() => _ControlHubScreenState();
}

class _ControlHubScreenState extends State<ControlHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _aiResponse = '';
  bool _isLoading = false;
  int _coinBalance = 0;

  // API Configuration
  static const String _apiKey = 'sk-9e0faeacac134521b595e910fdeb1b2e';
  static const String _baseUrl = 'https://api.deepseek.com/chat/completions';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCoinBalance();
  }

  Future<void> _loadCoinBalance() async {
    final balance =
        await RefreshCommonBottomProtocol.SyncIterativeDepthImplement();
    if (mounted) {
      setState(() {
        _coinBalance = balance;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _callDeepSeek(String userPrompt) async {
    // Check balance
    int balance =
        await RefreshCommonBottomProtocol.SyncIterativeDepthImplement();
    if (balance <= 0) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: GlassPanel(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.safelightRed.withOpacity(0.1),
                      border: Border.all(
                        color: AppColors.safelightRed.withOpacity(0.5),
                      ),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.circleExclamation,
                      color: AppColors.safelightRed,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Insufficient Balance',
                    style: TextStyle(
                      color: AppColors.starlightWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to initiate AI request. Please recharge your coin balance to continue using this feature.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.meteoriteGrey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(color: AppColors.meteoriteGrey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OptimizeSymmetricNodeHelper(),
                              ),
                            ).then((_) => _loadCoinBalance());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orionPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'RECHARGE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return;
    }

    // Deduct 1 coin
    await RefreshCommonBottomProtocol.ReleaseActivatedVarCreator(1);
    await _loadCoinBalance();

    setState(() {
      _isLoading = true;
      _aiResponse = '';
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a professional astrophotography assistant. Provide accurate, technical, and helpful advice for deep-sky imaging. Format your response with clear headings and bullet points. Use English.',
            },
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          _aiResponse = data['choices'][0]['message']['content'];
        });
      } else {
        setState(() {
          _aiResponse =
              'Error: Failed to fetch data (Status ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _aiResponse = 'Error: Connection failed ($e)';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getRecommendations() {
    final now = DateTime.now();
    final month = now.month;
    String season = 'Winter';
    if (month >= 3 && month <= 5) season = 'Spring';
    if (month >= 6 && month <= 8) season = 'Summer';
    if (month >= 9 && month <= 11) season = 'Autumn';

    const prompt = '''
    As a deep-sky photography expert, recommend 3 best deep-sky targets for the current season (Northern Hemisphere).
    For each target, please provide:
    1. Name & Catalog Number (e.g., M42 Orion Nebula)
    2. Best Shooting Time (e.g., 22:00 - 02:00)
    3. Suggested Focal Length (e.g., 300mm - 600mm)
    4. Suggested Exposure (e.g., 180s x 60 frames)
    5. Brief Description (one sentence)
    Please return as a clear structured list.
    ''';
    _callDeepSeek(prompt);
  }

  void _searchTarget() {
    if (_searchController.text.isEmpty) return;
    final prompt =
        '''
    As a deep-sky photography expert, provide a detailed shooting plan for the target "${_searchController.text}".
    Please include:
    1. Best Shooting Window (Local Time)
    2. Suggested Equipment (Focal Length, Filter Type)
    3. Camera Settings (Gain/ISO, Single Exposure Time)
    4. Composition Advice
    5. Expected Challenges (e.g., low altitude, moon interference)
    Please format using clear headings.
    ''';
    _callDeepSeek(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [_buildRecommendationTab(), _buildSearchTab()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.satelliteDish,
                      size: 14,
                      color: AppColors.andromedaCyan,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'AI PLANNER',
                        style: TextStyle(
                          color: AppColors.andromedaCyan,
                          fontSize: 12,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, AppColors.starlightWhite],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Mission Control',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkMatter.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FontAwesomeIcons.coins,
                  color: AppColors.andromedaCyan,
                  size: 14,
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    '$_coinBalance',
                    style: const TextStyle(
                      color: AppColors.starlightWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 16,
                  color: AppColors.glassBorder.withOpacity(0.5),
                ),
                const SizedBox(width: 4),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    FontAwesomeIcons.circleInfo,
                    color: AppColors.meteoriteGrey,
                    size: 16,
                  ),
                  tooltip: 'App Info & Privacy',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: GlassPanel(
                          padding: const EdgeInsets.all(24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'APP INFO & PRIVACY',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: AppColors.starlightWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 24),
                                _buildInfoSection(
                                  'Features',
                                  '• AI Planner: Get intelligent shooting recommendations.\n'
                                      '• Astro-Atlas: Detailed deep-sky object database.\n'
                                      '• FOV Simulator: Visualize framing with your gear.\n'
                                      '• Astro-Log: Record your observation sessions.',
                                ),
                                const SizedBox(height: 16),
                                _buildInfoSection(
                                  'AI Service Provider',
                                  'This application uses DeepSeek (deepseek-chat) as its AI service provider to generate astrophotography recommendations and plans.',
                                ),
                                const SizedBox(height: 16),
                                _buildInfoSection(
                                  'Data Sharing',
                                  'The application sends your query text (e.g., "M42", "Current Season") to DeepSeek API to generate responses. No personal identifiable information (PII) or photos are shared.',
                                ),
                                const SizedBox(height: 16),
                                _buildInfoSection(
                                  'User Consent',
                                  'By using the "Analyze Sky" or "Search" features in the AI Planner tab, you acknowledge and consent to sending your prompt text to DeepSeek for processing.',
                                ),
                                const SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'CLOSE',
                                      style: TextStyle(
                                        color: AppColors.orionPurple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.andromedaCyan,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: AppColors.meteoriteGrey,
            height: 1.5,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.darkMatter.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.orionPurple,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.orionPurple.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.meteoriteGrey,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.wandMagicSparkles, size: 14),
                SizedBox(width: 8),
                Text('RECOMMEND'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.magnifyingGlass, size: 14),
                SizedBox(width: 8),
                Text('SEARCH'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          if (_aiResponse.isEmpty && !_isLoading)
            Expanded(
              child: Center(
                child: GlassPanel(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.orionPurple.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.orionPurple.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.orionPurple.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          FontAwesomeIcons.wandMagicSparkles,
                          size: 48,
                          color: AppColors.starlightWhite,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Mission: Discovery',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'AI will analyze current astronomical conditions to suggest optimal deep-sky targets.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.meteoriteGrey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _getRecommendations,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.orionPurple,
                                Color(0xFF5E2296),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.orionPurple.withOpacity(0.5),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                'ANALYZE SKY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(child: _buildResultArea()),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkMatter.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.glassBorder.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      maxLength: 50,
                      style: const TextStyle(
                        color: AppColors.starlightWhite,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Target (e.g. M31, Rosette)...',
                        counterText: '',
                        hintStyle: TextStyle(
                          color: AppColors.meteoriteGrey.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: AppColors.orionPurple.withOpacity(0.7),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _searchTarget,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.orionPurple, Color(0xFF5E2296)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orionPurple.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildResultArea()),
        ],
      ),
    );
  }

  Widget _buildResultArea() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.darkMatter.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.andromedaCyan.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.andromedaCyan.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.andromedaCyan,
                ),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.andromedaCyan, AppColors.starlightWhite],
              ).createShader(bounds),
              child: const Text(
                'UPLINK ESTABLISHED',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Retrieving stellar data...',
              style: TextStyle(
                color: AppColors.andromedaCyan.withOpacity(0.7),
                fontSize: 12,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      );
    }

    if (_aiResponse.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.magnifyingGlassChart,
              size: 48,
              color: AppColors.meteoriteGrey.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Awaiting Input',
              style: TextStyle(
                color: AppColors.meteoriteGrey.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: GlassPanel(
        padding: const EdgeInsets.all(24),
        border: Border.all(
          color: AppColors.andromedaCyan.withOpacity(0.2),
          width: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.andromedaCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    FontAwesomeIcons.robot,
                    size: 16,
                    color: AppColors.andromedaCyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ANALYSIS COMPLETE',
                        style: TextStyle(
                          color: AppColors.andromedaCyan,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Optimization Report',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.glassBorder.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              _aiResponse,
              style: const TextStyle(
                color: AppColors.starlightWhite,
                height: 1.8,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
