import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/theme.dart';
import 'showcase_detail_screen.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  List<Map<String, dynamic>> showcases = [];

  @override
  void initState() {
    super.initState();
    _loadShowcases();
  }

  Future<void> _loadShowcases() async {
    final prefs = await SharedPreferences.getInstance();
    final String? deletedIdsJson = prefs.getString('deleted_showcases');
    List<String> deletedIds = [];
    if (deletedIdsJson != null) {
      deletedIds = List<String>.from(jsonDecode(deletedIdsJson));
    }

    final List<Map<String, dynamic>> allShowcases = [
      {
        'id': 's1',
        'title': 'High-Speed Slope Soarer',
        'imageUrl': 'assets/f1.jpg',
        'testedLd': 45.2,
        'material': 'Carbon Fiber',
        'airfoilType': 'RG15',
        'description':
            'Built entirely from spread-tow carbon fiber for maximum rigidity during high-g maneuvers. The RG15 airfoil performs exceptionally well on the slope, penetrating through turbulence with ease. Sanding the leading edge to the exact profile was the most challenging part.',
      },
      {
        'id': 's2',
        'title': 'Lightweight Thermal Floater',
        'imageUrl': 'assets/f2.jpg',
        'testedLd': 58.1,
        'material': 'Balsa Wood',
        'airfoilType': 'AG35',
        'description':
            'A traditional built-up balsa wing covered with transparent Oracover. The AG35 profile provides an incredible sink rate, allowing this 2-meter glider to catch even the lightest morning thermals. The rib spacing was optimized for weight reduction.',
      },
      {
        'id': 's3',
        'title': 'FPV Flying Wing',
        'imageUrl': 'assets/f3.jpg',
        'testedLd': 22.4,
        'material': 'EPP Foam',
        'airfoilType': 'MH45',
        'description':
            'Designed for proximity flying and durability. The EPP foam core was hot-wire cut and reinforced with carbon spars. The sweep angle and washout were carefully calculated to ensure stable flight without a vertical stabilizer.',
      },
      {
        'id': 's4',
        'title': 'Experimental Hydrofoil',
        'imageUrl': 'assets/f4.jpg',
        'testedLd': 32.8,
        'material': 'Carbon Composite',
        'airfoilType': 'NACA 0012',
        'description':
            'A custom-built mast and front wing for a hydrofoil setup. The symmetrical NACA 0012 profile was chosen for predictable pitch stability underwater. The entire assembly was vacuum-bagged in the garage to achieve the necessary structural integrity.',
      },
      {
        'id': 's5',
        'title': '3D Printed Pylon Racer',
        'imageUrl': 'assets/f5.jpg',
        'testedLd': 18.5,
        'material': 'LW-PLA',
        'airfoilType': 'MH32',
        'description':
            'Fully 3D printed using Lightweight PLA. The internal structure uses a gyroid infill pattern to save weight while maintaining the aerodynamic shape of the fast MH32 airfoil. It requires careful throttle management to prevent flutter at high speeds.',
      },
      {
        'id': 's6',
        'title': 'Vintage Nostalgia Glider',
        'imageUrl': 'assets/f6.jpg',
        'testedLd': 28.0,
        'material': 'Pine & Balsa',
        'airfoilType': 'Clark Y',
        'description':
            'A scratch-built tribute to the golden age of RC soaring. Utilizing the classic Clark Y flat-bottom airfoil makes it very easy to build on a flat workbench. It flies slowly and majestically, perfect for calm evening flights.',
      },
      {
        'id': 's7',
        'title': 'Composite DLG (Discus Launch)',
        'imageUrl': 'assets/f7.jpg',
        'testedLd': 42.1,
        'material': 'Kevlar/Carbon',
        'airfoilType': 'Zone V2',
        'description':
            'Hand-laid composite wings using Kevlar on the bias for torsional stiffness and carbon for the main spar. The Zone V2 airfoil series transitions perfectly from the root to the tip, allowing for massive launch heights and great thermal performance.',
      },
      {
        'id': 's8',
        'title': 'Indoor Micro Flyer',
        'imageUrl': 'assets/f8.jpg',
        'testedLd': 12.5,
        'material': 'Depron Foam',
        'airfoilType': 'Flat Plate',
        'description':
            'Weighing less than 50 grams, this indoor model relies on an ultra-low wing loading rather than aerodynamic efficiency. The simple flat-plate wing is braced with 1mm carbon rods. Ideal for flying in gymnasiums during the winter.',
      },
      {
        'id': 's9',
        'title': 'Dynamic Soaring Record Attempt',
        'imageUrl': 'assets/f9.jpg',
        'testedLd': 50.5,
        'material': 'Solid Carbon',
        'airfoilType': 'DS19',
        'description':
            'Built purely for speed. This airframe is essentially a solid chunk of carbon fiber molded in CNC-milled aluminum molds. The custom DS airfoil has minimal camber to reduce drag when flying through the sheer layer at over 300 mph.',
      },
      {
        'id': 's10',
        'title': 'Aerobatic 3D Plane',
        'imageUrl': 'assets/f10.jpg',
        'testedLd': 15.2,
        'material': 'Balsa & Ply',
        'airfoilType': 'Fully Symmetrical',
        'description':
            'Features massive control surfaces and a thick symmetrical airfoil for extreme post-stall maneuvers. The fuselage is a lightweight truss structure. It excels at hovering, torque rolls, and knife-edge flight.',
      },
      {
        'id': 's11',
        'title': 'Solar Powered Endurance',
        'imageUrl': 'assets/f11.jpg',
        'testedLd': 65.0,
        'material': 'Carbon Tube/Film',
        'airfoilType': 'Wortmann FX',
        'description':
            'A high-aspect-ratio wing designed to carry flexible solar cells on the upper surface. The Wortmann airfoil was selected for its high lift coefficient at low Reynolds numbers. The entire airframe is optimized for minimal power consumption.',
      },
      {
        'id': 's12',
        'title': 'Scale Warbird Fighter',
        'imageUrl': 'assets/f12.jpg',
        'testedLd': 14.8,
        'material': 'Fiberglass',
        'airfoilType': 'NACA 2412',
        'description':
            'A meticulously detailed scale model with panel lines, rivets, and weathering. The NACA 2412 airfoil provides a good compromise between scale appearance and docile stall characteristics for safe landings.',
      },
      {
        'id': 's13',
        'title': 'V-Tail Slope Combat',
        'imageUrl': 'assets/f13.jpg',
        'testedLd': 38.4,
        'material': 'Coroplast',
        'airfoilType': 'Custom Reflex',
        'description':
            'Built from corrugated plastic signs for absolute indestructibility in slope combat. It\'s heavy and requires strong wind, but the custom reflexed airfoil keeps it moving fast. You can crash it into rocks all day and keep flying.',
      },
      {
        'id': 's14',
        'title': 'Autonomous Mapping Drone',
        'imageUrl': 'assets/f14.jpg',
        'testedLd': 25.6,
        'material': 'Molded EPO',
        'airfoilType': 'Clark Y Mod',
        'description':
            'A twin-motor workhorse designed to carry heavy camera payloads for aerial surveying. The modified Clark Y provides plenty of lift, while the EPO foam construction absorbs the shock of rough autonomous landings in fields.',
      },
      {
        'id': 's15',
        'title': 'Biplane Sport Flyer',
        'imageUrl': 'assets/f15.jpg',
        'testedLd': 16.5,
        'material': 'Balsa',
        'airfoilType': 'NACA 0015',
        'description':
            'A classic staggered biplane setup. The aerodynamic interaction between the two wings creates a lot of drag, hence the low L/D ratio, but it looks fantastic in the air and is incredibly agile in roll.',
      },
      {
        'id': 's16',
        'title': 'Towing Tug Aircraft',
        'imageUrl': 'assets/f16.jpg',
        'testedLd': 19.2,
        'material': 'Plywood Box',
        'airfoilType': 'NACA 4415',
        'description':
            'A utilitarian design built to do one thing: tow large gliders to altitude. It features a robust plywood box fuselage and a high-lift NACA 4415 wing. It\'s not pretty, but it has immense pulling power and stability.',
      },
      {
        'id': 's17',
        'title': 'Electric Ducted Fan Jet',
        'imageUrl': 'assets/f17.jpg',
        'testedLd': 11.8,
        'material': 'EPS Foam',
        'airfoilType': 'Thin Symmetrical',
        'description':
            'A sleek jet model powered by an internal EDF unit. The wings are swept and utilize a very thin symmetrical airfoil to reduce drag at high speeds. The intake ducting was carefully designed to ensure smooth airflow to the fan.',
      },
      {
        'id': 's18',
        'title': 'Giant Scale Glider',
        'imageUrl': 'assets/f18.jpg',
        'testedLd': 52.4,
        'material': 'Composite Shell',
        'airfoilType': 'HQ 3.0/12',
        'description':
            'A massive 6-meter wingspan scale glider. The HQ airfoil series is specifically designed for large scale sailplanes, offering excellent thermaling capabilities and a good speed range. The wings are fully molded with a carbon D-box for strength.',
      },
    ];

    setState(() {
      showcases = allShowcases
          .where((item) => !deletedIds.contains(item['id']))
          .toList();
    });
  }

  Future<void> _deleteShowcase(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? deletedIdsJson = prefs.getString('deleted_showcases');
    List<String> deletedIds = [];
    if (deletedIdsJson != null) {
      deletedIds = List<String>.from(jsonDecode(deletedIdsJson));
    }

    if (!deletedIds.contains(id)) {
      deletedIds.add(id);
      await prefs.setString('deleted_showcases', jsonEncode(deletedIds));

      setState(() {
        showcases.removeWhere((item) => item['id'] == id);
      });
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.laminarCyan.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppTheme.laminarCyan,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AeroGallery Info',
                style: TextStyle(
                  color: AppTheme.aeroNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About This Screen',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.aeroNavy,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AeroGallery is a curated collection of community builds and aerodynamic tests. It serves as an inspiration hub for RC modeling and fluid dynamics exploration.',
                  style: TextStyle(
                    color: AppTheme.aeroNavy.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Features',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.aeroNavy,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(
                  Icons.touch_app,
                  'Tap a card to view detailed build notes, materials, and tested L/D ratios.',
                ),
                const SizedBox(height: 8),
                _buildFeatureItem(
                  Icons.more_horiz,
                  'Long-press any card to report inappropriate content or permanently remove it from your gallery.',
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.aeroNavy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Got it',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.turbulenceMagenta),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppTheme.aeroNavy.withValues(alpha: 0.8),
              height: 1.5,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    String? selectedReason;
    final TextEditingController detailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    const Icon(Icons.report_problem, color: AppTheme.stallRed),
                    const SizedBox(width: 10),
                    const Text(
                      'Report Content',
                      style: TextStyle(
                        color: AppTheme.aeroNavy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reason for reporting:',
                        style: TextStyle(
                          color: AppTheme.aeroNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedReason,
                        isExpanded: true,
                        hint: const Text('Select a reason'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.aeroNavy.withValues(alpha: 0.2),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                        items:
                            [
                              'Spam',
                              'Inappropriate Content',
                              'Copyright Violation',
                              'Other',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedReason = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Additional details:',
                        style: TextStyle(
                          color: AppTheme.aeroNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: detailController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Please provide more details...',
                          hintStyle: TextStyle(
                            color: AppTheme.aeroNavy.withValues(alpha: 0.3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.aeroNavy.withValues(alpha: 0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppTheme.laminarCyan,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Thank you for your report. We will verify and process it within 24 hours.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: AppTheme.aeroNavy,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.stallRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showOptionsSheet(BuildContext context, String id, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.aeroNavy,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.turbulenceMagenta.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.report,
                    color: AppTheme.turbulenceMagenta,
                  ),
                ),
                title: const Text(
                  'Report Content',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.stallRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.stallRed,
                  ),
                ),
                title: const Text(
                  'Remove from Gallery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.stallRed,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteShowcase(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Content permanently removed.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: AppTheme.stallRed,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(child: CustomPaint(painter: ShowcaseGridPainter())),

          // Header
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'Aero',
                        style: TextStyle(
                          color: AppTheme.aeroNavy,
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                        ),
                        children: [
                          TextSpan(
                            text: 'Gallery',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.turbulenceMagenta,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'COMMUNITY BUILDS & TESTS',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _showInfoDialog(context),
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppTheme.aeroNavy,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Positioned(
            top: 140,
            bottom: 0,
            left: 0,
            right: 0,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: showcases.length,
              itemBuilder: (context, index) {
                final item = showcases[index];
                return _buildGalleryCard(
                  context: context,
                  id: item['id'],
                  title: item['title'],
                  testedLd: item['testedLd'],
                  imageUrl: item['imageUrl'],
                  material: item['material'],
                  airfoilType: item['airfoilType'],
                  description: item['description'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard({
    required BuildContext context,
    required String id,
    required String title,
    required double testedLd,
    required String imageUrl,
    required String material,
    required String airfoilType,
    required String description,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShowcaseDetailScreen(
              title: title,
              description: description,
              imageUrl: imageUrl,
              testedLd: testedLd,
              material: material,
              airfoilType: airfoilType,
            ),
          ),
        );
      },
      onLongPress: () {
        _showOptionsSheet(context, id, title);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppTheme.aeroNavy.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              // Image
              Positioned.fill(
                child: Hero(
                  tag: imageUrl,
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppTheme.polarIce),
                  ),
                ),
              ),
              // Top Left Tag
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Text(
                    'BUILD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              // Top Right Tag
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.laminarCyan.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.laminarCyan.withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              // Gradient Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 160,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.9),
                        Colors.black.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Details
              Positioned(
                bottom: 20,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'MAT: $material  |  AERO: $airfoilType',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'TESTED L/D',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            testedLd.toString(),
                            style: const TextStyle(
                              color: AppTheme.laminarCyan,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowcaseGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.aeroNavy.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
