class AuthService {
  static bool isLoggedIn = false;

  // simulacija baze korisnika
  static final Map<String, String> users = {
    'test@test.com': '1234',
  };
}