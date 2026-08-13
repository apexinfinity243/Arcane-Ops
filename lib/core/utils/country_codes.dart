class CountryCode {
  final String code;
  final String name;
  final String dialCode;
  final String flag;

  // ➕ Ajout de 'const' ici
  const CountryCode({
    required this.code,
    required this.name,
    required this.dialCode,
    required this.flag,
  });
}

class CountryCodes {
  // Tout le reste du fichier reste identique
  static const List<CountryCode> countries = [
    CountryCode(
      code: 'US',
      name: 'États-Unis',
      dialCode: '+1',
      flag: '🇺🇸',
    ),
    // ...
  ];

  static CountryCode getByDialCode(String dialCode) {
    try {
      return countries.firstWhere((c) => c.dialCode == dialCode);
    } catch (e) {
      return countries[0];
    }
  }

  static CountryCode getByCode(String code) {
    try {
      return countries.firstWhere((c) => c.code == code);
    } catch (e) {
      return countries[0];
    }
  }
}
