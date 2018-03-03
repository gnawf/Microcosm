import "package:app/models/novel.dart";
import "package:app/widgets/novel_sliver_grid.dart";
import "package:app/widgets/settings_icon_button.dart";
import "package:flutter/material.dart";

class RecentsPage extends StatelessWidget {
  const RecentsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: const Text("Recently Read"),
        centerTitle: false,
        actions: const <Widget>[
          const SettingsIconButton(),
        ],
      ),
      body: new CustomScrollView(
        slivers: const <Widget>[
          const SliverPadding(
            padding: const EdgeInsets.only(
              top: 24.0,
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            sliver: const NovelSliverGrid(
              novels: const <Novel>[
                const Novel(
                  slug: "awe-index",
                  name: "A Will Eternal",
                  posterImage:
                      "https://cdn.novelupdates.com/images/2016/06/betacover.jpg",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
