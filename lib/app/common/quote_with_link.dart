import 'package:chat/common.dart';
import 'package:characters/characters.dart';

quoteWithLink(String quote, String id) {
  final maxLength = 100;
  // remove line
  var quoteWithoutLine = quote.replaceAll(('\n'), ' ');
  if (quoteWithoutLine.length > maxLength) {
    quoteWithoutLine = quoteWithoutLine.characters.take(maxLength).join();
    quoteWithoutLine = quoteWithoutLine + '...';
  }
  quoteWithoutLine =
      "[$quoteWithoutLine]($MAIN_HOST/post?id=$id&is_show_reply=false)";
  return quoteWithoutLine;
}
