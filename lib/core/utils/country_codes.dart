class CountryCode {
  final String code;
  final String name;
  final String dialCode;
  final String flag;

  // Ajout de 'const' ici pour permettre l'utilisation dans une liste const
  const CountryCode({
    required this.code,
    required this.name,
    required this.dialCode,
    required this.flag,
  });
}

class CountryCodes {
  static const List<CountryCode> countries = [
    CountryCode(
      code: 'US',
      name: 'États-Unis',
      dialCode: '+1',
      flag: '🇺🇸',
    ),
    CountryCode(
      code: 'CA',
      name: 'Canada',
      dialCode: '+1',
      flag: '🇨🇦',
    ),
    CountryCode(
      code: 'FR',
      name: 'France',
      dialCode: '+33',
      flag: '🇫🇷',
    ),
    CountryCode(
      code: 'BE',
      name: 'Belgique',
      dialCode: '+32',
      flag: '🇧🇪',
    ),
    CountryCode(
      code: 'CH',
      name: 'Suisse',
      dialCode: '+41',
      flag: '🇨🇭',
    ),
    CountryCode(
      code: 'DE',
      name: 'Allemagne',
      dialCode: '+49',
      flag: '🇩🇪',
    ),
    CountryCode(
      code: 'IT',
      name: 'Italie',
      dialCode: '+39',
      flag: '🇮🇹',
    ),
    CountryCode(
      code: 'ES',
      name: 'Espagne',
      dialCode: '+34',
      flag: '🇪🇸',
    ),
    CountryCode(
      code: 'GB',
      name: 'Royaume-Uni',
      dialCode: '+44',
      flag: '🇬🇧',
    ),
    CountryCode(
      code: 'NL',
      name: 'Pays-Bas',
      dialCode: '+31',
      flag: '🇳🇱',
    ),
    CountryCode(
      code: 'CD',
      name: 'République Démocratique du Congo',
      dialCode: '+243',
      flag: '🇨🇩',
    ),
    CountryCode(
      code: 'CG',
      name: 'République du Congo',
      dialCode: '+242',
      flag: '🇨🇬',
    ),
    CountryCode(
      code: 'CI',
      name: 'Côte d\'Ivoire',
      dialCode: '+225',
      flag: '🇨🇮',
    ),
    CountryCode(
      code: 'SN',
      name: 'Sénégal',
      dialCode: '+221',
      flag: '🇸🇳',
    ),
    CountryCode(
      code: 'BJ',
      name: 'Bénin',
      dialCode: '+229',
      flag: '🇧🇯',
    ),
    CountryCode(
      code: 'TG',
      name: 'Togo',
      dialCode: '+228',
      flag: '🇹🇬',
    ),
    CountryCode(
      code: 'CM',
      name: 'Cameroun',
      dialCode: '+237',
      flag: '🇨🇲',
    ),
    CountryCode(
      code: 'GA',
      name: 'Gabon',
      dialCode: '+241',
      flag: '🇬🇦',
    ),
    CountryCode(
      code: 'KE',
      name: 'Kenya',
      dialCode: '+254',
      flag: '🇰🇪',
    ),
    CountryCode(
      code: 'UG',
      name: 'Ouganda',
      dialCode: '+256',
      flag: '🇺🇬',
    ),
    CountryCode(
      code: 'TZ',
      name: 'Tanzanie',
      dialCode: '+255',
      flag: '🇹🇿',
    ),
    CountryCode(
      code: 'ET',
      name: 'Éthiopie',
      dialCode: '+251',
      flag: '🇪🇹',
    ),
    CountryCode(
      code: 'ZA',
      name: 'Afrique du Sud',
      dialCode: '+27',
      flag: '🇿🇦',
    ),
    CountryCode(
      code: 'EG',
      name: 'Égypte',
      dialCode: '+20',
      flag: '🇪🇬',
    ),
    CountryCode(
      code: 'MA',
      name: 'Maroc',
      dialCode: '+212',
      flag: '🇲🇦',
    ),
    CountryCode(
      code: 'TN',
      name: 'Tunisie',
      dialCode: '+216',
      flag: '🇹🇳',
    ),
    CountryCode(
      code: 'DZ',
      name: 'Algérie',
      dialCode: '+213',
      flag: '🇩🇿',
    ),
    CountryCode(
      code: 'CN',
      name: 'Chine',
      dialCode: '+86',
      flag: '🇨🇳',
    ),
    CountryCode(
      code: 'JP',
      name: 'Japon',
      dialCode: '+81',
      flag: '🇯🇵',
    ),
    CountryCode(
      code: 'IN',
      name: 'Inde',
      dialCode: '+91',
      flag: '🇮🇳',
    ),
    CountryCode(
      code: 'BR',
      name: 'Brésil',
      dialCode: '+55',
      flag: '🇧🇷',
    ),
    CountryCode(
      code: 'MX',
      name: 'Mexique',
      dialCode: '+52',
      flag: '🇲🇽',
    ),
    CountryCode(
      code: 'AR',
      name: 'Argentine',
      dialCode: '+54',
      flag: '🇦🇷',
    ),
  ];

  static CountryCode getByDialCode(String dialCode) {
    try {
      return countries.firstWhere((c) => c.dialCode == dialCode);
    } catch (e) {
      return countries[0]; // Default to US
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
