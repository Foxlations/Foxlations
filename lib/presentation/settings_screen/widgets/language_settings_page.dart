import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';

/// Lets the user pick the app UI language, or follow the system default.
///
/// The list is driven by [AppLocalizations.supportedLocales], so every language
/// added under `lib/l10n/` (e.g. a community translation merged via Weblate)
/// shows up here automatically — including its native name, with no code change
/// needed, as long as its code is in [_nativeNames] below. This page's own
/// strings come from the ARBs, so it re-renders in the chosen language the
/// instant it's picked — the quickest way to confirm localization is live.
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  // Native (endonym) display name per language code. Covers the common
  // languages community translators are likely to add so new locales render
  // with their own name automatically; anything not listed falls back to the
  // language code (see [_displayName]).
  static const _nativeNames = <String, String>{
    'en': 'English',
    'es': 'Español',
    'pt': 'Português',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'ja': '日本語',
    'zh': '中文',
    'ar': 'العربية',
    'ko': '한국어',
    'ru': 'Русский',
    'uk': 'Українська',
    'pl': 'Polski',
    'nl': 'Nederlands',
    'tr': 'Türkçe',
    'vi': 'Tiếng Việt',
    'th': 'ไทย',
    'id': 'Bahasa Indonesia',
    'in': 'Bahasa Indonesia', // legacy code for Indonesian
    'ms': 'Bahasa Melayu',
    'hi': 'हिन्दी',
    'bn': 'বাংলা',
    'fa': 'فارسی',
    'he': 'עברית',
    'iw': 'עברית', // legacy code for Hebrew
    'cs': 'Čeština',
    'sk': 'Slovenčina',
    'sv': 'Svenska',
    'da': 'Dansk',
    'fi': 'Suomi',
    'nb': 'Norsk bokmål',
    'nn': 'Norsk nynorsk',
    'no': 'Norsk',
    'el': 'Ελληνικά',
    'hu': 'Magyar',
    'ro': 'Română',
    'bg': 'Български',
    'sr': 'Српски',
    'hr': 'Hrvatski',
    'ca': 'Català',
    'eu': 'Euskara',
    'gl': 'Galego',
    'fil': 'Filipino',
    'ceb': 'Cebuano',
    'jv': 'Basa Jawa',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'ml': 'മലയാളം',
    'kn': 'ಕನ್ನಡ',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'pa': 'ਪੰਜਾਬੀ',
    'ur': 'اردو',
    'my': 'မြန်မာ',
    'km': 'ខ្មែរ',
    'ka': 'ქართული',
    'am': 'አማርኛ',
    'az': 'Azərbaycan',
    'be': 'Беларуская',
    'kk': 'Қазақ',
    'uz': 'Oʻzbek',
    'eo': 'Esperanto',
    'lt': 'Lietuvių',
    'lv': 'Latviešu',
    'et': 'Eesti',
    'sl': 'Slovenščina',
    'sq': 'Shqip',
    'is': 'Íslenska',
    'ga': 'Gaeilge',
    'cy': 'Cymraeg',
    'af': 'Afrikaans',
    'sw': 'Kiswahili',
    'ne': 'नेपाली',
    'si': 'සිංහල',
    'as': 'অসমীয়া',
    'sa': 'संस्कृतम्',
    'tt': 'Татар',
  };

  // Country/script suffixes worth spelling out when a language has more than one
  // regional variant (e.g. Chinese Simplified/Traditional, BR vs PT Portuguese).
  static const _regionNames = <String, String>{
    'CN': '简体',
    'TW': '繁體',
    'HK': '繁體',
    'BR': 'Brasil',
    'PT': 'Portugal',
    'Hans': '简体',
    'Hant': '繁體',
  };

  String _displayName(Locale l) {
    final base = _nativeNames[l.languageCode] ?? l.languageCode;
    final region = l.countryCode?.isNotEmpty == true
        ? l.countryCode!
        : (l.scriptCode ?? '');
    if (region.isEmpty) return base;
    final regionLabel = _regionNames[region] ?? region;
    return '$base ($regionLabel)';
  }

  bool _isSelected(Locale? current, Locale option) =>
      current != null &&
      current.languageCode == option.languageCode &&
      current.countryCode == option.countryCode;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final current = context.watch<LocaleProvider>().locale;

    // Sort the offered languages by their display name so a growing community
    // list stays alphabetical instead of ARB-file order.
    final locales = AppLocalizations.supportedLocales.toList()
      ..sort((a, b) =>
          _displayName(a).toLowerCase().compareTo(_displayName(b).toLowerCase()));

    Widget tile({
      required String label,
      required bool selected,
      required VoidCallback onTap,
      IconData? leading,
    }) {
      return ListTile(
        leading: leading != null ? Icon(leading, color: cs.primary) : null,
        title: Text(label),
        trailing: selected ? Icon(Icons.check_rounded, color: cs.primary) : null,
        onTap: onTap,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsLanguageTitle)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              t.settingsLanguageHeader,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
          ),
          tile(
            label: t.settingsLanguageSystemDefault,
            selected: current == null,
            leading: Icons.smartphone_rounded,
            onTap: () => context.read<LocaleProvider>().setLocale(null),
          ),
          const Divider(height: 1),
          ...locales.map(
            (l) => tile(
              label: _displayName(l),
              selected: _isSelected(current, l),
              onTap: () => context.read<LocaleProvider>().setLocale(l),
            ),
          ),
        ],
      ),
    );
  }
}
