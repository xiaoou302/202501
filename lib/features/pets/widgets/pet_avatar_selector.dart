import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/pet_model.dart';

class PetAvatarSelector extends StatelessWidget {
  final List<Pet> pets;
  final Pet? selectedPet;
  final Function(Pet) onPetSelected;
  final VoidCallback? onAddPet;

  const PetAvatarSelector({
    Key? key,
    required this.pets,
    required this.selectedPet,
    required this.onPetSelected,
    this.onAddPet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
        itemCount: pets.length + 1,
        itemBuilder: (context, index) {
          if (index == pets.length) {
            return _buildAddButton();
          }

          final pet = pets[index];
          final isSelected = selectedPet?.id == pet.id;

          return GestureDetector(
            onTap: () => onPetSelected(pet),
            child: Padding(
              padding: const EdgeInsets.only(right: AppConstants.spacingM),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppConstants.softCoral
                            : Colors.transparent,
                        width: 4,
                      ),
                    ),
                    child: pet.avatarUrl != null
                        ? ClipOval(
                            child: Image.file(
                              File(pet.avatarUrl!),
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const CircleAvatar(
                                  radius: 36,
                                  child: Icon(Icons.pets, size: 32),
                                );
                              },
                            ),
                          )
                        : const CircleAvatar(
                            radius: 36,
                            child: Icon(Icons.pets, size: 32),
                          ),
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    pet.name,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? AppConstants.softCoral : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddPet,
      child: Padding(
        padding: const EdgeInsets.only(right: AppConstants.spacingM),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(
                  color: AppConstants.mediumGray,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 24,
                color: AppConstants.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
