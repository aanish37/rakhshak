import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as per;

Future<void> requestSmsPermission(String number) async {
  final status = await per.Permission.sms.request();

  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  // Check if location services are enabled
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  // Check and request location permission
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  // Get the device's location
  _locationData = await location.getLocation();
  print(_locationData);

  if (status.isGranted) {
    final uri =
        'sms:$number?body=Hey,I am here   https://maps.google.com/?q=${_locationData.latitude},${_locationData.longitude}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print('permission denied');
    }
  }
}
