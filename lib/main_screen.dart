import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'common/utils/colors.dart';
import 'features/chat/widgets/contacts_list.dart';
import 'features/contacts/screens/contacts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool isSearching = false;

  void _navigateToContacts() async {
    await Navigator.pushNamed(context, ContactsScreen.routeName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: const ContactsList(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 8,
      backgroundColor: appBarColor,
      centerTitle: false,
      title: _titleText(),
    );
  }

  Text _titleText() {
    return const Text(
      'Realtime Messenger',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToContacts,
      backgroundColor: buttonColor,
      child: _fabIcon(),
    );
  }

  Icon _fabIcon() {
    return const Icon(
      Icons.comment,
      color: Colors.white,
    );
  }
}
