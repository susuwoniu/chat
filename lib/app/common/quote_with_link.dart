import 'package:chat/common.dart';

quoteWithLink(String quote, String id) {
  final maxLength = 100;
  if (quote.length > maxLength) {
    quote = quote.substring(0, maxLength);
    quote = quote + '...';
  }
  quote = "[$quote]($MAIN_HOST/post?id=$id)";
  return quote;
}
