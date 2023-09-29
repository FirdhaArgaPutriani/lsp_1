import 'package:flutter/material.dart';
import 'package:lsp_1/pages/income/create.dart';
import 'package:lsp_1/pages/income/income.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Money'),
        backgroundColor: Color.fromARGB(255, 232, 144, 248),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              child: InkWell(
                onTap: () {},
                splashColor: Color.fromARGB(255, 232, 144, 248),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateIncome(),
                            ),
                          );
                        },
                        icon: Column(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 70.0,
                            ),
                            Text(
                              'Income',
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {},
                splashColor: Color.fromARGB(255, 232, 144, 248),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateIncome(),
                            ),
                          );
                        },
                        icon: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.money_off,
                                size: 70.0,
                              ),
                              Text(
                                'Outcome',
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {},
                splashColor: Color.fromARGB(255, 232, 144, 248),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Income(),
                            ),
                          );
                        },
                        icon: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.folder_copy_outlined,
                                size: 70.0,
                              ),
                              Text(
                                'Detail',
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {},
                splashColor: Color.fromARGB(255, 232, 144, 248),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateIncome(),
                            ),
                          );
                        },
                        icon: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 70.0,
                              ),
                              Text(
                                'Setting',
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
