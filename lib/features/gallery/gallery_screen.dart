import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import 'widgets/gallery_card.dart';

enum SortOption { rating, title, artist }

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen>
    with SingleTickerProviderStateMixin {
  late final List<Map<String, Object>> _allGalleryItems;
  List<Map<String, Object>> _displayedItems = [];
  int _currentIndex = 0;
  SortOption _currentSort = SortOption.rating;
  late final AnimationController _arrowController;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeItems();
    _displayedItems = List.from(_allGalleryItems);
    _sortItems();

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  void _initializeItems() {
    _allGalleryItems = [
      _buildItem(
        'assets/4291772545758_.pic_hd.jpg',
        'Emerald Valley',
        'Takashi Amano',
        9.9,
        ['Nature Aquarium', 'Iwagumi', '120P'],
        '120x45x45 cm',
        'Amazonia Light',
        'Solar RGB x2',
        'Pollenc Glass Large',
        'Super Jet ES-1200',
        'Glossostigma, Eleocharis',
        'Paracheirodon axelrodi',
      ),
      _buildItem(
        'assets/4301772545759_.pic_hd.jpg',
        'Crimson Tide',
        'Josh Sim',
        9.7,
        ['Dutch Style', 'Stem Plants', '90P'],
        '90x45x45 cm',
        'Amazonia Ver.2',
        'Chihiros Vivid II',
        'Inline Diffuser',
        'Oase Biomaster 600',
        'Rotala H\'ra, Ludwigia',
        'Hemigrammus rhodostomus',
      ),
      _buildItem(
        'assets/4311772545760_.pic_hd.jpg',
        'Ancient Roots',
        'Filipe Oliveira',
        9.8,
        ['Forest', 'Detail', '60P'],
        '60x30x36 cm',
        'La Plata Sand',
        'Twinstar 600S',
        'Neo Diffuser',
        'Eheim Classic 2215',
        'Microsorum, Bolbitis',
        'Hyphessobrycon amandae',
      ),
      _buildItem(
        'assets/4321772545761_.pic_hd.jpg',
        'Mountain Range',
        'Dave Chow',
        9.6,
        ['Diorama', 'Rock', '150cm'],
        '150x60x60 cm',
        'Master Soil',
        'ADA Solar I x3',
        'Direct Injection',
        'Fluval FX6',
        'Hemianthus callitrichoides',
        'Rasbora brigittae',
      ),
      _buildItem(
        'assets/4331772545763_.pic_hd.jpg',
        'Zen Garden',
        'Masashi Ono',
        9.5,
        ['Iwagumi', 'Minimal', '60P'],
        '60x30x36 cm',
        'Amazonia Powder',
        'Aquasky RGB',
        'Dooa Diffuser',
        'Super Jet ES-300',
        'Eleocharis acicularis',
        'Green Neon Tetra',
      ),
      _buildItem(
        'assets/4341772545763_.pic_hd.jpg',
        'Dragon\'s Lair',
        'Siak Wee Yeo',
        9.4,
        ['Ryuboku', 'Wild', '90P'],
        '90x45x45 cm',
        'Tropica Soil',
        'ONF Flat One',
        'Inline Atomizer',
        'Eheim Pro 4+',
        'Cryptocoryne, Anubias',
        'Puntius titteya',
      ),
      _buildItem(
        'assets/4351772545765_.pic_hd.jpg',
        'Autumn Shade',
        'Gregoire W.',
        9.3,
        ['Wabi-Kusa', 'Shallow', '45F'],
        '45x27x20 cm',
        'River Sand',
        'Chihiros C2',
        'None',
        'Hang-on Back',
        'Ludwigia arcuata',
        'Betta splendens',
      ),
      _buildItem(
        'assets/4361772545766_.pic_hd.jpg',
        'Silent Path',
        'Yutaka Konishi',
        9.7,
        ['Nature', 'Shadow', '120P'],
        '120x45x45 cm',
        'Colorado Sand',
        'Solar RGB',
        'Pollen Glass',
        'Super Jet ES-600',
        'Vallisneria nana',
        'Trigonostigma espei',
      ),
      _buildItem(
        'assets/4371772545767_.pic_hd.jpg',
        'Moss Canyon',
        'Robertus Hartono',
        9.2,
        ['Moss', 'Detail', '30C'],
        '30x30x30 cm',
        'Amazonia',
        'ONF Nano',
        'Neo Tiny',
        'Eheim 2211',
        'Fissidens fontanus',
        'Caridina dennerli',
      ),
      _buildItem(
        'assets/4381772545768_.pic_hd.jpg',
        'River Bed',
        'Luis Cardoso',
        9.4,
        ['Biotope', 'Flow', '90P'],
        '90x45x45 cm',
        'Silica Sand',
        'Kessil A360X',
        'Pressurized',
        'Oase 350',
        'Bucephalandra',
        'Stiphodon sp.',
      ),
      _buildItem(
        'assets/4391772545769_.pic_hd.jpg',
        'Floating Island',
        'Herry Rasio',
        9.6,
        ['Avatar', 'Fantasy', '60P'],
        '60x30x36 cm',
        'Cosmetic Sand',
        'Twinstar E',
        'Inline',
        'Eheim 2213',
        'Monte Carlo, Moss',
        'Ember Tetra',
      ),
      _buildItem(
        'assets/4401772545770_.pic_hd.jpg',
        'Green Tunnel',
        'Nguyen Minh',
        9.5,
        ['Perspective', 'Depth', '90P'],
        '90x45x45 cm',
        'Amazonia',
        'Vivid II',
        'Inline',
        'Biomaster 600',
        'Rotala Green',
        'Neon Tetra',
      ),
      _buildItem(
        'assets/4411772545771_.pic_hd.jpg',
        'Red Canyon',
        'Juan Puchades',
        9.3,
        ['Rock', 'Red Plants', '60H'],
        '60x30x45 cm',
        'Controsoil',
        'Chihiros WRGB',
        'Diffuser',
        'Classic 2215',
        'Ludwigia Palustris',
        'Ruby Tetra',
      ),
      _buildItem(
        'assets/4421772545772_.pic_hd.jpg',
        'Dark Forest',
        'Matthew Israel',
        9.4,
        ['Shadow', 'Wood', '120P'],
        '120x50x50 cm',
        'Soil + Sand',
        'Kessil x2',
        'Reactor',
        'Fluval 407',
        'Bolbitis heudelotii',
        'Black Neon Tetra',
      ),
      _buildItem(
        'assets/4431772545773_.pic_hd.jpg',
        'Serenity',
        'Takayuki F.',
        9.8,
        ['Iwagumi', 'Peace', '180P'],
        '180x60x60 cm',
        'Amazonia',
        'Solar RGB x3',
        'Beetle Counter',
        'Super Jet ES-2400',
        'Eleocharis vivipara',
        'Rasbora heteromorpha',
      ),
      _buildItem(
        'assets/4441772545774_.pic_hd.jpg',
        'Chaos Theory',
        'Gary Wu',
        9.1,
        ['Jungle', 'Wild', '60P'],
        '60x30x36 cm',
        'Tropica',
        'Twinstar S',
        'Inline',
        'Eheim 2217',
        'Hygrophila pinnatifida',
        'Danio margaritatus',
      ),
      _buildItem(
        'assets/4451772545775_.pic_hd.jpg',
        'Morning Dew',
        'Adam Paszczela',
        9.5,
        ['Detail', 'Nano', '36cm'],
        '36x22x26 cm',
        'ADA Soil',
        'ONF Flat Nano',
        'Neo',
        'Eden 501',
        'Riccardia chamedryfolia',
        'Boraras maculatus',
      ),
      _buildItem(
        'assets/4461772545777_.pic_hd.jpg',
        'Stone Age',
        'Cliff Hui',
        9.7,
        ['Mountain', 'Hardscape', '90P'],
        '90x45x45 cm',
        'Platinum Soil',
        'Solar RGB',
        'Inline',
        'Biomaster',
        'Hemianthus Cuba',
        'Green Kubotai',
      ),
      _buildItem(
        'assets/4471772545780_.pic_hd.jpg',
        'The End',
        'Long Tran',
        9.9,
        ['Diorama', 'Forest', '120P'],
        '120x50x50 cm',
        'Amazonia',
        'Vivid II x2',
        'Reactor',
        'FX6',
        'Taxiphyllum sp.',
        'Paracheirodon innesi',
      ),
    ];
  }

  void _sortItems() {
    setState(() {
      switch (_currentSort) {
        case SortOption.rating:
          _displayedItems.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
          );
          break;
        case SortOption.title:
          _displayedItems.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String),
          );
          break;
        case SortOption.artist:
          _displayedItems.sort(
            (a, b) => (a['artist'] as String).compareTo(b['artist'] as String),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Stack(
        children: [
          // 1. PageView (Images Only)
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _displayedItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _displayedItems[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () => _showFullScreenImage(
                      context,
                      item['imageUrl'] as String,
                    ),
                    onLongPress: () => _showOptionsSheet(context, index),
                    child: Image.asset(
                      item['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.voidBlack),
                    ),
                  ),
                  // Gradients for text visibility (replicated from GalleryCard)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 160,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.voidBlack.withValues(alpha: 0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 320,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.voidBlack,
                            AppColors.voidBlack.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 2. Static Content Card (Changes content with animation)
          if (_displayedItems.isNotEmpty)
            Positioned(
              left: 24,
              right: 24,
              bottom: 80, // Adjusted position
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: GalleryInfoCard(
                  key: ValueKey(_displayedItems[_currentIndex]['title']),
                  title: _displayedItems[_currentIndex]['title'] as String,
                  artist: _displayedItems[_currentIndex]['artist'] as String,
                  rating: (_displayedItems[_currentIndex]['rating'] as num)
                      .toDouble(),
                  tags: _displayedItems[_currentIndex]['tags'] as List<String>,
                  onViewDetails: () =>
                      _showDetailSheet(context, _displayedItems[_currentIndex]),
                ),
              ),
            ),

          // 3. Header & Sort Button
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MASTERPIECE SHOWCASE',
                  style: TextStyle(
                    color: AppColors.starlightWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
                PopupMenuButton<SortOption>(
                  offset: const Offset(0, 40),
                  color: AppColors.deepTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppColors.floraNeon.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.deepTeal.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.arrowDownWideShort,
                        size: 14,
                        color: AppColors.starlightWhite,
                      ),
                    ),
                  ),
                  onSelected: (SortOption result) {
                    setState(() {
                      _currentSort = result;
                      _sortItems();
                      _currentIndex = 0; // Reset to top after sort
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SortOption>>[
                        PopupMenuItem<SortOption>(
                          value: SortOption.rating,
                          child: _buildSortMenuItem(
                            'Rating',
                            SortOption.rating,
                          ),
                        ),
                        PopupMenuItem<SortOption>(
                          value: SortOption.title,
                          child: _buildSortMenuItem('Name', SortOption.title),
                        ),
                        PopupMenuItem<SortOption>(
                          value: SortOption.artist,
                          child: _buildSortMenuItem(
                            'Artist',
                            SortOption.artist,
                          ),
                        ),
                      ],
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _showHelpDialog(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.deepTeal.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.question,
                        size: 14,
                        color: AppColors.starlightWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Animated Arrow Hint (Middle of screen)
          if (_currentIndex < _displayedItems.length - 1)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4, // Middle-ish
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _arrowAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _arrowAnimation.value),
                      child: Opacity(opacity: 0.7, child: child),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.voidBlack.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.starlightWhite.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.chevronDown,
                          color: AppColors.starlightWhite,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'SWIPE TO EXPLORE',
                        style: TextStyle(
                          color: AppColors.starlightWhite,
                          fontSize: 10,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSortMenuItem(String text, SortOption option) {
    final isSelected = _currentSort == option;
    return Row(
      children: [
        Icon(
          isSelected ? FontAwesomeIcons.check : FontAwesomeIcons.circle,
          size: 12,
          color: isSelected ? AppColors.floraNeon : AppColors.mossMuted,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.starlightWhite : AppColors.mossMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Map<String, Object> _buildItem(
    String img,
    String title,
    String artist,
    double rating,
    List<String> tags,
    String dim,
    String sub,
    String light,
    String co2,
    String filter,
    String plants,
    String fish,
  ) {
    return {
      'imageUrl': img,
      'title': title,
      'artist': artist,
      'rating': rating,
      'tags': tags,
      'dims': dim,
      'details': {
        'Dimensions': dim,
        'Substrate': sub,
        'Light': light,
        'CO2': co2,
        'Filter': filter,
        'Plants': plants,
        'Fish': fish,
      },
    };
  }

  void _showDetailSheet(BuildContext context, Map<String, Object> item) {
    final details = item['details'] as Map<String, String>;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: AppColors.deepTeal,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(
            top: BorderSide(color: AppColors.floraNeon.withValues(alpha: 0.2)),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mossMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        color: AppColors.starlightWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'by ${item['artist']}',
                      style: const TextStyle(
                        color: AppColors.aquaCyan,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      'ECOSYSTEM PARAMETERS',
                      style: TextStyle(
                        color: AppColors.floraNeon.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSpecRow(
                      FontAwesomeIcons.rulerCombined,
                      'Dimensions',
                      details['Dimensions']!,
                    ),
                    _buildSpecRow(
                      FontAwesomeIcons.layerGroup,
                      'Substrate',
                      details['Substrate']!,
                    ),
                    _buildSpecRow(
                      FontAwesomeIcons.lightbulb,
                      'Lighting',
                      details['Light']!,
                    ),
                    _buildSpecRow(
                      FontAwesomeIcons.wind,
                      'CO₂ System',
                      details['CO2']!,
                    ),
                    _buildSpecRow(
                      FontAwesomeIcons.fan,
                      'Filtration',
                      details['Filter']!,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: AppColors.trenchBlue),
                    ),

                    _buildSectionHeader('Flora (Plants)'),
                    const SizedBox(height: 8),
                    Text(
                      details['Plants']!,
                      style: const TextStyle(
                        color: AppColors.starlightWhite,
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Fauna (Livestock)'),
                    const SizedBox(height: 8),
                    Text(
                      details['Fish']!,
                      style: const TextStyle(
                        color: AppColors.starlightWhite,
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.trenchBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppColors.mossMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.mossMuted.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.starlightWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: AppColors.floraNeon),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.mossMuted,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(imageUrl: imageUrl),
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.deepTeal,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: AppColors.trenchBlue),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mossMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: AppColors.starlightWhite,
                  size: 20,
                ),
                title: const Text(
                  'Report',
                  style: TextStyle(color: AppColors.starlightWhite),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),
              const Divider(color: AppColors.trenchBlue, height: 1),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.trash,
                  color: AppColors.toxicityAlert,
                  size: 20,
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.toxicityAlert),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, index);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.toxicityAlert.withValues(alpha: 0.5),
          ),
        ),
        title: const Text(
          'Permanent Delete',
          style: TextStyle(color: AppColors.starlightWhite),
        ),
        content: const Text(
          'Are you sure you want to permanently delete this image? This action cannot be undone.',
          style: TextStyle(color: AppColors.mossMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.mossMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final item = _displayedItems[index];
                _displayedItems.removeAt(index);
                _allGalleryItems.removeWhere(
                  (e) => e['title'] == item['title'],
                );
                if (_currentIndex >= _displayedItems.length) {
                  _currentIndex = (_displayedItems.length - 1).clamp(0, 9999);
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image permanently deleted'),
                  backgroundColor: AppColors.deepTeal,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.toxicityAlert),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.floraNeon.withValues(alpha: 0.3)),
        ),
        title: const Text(
          'Guide',
          style: TextStyle(color: AppColors.starlightWhite),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore Masterpieces:',
              style: TextStyle(
                color: AppColors.floraNeon,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Swipe up/down to browse different aquascapes.\n'
              '• Tap "View Parameters" to see detailed specs.\n'
              '• Tap the image to view in full screen.',
              style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Manage Content:',
              style: TextStyle(
                color: AppColors.toxicityAlert,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Long press on an image to access the menu.\n'
              '• Select "Report" to flag inappropriate content.\n'
              '• Select "Delete" to permanently remove an item.',
              style: TextStyle(color: AppColors.starlightWhite, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: AppColors.floraNeon),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    String? selectedType;
    final reportTypes = [
      'Inappropriate Content',
      'Illegal',
      'Spam',
      'Copyright Infringement',
      'Other',
    ];
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              backgroundColor: AppColors.deepTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: AppColors.floraNeon.withValues(alpha: 0.3),
                ),
              ),
              title: const Text(
                'Report Image',
                style: TextStyle(color: AppColors.starlightWhite),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Reason:',
                      style: TextStyle(
                        color: AppColors.mossMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      dropdownColor: AppColors.trenchBlue,
                      value: selectedType,
                      hint: const Text(
                        'Select Type',
                        style: TextStyle(color: AppColors.mossMuted),
                      ),
                      items: reportTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: const TextStyle(
                              color: AppColors.starlightWhite,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedType = value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.voidBlack,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Details:',
                      style: TextStyle(
                        color: AppColors.mossMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: textController,
                      maxLines: 3,
                      maxLength: 200,
                      style: const TextStyle(color: AppColors.starlightWhite),
                      decoration: InputDecoration(
                        hintText: 'Enter details (max 200 chars)...',
                        hintStyle: TextStyle(
                          color: AppColors.mossMuted.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: AppColors.voidBlack,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        counterStyle: const TextStyle(
                          color: AppColors.mossMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.mossMuted),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a reason'),
                          backgroundColor: AppColors.toxicityAlert,
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.deepTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: AppColors.floraNeon.withValues(alpha: 0.5),
                          ),
                        ),
                        title: const Icon(
                          FontAwesomeIcons.circleCheck,
                          color: AppColors.floraNeon,
                          size: 48,
                        ),
                        content: const Text(
                          'Report submitted. We will review it within 24 hours and take appropriate action.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.starlightWhite),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'OK',
                              style: TextStyle(color: AppColors.floraNeon),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: AppColors.floraNeon),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(child: Image.asset(imageUrl, fit: BoxFit.contain)),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.xmark,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
