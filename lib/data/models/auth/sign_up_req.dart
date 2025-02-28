class SignUpRequest {
  final String username;
  final String email;
  final String password;

  const SignUpRequest({
    required this.username,
    required this.email,
    required this.password,
  });
}
