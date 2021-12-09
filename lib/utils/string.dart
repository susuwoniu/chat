bool isUrl(String str) {
  if (str.startsWith('http://') || str.startsWith('https://')) {
    return true;
  } else {
    return false;
  }
}
