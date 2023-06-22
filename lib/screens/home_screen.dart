import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lab9_task3_mmaaz_283826_bese10b/screens/todo_list_screen.dart';
import 'package:lab9_task3_mmaaz_283826_bese10b/todo_sevice.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool dataFetched = false;
  String error = '';
  bool _showLoading = false;
  bool _isBtnDisabled = false;
  late var data;

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back from the Future'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: _isBtnDisabled
                  ? null
                  : () async {
                      bool hasInternet = await hasNetwork();

                      if (hasInternet) {
                        setState(() {
                          error = '';
                          _showLoading = true;
                        });

                        data = await TodoService.fetchTodo().whenComplete(() {
                          setState(() {
                            _showLoading = false;
                          });
                        });
                        if (data != null) {
                          setState(() {
                            dataFetched = true;
                            _isBtnDisabled = true;
                          });
                        }
                      } else {
                        setState(() {
                          error = 'Something terrible happened';
                        });
                      }
                    },
              child: Text(error == '' ? 'GO!' : 'Retry'),
            ),
            Text(error),
            Text(dataFetched ? 'Data Fetched Succesfully' : ''),
            Visibility(
              visible: dataFetched,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TodoListScreen(data: data),
                      ),
                    );
                  },
                  child: const Text('Display Data')),
            ),
            Visibility(
              child: const CircularProgressIndicator(),
              visible: _showLoading,
            ),
          ],
        ),
      ),
    );
  }
}
