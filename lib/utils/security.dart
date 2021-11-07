import 'dart:convert';
import 'package:crypto/crypto.dart';

/// SHA256
String hmacSha256(String input, String secret) {
  var key = utf8.encode(secret);
  var bytes = utf8.encode(input);
  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);
  return digest.toString();
}

String getSignature({
  required String method,
  required String path,
  required String query,
  required String clientId,
  required String clientSecret,
  required String now,
}) {
  var plainText =
      "$method\n$path\n$query\nx-client-id=$clientId&x-client-date=$now";
  var signhmacDigest = hmacSha256(plainText, clientSecret);
  var signature = "v1.signature." + signhmacDigest;
  return signature;
}
