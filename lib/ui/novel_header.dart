import "package:app/models/novel.dart";
import "package:app/widgets/image_view.dart";
import "package:flutter/material.dart";

class NovelHeader extends StatelessWidget {
  const NovelHeader(this.novel);

  final Novel novel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const posterImageAspectRatio = 102.0 / 145.0;

    return Material(
      color: theme.cardColor,
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 24.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 160.0 * posterImageAspectRatio,
              height: 160.0,
              margin: const EdgeInsets.only(
                bottom: 4.0,
              ),
              child: Hero(
                tag: novel.slug,
                child: ImageView(
                  image: novel.posterImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      novel.synopsis ?? "",
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
