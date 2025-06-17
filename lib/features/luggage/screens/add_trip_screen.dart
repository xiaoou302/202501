import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/enhanced_form_elements.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/input_utils.dart';
import '../../../shared/utils/app_strings.dart';
import '../../../theme.dart';
import '../models/trip.dart';
import '../models/packing_item.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _packingItemController = TextEditingController();

  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 10));

  final List<PackingItem> _packingList = [];
  bool _isEditing = false;
  String? _tripId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForEditTrip();
    });
  }

  void _checkForEditTrip() {
    final trip = ModalRoute.of(context)?.settings.arguments as Trip?;
    if (trip != null) {
      setState(() {
        _isEditing = true;
        _tripId = trip.id;
        _titleController.text = trip.title;
        _startDate = trip.startDate;
        _endDate = trip.endDate;
        _packingList.addAll(trip.packingList);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _packingItemController.dispose();
    super.dispose();
  }

  void _addPackingItem() {
    InputUtils.hideKeyboard(context);

    if (_packingItemController.text.trim().isEmpty) return;

    setState(() {
      _packingList.add(PackingItem(name: _packingItemController.text.trim()));
      _packingItemController.clear();
    });
  }

  void _removePackingItem(int index) {
    setState(() {
      _packingList.removeAt(index);
    });
  }

  Future<void> _saveTrip() async {
    InputUtils.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    Trip trip;
    if (_isEditing && _tripId != null) {
      trip = Trip(
        id: _tripId,
        title: _titleController.text,
        startDate: _startDate,
        endDate: _endDate,
        packingList: List.from(_packingList),
      );
    } else {
      trip = Trip(
        title: _titleController.text,
        startDate: _startDate,
        endDate: _endDate,
        packingList: List.from(_packingList),
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final tripsJson = prefs.getString(AppConstants.prefTrips);

    List<Trip> trips = [];
    if (tripsJson != null) {
      final List<dynamic> tripsList = jsonDecode(tripsJson) as List<dynamic>;
      trips = tripsList
          .map((item) => Trip.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (_isEditing && _tripId != null) {
      final index = trips.indexWhere((t) => t.id == _tripId);
      if (index != -1) {
        trips[index] = trip;
      } else {
        trips.add(trip);
      }
    } else {
      trips.add(trip);
    }

    await prefs.setString(
      AppConstants.prefTrips,
      jsonEncode(trips.map((t) => t.toJson()).toList()),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardScaffold(
      appBar: AppBar(
          title: Text(_isEditing ? AppStrings.editTrip : AppStrings.addTrip),
          centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnhancedTextField(
                controller: _titleController,
                label: AppStrings.title,
                hint: 'Enter trip name',
                prefixIcon: const Icon(Icons.flight),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.enterTitle;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: EnhancedDatePicker(
                      selectedDate: _startDate,
                      onDateSelected: (date) {
                        setState(() {
                          _startDate = date;
                          // Ensure end date is not before start date
                          if (_endDate.isBefore(_startDate)) {
                            _endDate = _startDate.add(const Duration(days: 1));
                          }
                        });
                      },
                      label: AppStrings.startDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: EnhancedDatePicker(
                      selectedDate: _endDate,
                      onDateSelected: (date) {
                        setState(() {
                          _endDate = date;
                        });
                      },
                      label: AppStrings.endDate,
                      firstDate: _startDate,
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FormSection(
                title: AppStrings.packingList,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: EnhancedTextField(
                          controller: _packingItemController,
                          label: AppStrings.itemName,
                          hint: 'Add an item to pack',
                          prefixIcon: const Icon(Icons.shopping_bag_outlined),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _addPackingItem(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.deepPurple,
                              AppTheme.accentPurple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentPurple.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: _addPackingItem,
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                          tooltip: AppStrings.addItem,
                          iconSize: 24,
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPackingListView(),
                ],
              ),
              const SizedBox(height: 32),
              GradientButton(
                text: _isEditing ? AppStrings.save : AppStrings.addTrip,
                icon: _isEditing ? Icons.save : Icons.add,
                onPressed: _saveTrip,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackingListView() {
    if (_packingList.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.darkBlue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.deepPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.luggage_outlined,
                size: 48, color: Colors.grey.withOpacity(0.7)),
            const SizedBox(height: 12),
            Text(
              AppStrings.noItems,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.deepPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _packingList.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: AppTheme.deepPurple.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.deepPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: AppTheme.lightPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(_packingList[index].name),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _removePackingItem(index),
            ),
            dense: true,
          );
        },
      ),
    );
  }
}
