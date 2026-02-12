class AuthService {
  static bool isLoggedIn = false;
  static bool isAdmin = false;

  static final Map<String, String> users = {
    'test@test.com': '1234',
    'admin@admin.com': 'admin123',
  };

  static void login(String email) {
    isLoggedIn = true;
    isAdmin = email == 'admin@admin.com';
  }

  static void logout() {
    isLoggedIn = false;
    isAdmin = false;
  }
}