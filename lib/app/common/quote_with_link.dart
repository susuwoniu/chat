import 'package:chat/common.dart';
import 'package:characters/characters.dart';

quoteWithLink(String quote, String id) {
  final maxLength = 100;
  if (quote.length > maxLength) {
    quote = quote.characters.take(maxLength).join();
    quote = quote + '...';
  }
  quote = "[$quote]($MAIN_HOST/post?id=$id)";
  return quote;
}
