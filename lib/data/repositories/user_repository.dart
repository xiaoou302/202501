import '../models/user_model.dart';
import '../datasources/mock_data.dart';

class UserRepository {
  UserModel? _currentUser;

  UserRepository() {
    _currentUser = MockData.getCurrentUser();
  }

  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser!;
  }

  Future<void> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = user;
  }
}
