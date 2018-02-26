import "package:app/providers/chapter_provider.dart";
import "package:app/settings/settings.dart";
import "package:app/ui/app.dart";
import "package:flutter/material.dart";

void main() {
  runApp(
    const Settings(
      child: const ChapterProvider(
        child: const App(),
      ),
    ),
  );
}
