import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './contact_item.dart';
import '../model/emergency_contacts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SafeHome extends StatefulWidget {
  const SafeHome({
    super.key,
  });

  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  bool getHomeSafeActivated = false;

  checkGetHomeActivated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      getHomeSafeActivated = prefs.getBool("getHomeSafe") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();

    checkGetHomeActivated();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) =>
              SafeHomeWidget(getHomeActivated: getHomeSafeActivated),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Get Home Safe',
                      style: Theme.of(context)
                          .copyWith()
                          .primaryTextTheme
                          .bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Share Location\n Periodically',
                      style: Theme.of(context)
                          .copyWith()
                          .primaryTextTheme
                          .bodySmall,
                      softWrap: true,
                    ),
                  ],
                ),
                Image.asset(
                  'assets/girl.png',
                  height: 120,
                ),
              ],
            ),
          ),
          Visibility(
            visible: getHomeSafeActivated,
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    SpinKitDoubleBounce(
                      color: Colors.red,
                      size: 15,
                    ),
                    SizedBox(width: 15),
                    Text("Currently Running...",
                        style: TextStyle(color: Colors.red, fontSize: 10)),
                  ],
                )),
          ),
        ]),
      ),
    );
  }
}

class SafeHomeWidget extends StatefulWidget {
  SafeHomeWidget({super.key, required this.getHomeActivated});
  bool getHomeActivated;
  @override
  State<SafeHomeWidget> createState() => _SafeHomeWidgetState();
}

class _SafeHomeWidgetState extends State<SafeHomeWidget> {
  bool _sharing = false;

  changeStateOfHomeSafe(value) async {
    if (value) {
      Fluttertoast.showToast(msg: "Service Activated in Background!");
    } else {
      Fluttertoast.showToast(msg: "Service Disabled!");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      widget.getHomeActivated = value;
      prefs.setBool("getHomeSafe", value);
    });
  }

  @override
  Widget build(BuildContext context) {
    String? sharingNumber =
        Provider.of<EmergencyContacts>(context, listen: true)
            .fetchSharingContacts();
    return Container(
      padding: const EdgeInsets.all(12),
      height: 800,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Divider(
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              Text(
                'Get Home Safe',
                style:
                    Theme.of(context).copyWith().primaryTextTheme.headlineLarge,
              ),
              const Expanded(
                child: Divider(
                  indent: 20,
                  endIndent: 20,
                ),
              ),
            ],
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                    title: sharingNumber == null
                        ? Text(
                            'Select One Contact First',
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(
                            'Share Location',
                            style: TextStyle(fontSize: 20),
                          ),
                    value: _sharing,
                    onChanged: (value) {
                      changeStateOfHomeSafe(true);

                      sharingNumber != null
                          ? setState(() {
                              _sharing = value;
                            })
                          : null;
                    }),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Location'),
                  subtitle: Text('Kathmandu, Nepal'),
                ),
                ListTile(
                  leading: Icon(Icons.timer),
                  title: Text('Repeat'),
                  subtitle: Text('10 Minutes'),
                ),
              ],
            ),
          ),
          ContactItem(),
        ],
      ),
    );
  }
}
