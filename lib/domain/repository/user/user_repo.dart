abstract class UserRepository {

  Future<void> getUserInfo();
  Future<List> getContacts();
}