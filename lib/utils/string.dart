bool isUrl(String str) {
  if (str.startsWith('http://') || str.startsWith('https://')) {
    return true;
  } else {
    return false;
  }
}

bool isValidId(String id) {
  // parse to int
  final idInt = int.tryParse(id);
  if (idInt == null) {
    return false;
  } else {
    return true;
  }
}

String toMarkdownQuote(String str) {
  return str.split("\n").map((line) {
    return "> $line";
  }).join("\n");
}
