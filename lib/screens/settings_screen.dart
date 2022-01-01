import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:covid_checker/certs/certs.dart';
import 'package:covid_checker/certs/disease_agent_targeted.dart';
import 'package:covid_checker/certs/test_manufacturer_name.dart';
import 'package:covid_checker/certs/test_results.dart';
import 'package:covid_checker/certs/test_types.dart';
import 'package:covid_checker/certs/vaccine_manufacturer_name.dart';
import 'package:covid_checker/certs/vaccine_product_name.dart';
import 'package:covid_checker/certs/vaccine_prophylaxis.dart';
import 'package:covid_checker/generated/l10n.dart';
import 'package:covid_checker/widgets/molecules/logo.dart';
import 'package:flutter/material.dart';

import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:intl/intl.dart';

import '../models/settings.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    required this.settings,
    required this.updateSettings,
    Key? key,
  }) : super(key: key);

  final Settings settings;
  final void Function(Settings) updateSettings;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Settings? newSettings;
  @override
  Widget build(BuildContext context) {
    newSettings ??= widget.settings;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Logo(
              height: 50,
            ),
            Expanded(
              child: SettingsList(
                backgroundColor: Theme.of(context).backgroundColor,
                sections: [
                  SettingsSection(
                    tiles: [
                      SettingsTile(
                        title: S.of(context).language,
                        leading: const Icon(Icons.language_rounded),
                        trailing: DropdownButton(
                          items: S.delegate.supportedLocales.map((element) {
                            return DropdownMenuItem(
                              child: Text(element.languageCode),
                              value: element.languageCode,
                            );
                          }).toList(),
                          value: newSettings!.locale,
                          onChanged: (String? value) {
                            if (S.delegate.isSupported(Locale(value!))) {
                              newSettings =
                                  newSettings!.copyWith(locale: value);
                              widget.updateSettings(
                                newSettings!.copyWith(locale: value),
                              );
                            }
                          },
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).theme,
                        leading: Icon(AdaptiveTheme.of(context).mode ==
                                AdaptiveThemeMode.light
                            ? Icons.light_mode_rounded
                            : AdaptiveTheme.of(context).mode ==
                                    AdaptiveThemeMode.system
                                ? Icons.auto_awesome
                                : Icons.dark_mode_rounded),
                        trailing: DropdownButton(
                          items: [
                            DropdownMenuItem(
                              child: Text(S.of(context).light),
                              value: AdaptiveThemeMode.light,
                            ),
                            DropdownMenuItem(
                              child: Text(S.of(context).dark),
                              value: AdaptiveThemeMode.dark,
                            ),
                            DropdownMenuItem(
                              child: Text(S.of(context).system),
                              value: AdaptiveThemeMode.system,
                            ),
                          ],
                          value: AdaptiveTheme.of(context).mode,
                          onChanged: (value) {
                            if (value == AdaptiveThemeMode.system) {
                              AdaptiveTheme.of(context).setSystem();
                            } else if (value == AdaptiveThemeMode.dark) {
                              AdaptiveTheme.of(context).setDark();
                            } else {
                              AdaptiveTheme.of(context).setLight();
                            }
                          },
                        ),
                      ),
                      SettingsTile.switchTile(
                        title: S.of(context).pdamode,
                        leading: const Icon(Icons.qr_code_scanner_rounded),
                        subtitle: S.of(context).pdamodedesc,
                        switchValue: newSettings!.isPda,
                        onToggle: (bool value) {
                          setState(() {
                            newSettings = newSettings!.copyWith(isPda: value);
                            widget.updateSettings(
                              newSettings!.copyWith(isPda: value),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: S.of(context).appinfo,
                    tiles: [
                      SettingsTile(
                        title: S.of(context).appinfo,
                        leading: const Icon(Icons.info_outline_rounded),
                        onPressed: (BuildContext context) {
                          showAboutDialog(
                            context: context,
                            applicationLegalese: "Licensed under AGPL 3.0",
                            applicationVersion:
                                "By Eduardo Moreno | eduardom.dev",
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: S.of(context).infocertssection,
                    subtitle: TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Coming Soon"),
                          ),
                        );
                      },
                      icon: Icon(Icons.system_update_alt_rounded),
                      label: Text(S.of(context).updateall),
                    ),
                    tiles: [
                      SettingsTile(
                        title: S.of(context).lastcertupdate,
                        leading: const Icon(Icons.shield_rounded),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .add_jms()
                            .format(
                              DateTime.fromMillisecondsSinceEpoch(
                                (certs['iat'] as int) * 1000,
                              ),
                            ),
                        trailing: TextButton(
                          child: Text(S.of(context).update),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Coming Soon"),
                              ),
                            );
                          },
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).lasttestupdate,
                        leading: const Icon(Icons.animation_rounded),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .format(
                          DateTime.parse(
                              testManfName['valueSetDate'] as String),
                        ),
                        trailing: TextButton(
                          child: Text(S.of(context).update),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Coming Soon"),
                              ),
                            );
                          },
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).lastvaxupdate,
                        leading: const Icon(Icons.business_center_rounded),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .format(
                          DateTime.parse(vaccineMedicinalProduct['valueSetDate']
                              as String),
                        ),
                        trailing: TextButton(
                          child: Text(S.of(context).update),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Coming Soon"),
                              ),
                            );
                          },
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).lastauthholderupdate,
                        leading: const Icon(Icons.business_rounded),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .format(
                          DateTime.parse(
                              vaccineManfName['valueSetDate'] as String),
                        ),
                        trailing: TextButton(
                          child: Text(S.of(context).update),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Coming Soon"),
                              ),
                            );
                          },
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).lastdiseaseupdate,
                        leading: const Icon(Icons.radar_rounded),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .format(
                          DateTime.parse(
                              diseaseAgentTargeted['valueSetDate'] as String),
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).lasttestresult,
                        leading: const Icon(Icons.check_circle_outline),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .format(
                          DateTime.parse(testResults['valueSetDate'] as String),
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).lasttesttypeupdate,
                        leading: const Icon(Icons.merge_type_rounded),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .format(
                          DateTime.parse(testTypes['valueSetDate'] as String),
                        ),
                      ),
                      SettingsTile(
                        title: S.of(context).lastvaccineproph,
                        leading: const Icon(Icons.account_tree_rounded),
                        subtitleMaxLines: 10,
                        subtitle: DateFormat.yMMMMd(
                                Localizations.localeOf(context).countryCode)
                            .format(
                          DateTime.parse(
                              vaccineProphilaxis['valueSetDate'] as String),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
