import 'dart:math';

T get_random_element<T>(List<T> arr) {
  final random_index = Random().nextInt(arr.length);
  return arr[random_index];
}

int get_random_index(int length) {
  final random_index = Random().nextInt(length);
  return random_index;
}