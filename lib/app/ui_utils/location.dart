import 'package:location/location.dart';

Future<Location> checkLocationPermission() async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      // 不可用
      throw Exception('定位服务不可用，请在设置中开启');
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      throw Exception('无法获取定位权限，请在设置中手动开启');
    }
  }
  return location;
}

Future<LocationData> getLocation() async {
  final location = await checkLocationPermission();
  final _locationData = await location.getLocation();
  return _locationData;
}
