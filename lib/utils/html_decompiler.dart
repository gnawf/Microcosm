import "package:app/utils/html_utils.dart" as utils;
import "package:html/dom.dart";
import "package:html/parser.dart" as html show parseFragment;

/// Decompiles HTML to markdown
String decompile(String content, [Uri source]) {
  final fragment = html.parseFragment(content);

  // Unwrap the paragraphs
  fragment.querySelectorAll("p,div").forEach((block) {
    // If there are no children, simply unwrap by removing the node
    if (block.nodes.isEmpty) {
      block.remove();
      return;
    }

    // Replace consecutive spaces with one space
    block.innerHtml = block.innerHtml.replaceAll(RegExp(r"\s{2,}"), " ");

    // Add padding
    block.nodes.insert(0, Text("\n"));
    block.nodes.add(Text("\n"));

    utils.unwrap(block);
  });

  // Replace line breaks with lines
  fragment.querySelectorAll("br").forEach((br) {
    br.replaceWith(Text("\n"));
  });

  // Replace text formatting with markdown equivalent
  fragment.querySelectorAll("em,b,strong").forEach((text) {
    // If there are no children, simply unwrap by removing the node
    if (text.nodes.isEmpty) {
      text.remove();
      return;
    }

    utils.traverse(text, (node) {
      if (node is Text) {
        switch (text.localName) {
          case "b":
          case "strong":
            node.replaceWith(Text("__${node.text}__"));
            break;
          case "em":
            node.replaceWith(Text("_${node.text}_"));
            break;
        }
      }

      return true;
    });

    utils.unwrap(text);
  });

  // Replace em with markdown equivalent
  fragment.querySelectorAll("a[href]").forEach((anchor) {
    final text = anchor.text.trim();
    // Ignore if there is no text i.e. link is invalid
    if (text.isEmpty) {
      return;
    }
    final href = anchor.attributes["href"];
    final link = source?.resolve(href)?.toString() ?? href;
    anchor.replaceWith(Text("[$text]($link)"));
  });

  fragment.querySelectorAll("ol").forEach((list) {
    final items = list.querySelectorAll("> li");

    // Add numbers before list items then unwrap them
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final index = Text("${i + 1}. ");
      item.nodes.insert(0, index);
      utils.unwrap(item);
    }

    // Surround with lines & unwrap list
    list.nodes.insert(0, Text("\n"));
    list.nodes.add(Text("\n"));
    utils.unwrap(list);
  });

  fragment.querySelectorAll("ul").forEach((list) {
    // Add bullet points before list items then unwrap them
    list.querySelectorAll("> li").forEach((item) {
      final index = Text("* ");
      item.nodes.insert(0, index);
      utils.unwrap(item);
    });

    // Surround with lines & unwrap list
    list.nodes.insert(0, Text("\n"));
    list.nodes.add(Text("\n"));
    utils.unwrap(list);
  });

  // 1. Split by lines
  // 2. Trim lines
  // 3. Remove empty lines
  // 4. Join by an empty line in between
  // Without the invisible character, the lines are collapsed
  return fragment.text.split("\n").map(_trim).where((x) => x.isNotEmpty).join("\n\n");
}

String _trim(String text) {
  // Remove any whitespace and keep random characters
  return text.replaceAllMapped(RegExp(r"^[^a-zA-Z0-9]+"), (match) {
    // If there's no text in the line, remove it
    if (match[0].length == text.length) {
      return "";
    }

    // Preserve whitespace for lists
    if (match[0].startsWith("* ")) {
      return match[0].replaceAll(RegExp(r"\s{2,}"), " ");
    }
    return match[0].replaceAll(RegExp(r"\s+"), "");
  }).replaceAllMapped(RegExp(r"[^a-zA-Z0-9]+$"), (match) {
    return match[0].replaceAll(RegExp(r"\s+"), "");
  });
}
