import "package:app/dialogs/color_picker_dialog.dart";
import "package:app/dialogs/font_size_picker_dialog.dart";
import "package:app/settings/settings.dart";
import "package:app/widgets/md_icons.dart";
import "package:flutter/material.dart";

class SettingsPage extends StatelessWidget {
  // Don't use const here, optimizations break the states
  // ignore: prefer_const_constructors_in_immutables
  SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const BackButton(),
        title: const Text("Settings"),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 8.0,
        ),
        children: <Widget>[
          _DarkThemeSetting(),
          _AmoledSetting(),
          const _PrimaryColorSetting(),
          const _AccentColorSetting(),
          const _ReaderFontSizeSetting(),
        ],
      ),
    );
  }
}

class _DarkThemeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Settings.of(context);

    return CheckboxListTile(
      value: settings.brightness == Brightness.dark,
      onChanged: (value) {
        settings.brightness = value ? Brightness.dark : Brightness.light;
      },
      title: const Text("Dark Theme"),
      secondary: const Icon(MDIcons.weatherNight),
    );
  }
}

class _AmoledSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Settings.of(context);

    return CheckboxListTile(
      value: settings.amoled,
      onChanged: settings.brightness == Brightness.dark ? (value) => settings.amoled = value : null,
      title: const Text("Amoled Mode"),
      secondary: const Icon(MDIcons.imageFilterBlackWhite),
    );
  }
}

class _PrimaryColorSetting extends StatelessWidget {
  const _PrimaryColorSetting();

  @override
  Widget build(BuildContext context) {
    final settings = Settings.of(context);

    return ListTile(
      enabled: settings.brightness == Brightness.light,
      leading: const Icon(MDIcons.palette),
      title: const Text("Primary Color"),
      trailing: _TrailingColorIndicator(
        color: settings.primarySwatch,
      ),
      onTap: () async {
        final color = await openPrimarySwatchPicker(
          context,
          selected: settings.primarySwatch,
        );
        if (color != null) {
          settings.primarySwatch = color;
        }
      },
    );
  }
}

class _AccentColorSetting extends StatelessWidget {
  const _AccentColorSetting();

  @override
  Widget build(BuildContext context) {
    final settings = Settings.of(context);

    return ListTile(
      leading: const Icon(MDIcons.eyedropper),
      title: const Text("Accent Color"),
      trailing: _TrailingColorIndicator(
        color: settings.accentColor,
      ),
      onTap: () async {
        final color = await openAccentColorPicker(
          context,
          selected: settings.accentColor,
        );
        if (color != null) {
          settings.accentColor = color;
        }
      },
    );
  }
}

class _TrailingColorIndicator extends StatelessWidget {
  const _TrailingColorIndicator({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 14.5,
      ),
      child: Container(
        width: 18.0,
        height: 18.0,
        color: color,
      ),
    );
  }
}

class _ReaderFontSizeSetting extends StatefulWidget {
  const _ReaderFontSizeSetting();

  @override
  State createState() => _ReaderFontSizeSettingState();
}

class _ReaderFontSizeSettingState extends State<_ReaderFontSizeSetting> {
  @override
  Widget build(BuildContext context) {
    final settings = Settings.of(context);

    return ListTile(
      leading: const Icon(MDIcons.formatFont),
      title: const Text("Reader Font Size"),
      trailing: Text("${settings.readerFontSize}px"),
      onTap: () async {
        final value = await showFontSizePickerDialog(
          context: context,
          title: const Text("Reader Font Size"),
          min: 8.0,
          max: 24.0,
          value: settings.readerFontSize,
          defaultValue: settings.defaultReaderFontSize,
        );
        if (value != null) {
          setState(() => settings.readerFontSize = value);
        }
      },
    );
  }
}
