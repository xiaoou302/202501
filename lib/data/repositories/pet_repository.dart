import 'dart:convert';
import '../models/pet_model.dart';
import '../models/reminder_model.dart';
import '../models/growth_track_model.dart';
import '../services/local_storage_service.dart';
import '../services/mock_data_service.dart';
import '../../core/constants/app_constants.dart';

class PetRepository {
  final LocalStorageService _storage;

  PetRepository(this._storage);

  Future<List<Pet>> getAllPets() async {
    final json = await _storage.getString(StorageKeys.pets);

    if (json == null || json.isEmpty) {
      // Return empty list - user starts from scratch
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(json);
      return decoded.map((item) => Pet.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Pet?> getPetById(String id) async {
    final pets = await getAllPets();
    try {
      return pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addPet(Pet pet) async {
    final pets = await getAllPets();
    pets.add(pet);
    await _savePets(pets);
  }

  Future<void> updatePet(Pet pet) async {
    final pets = await getAllPets();
    final index = pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      pets[index] = pet;
      await _savePets(pets);
    }
  }

  Future<void> archivePet(String petId) async {
    final pets = await getAllPets();
    final index = pets.indexWhere((p) => p.id == petId);
    if (index != -1) {
      pets[index] = pets[index].copyWith(isActive: false);
      await _savePets(pets);
    }
  }

  Future<void> _savePets(List<Pet> pets) async {
    final json = jsonEncode(pets.map((p) => p.toJson()).toList());
    await _storage.setString(StorageKeys.pets, json);
  }

  // Reminders
  Future<List<Reminder>> getRemindersForPet(String petId) async {
    final json = await _storage.getString(StorageKeys.reminders);

    if (json == null || json.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(json);
      final allReminders = decoded
          .map((item) => Reminder.fromJson(item))
          .toList();
      return allReminders.where((r) => r.petId == petId).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    final json = await _storage.getString(StorageKeys.reminders);
    List<Reminder> reminders = [];

    if (json != null && json.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(json);
        reminders = decoded.map((item) => Reminder.fromJson(item)).toList();
      } catch (e) {
        // Ignore error
      }
    }

    reminders.add(reminder);
    await _saveReminders(reminders);
  }

  Future<void> completeReminder(String reminderId) async {
    final json = await _storage.getString(StorageKeys.reminders);
    if (json == null || json.isEmpty) return;

    try {
      final List<dynamic> decoded = jsonDecode(json);
      final reminders = decoded.map((item) => Reminder.fromJson(item)).toList();
      final index = reminders.indexWhere((r) => r.id == reminderId);

      if (index != -1) {
        reminders[index] = reminders[index].copyWith(isCompleted: true);
        await _saveReminders(reminders);
      }
    } catch (e) {
      // Ignore error
    }
  }

  Future<void> _saveReminders(List<Reminder> reminders) async {
    final json = jsonEncode(reminders.map((r) => r.toJson()).toList());
    await _storage.setString(StorageKeys.reminders, json);
  }

  // Growth Tracks
  Future<List<GrowthTrack>> getGrowthTracksForPet(String petId) async {
    final json = await _storage.getString(StorageKeys.growthTracks);

    if (json == null || json.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(json);
      final allTracks = decoded
          .map((item) => GrowthTrack.fromJson(item))
          .toList();
      return allTracks.where((t) => t.petId == petId).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addGrowthTrack(GrowthTrack track) async {
    final json = await _storage.getString(StorageKeys.growthTracks);
    List<GrowthTrack> tracks = [];

    if (json != null && json.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(json);
        tracks = decoded.map((item) => GrowthTrack.fromJson(item)).toList();
      } catch (e) {
        // Ignore error
      }
    }

    tracks.add(track);
    await _saveGrowthTracks(tracks);
  }

  Future<void> _saveGrowthTracks(List<GrowthTrack> tracks) async {
    final json = jsonEncode(tracks.map((t) => t.toJson()).toList());
    await _storage.setString(StorageKeys.growthTracks, json);
  }
}
