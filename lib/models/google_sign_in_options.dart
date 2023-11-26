class GoogleSignInOptions {
  final String name;
  final List<GoogleSignInOption> list;
  GoogleSignInOptions(this.name, this.list);
}

class GoogleSignInOption {
  final String scopeUrl;
  final String description;
  GoogleSignInOption(this.scopeUrl, this.description);
}
