import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/nav_bar.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/date_utils.dart';
import '../../../shared/utils/input_utils.dart';
import '../../../shared/utils/app_strings.dart';
import '../../../theme.dart';
import '../models/trip.dart';
import '../models/packing_item.dart';
import '../widgets/trip_card.dart';
import '../../../routes.dart';

class LuggageScreen extends StatefulWidget {
  final bool useNavBar;

  const LuggageScreen({super.key, this.useNavBar = true});

  @override
  State<LuggageScreen> createState() => _LuggageScreenState();
}

class _LuggageScreenState extends State<LuggageScreen>
    with SingleTickerProviderStateMixin {
  List<Trip> trips = [];
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadTrips();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    final prefs = await SharedPreferences.getInstance();

    final tripsJson = prefs.getString(AppConstants.prefTrips);
    if (tripsJson != null) {
      final List<dynamic> tripsList = jsonDecode(tripsJson) as List<dynamic>;
      setState(() {
        trips = tripsList
            .map((item) => Trip.fromJson(item as Map<String, dynamic>))
            .toList();

        // Sort by start date (nearest first)
        trips.sort((a, b) => a.startDate.compareTo(b.startDate));
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _updateTrip(Trip updatedTrip) async {
    final index = trips.indexWhere((trip) => trip.id == updatedTrip.id);
    if (index != -1) {
      setState(() {
        trips[index] = updatedTrip;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.prefTrips,
        jsonEncode(trips.map((t) => t.toJson()).toList()),
      );
    }
  }

  Future<void> _deleteTrip(String tripId) async {
    setState(() {
      trips.removeWhere((trip) => trip.id == tripId);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefTrips,
      jsonEncode(trips.map((t) => t.toJson()).toList()),
    );
  }

  Future<void> _showAddItemDialog(Trip trip) async {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.addItem),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: AppStrings.itemName,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.enterItemName;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, textController.text.trim());
              }
            },
            child: Text(AppStrings.addItem),
          ),
        ],
      ),
    );

    if (result != null) {
      final newItem = PackingItem(name: result);
      final updatedPackingList = List<PackingItem>.from(trip.packingList)
        ..add(newItem);
      final updatedTrip = trip.copyWith(packingList: updatedPackingList);
      _updateTrip(updatedTrip);
    }
  }

  int _getUpcomingTripsCount() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return trips
        .where(
          (trip) =>
              trip.startDate.isAtSameMomentAs(tomorrow) ||
              trip.startDate.isAfter(now) &&
                  trip.startDate.isBefore(
                    tomorrow.add(const Duration(days: 7)),
                  ),
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DismissKeyboardScaffold(
      appBar: AppBar(
        title: Text(AppStrings.luggage),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(child: _buildContent()),
          if (widget.useNavBar) const AppNavBar(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Get screen size to adapt UI for small screens
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = screenSize.width < 360 ? 12.0 : 16.0;

    return ListView(
      padding: EdgeInsets.all(horizontalPadding),
      children: [
        _buildHeader(),
        SizedBox(height: screenSize.width < 360 ? 12.0 : 16.0),
        if (trips.isEmpty)
          _buildEmptyState()
        else
          ...trips.map(
            (trip) => Padding(
              padding:
                  EdgeInsets.only(bottom: screenSize.width < 360 ? 12.0 : 16.0),
              child: TripCard(
                trip: trip,
                onTripUpdated: _updateTrip,
                onDelete: () => _deleteTrip(trip.id),
                onEdit: () => Navigator.pushNamed(
                  context,
                  AppRoutes.addTrip,
                  arguments: trip,
                ).then((_) => _loadTrips()),
              ),
            ),
          ),
        SizedBox(height: screenSize.width < 360 ? 12.0 : 16.0),
        _buildTipCard(),
      ],
    );
  }

  Widget _buildEmptyState() {
    // Get screen size to adapt UI for small screens
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final iconSize = isSmallScreen ? 120.0 : 150.0;
    final iconInnerSize = isSmallScreen ? 60.0 : 80.0;

    return Column(
      children: [
        AppCard(
          padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 30 : 40,
              horizontal: isSmallScreen ? 16 : 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _animation,
                child: Container(
                  height: iconSize,
                  width: iconSize,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentPurple.withOpacity(0.7),
                        AppTheme.deepPurple.withOpacity(0.3),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flight_takeoff,
                    size: iconInnerSize,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Text(
                AppStrings.noTrips,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              const Text(
                "Create your first trip and start planning your perfect journey!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              GradientButton(
                text: "Create First Trip",
                icon: Icons.add_circle,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.addTrip,
                  ).then((_) => _loadTrips());
                },
                fullWidth: true,
              ),
            ],
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        _buildSuggestedDestinations(),
      ],
    );
  }

  Widget _buildSuggestedDestinations() {
    final destinations = [
      {'name': 'Paris', 'icon': Icons.location_city},
      {'name': 'Tokyo', 'icon': Icons.temple_buddhist},
      {'name': 'New York', 'icon': Icons.location_city},
      {'name': 'Maldives', 'icon': Icons.beach_access},
    ];

    // Get screen size to adapt UI for small screens
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final cardWidth = isSmallScreen ? 90.0 : 100.0;
    final cardHeight = isSmallScreen ? 90.0 : 100.0;
    final iconSize = isSmallScreen ? 28.0 : 32.0;
    final fontSize = isSmallScreen ? 12.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 8.0, bottom: isSmallScreen ? 8.0 : 12.0),
          child: Text(
            "Popular Destinations",
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return Padding(
                padding: EdgeInsets.only(right: isSmallScreen ? 8 : 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.addTrip,
                    ).then((_) => _loadTrips());
                  },
                  child: Container(
                    width: cardWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.deepPurple,
                          AppTheme.accentPurple,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentPurple.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          destination['icon'] as IconData,
                          color: Colors.white,
                          size: iconSize,
                        ),
                        SizedBox(height: isSmallScreen ? 6 : 8),
                        Text(
                          destination['name'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final upcomingTripsCount = _getUpcomingTripsCount();
    // Get screen size to adapt UI for small screens
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.luggage, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              AppStrings.travelPlans,
              style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold),
            ),
            if (upcomingTripsCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: isSmallScreen ? 2 : 4),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purpleAccent),
                ),
                child: Text(
                  '$upcomingTripsCount ${AppStrings.upcomingTrips}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
            ],
          ],
        ),
        GradientButton(
          text: AppStrings.addPlan,
          icon: Icons.add,
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoutes.addTrip,
            ).then((_) => _loadTrips());
          },
        ),
      ],
    );
  }

  Widget _buildTipCard() {
    final travelTips = [
      "Make a packing checklist to ensure you don't forget essentials.",
      "Roll your clothes instead of folding to save space in your luggage.",
      "Keep important documents in a separate, easily accessible pouch.",
      "Pack a portable charger for your electronic devices.",
      "Always bring a basic first-aid kit for emergencies.",
    ];

    final randomTip =
        travelTips[DateTime.now().millisecond % travelTips.length];

    // Get screen size to adapt UI for small screens
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Travel Tips',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            randomTip,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
