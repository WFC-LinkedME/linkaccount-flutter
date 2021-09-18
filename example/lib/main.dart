import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:linkaccount/linkAccount.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LinkAccount account = LinkAccount();
  String result = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      result = "欢迎使用一键登录";
    });
  }

  // 初始化SDK
  Future<void> initAccount() async {
    String appId = "7e289a2484f4368dbafbd1e5c7d06903";
    if (Platform.isIOS) {
      appId = "7e289a2484f4368dbafbd1e5c7d06903";
    } else if (Platform.isAndroid) {
      appId = "7e289a2484f4368dbafbd1e5c7d06903";
    }
    account.init(key: appId);
    account.setDebug(isDebug: true);
    setState(() {
      result = "初始化成功";
    });
  }

  // 预取号
  Future<void> preLogin() async {
    account.preLogin(timeout: 5000).then((tokenResult) => {
      setState(() {
        result = tokenResult.toString();
      }),
    });
    setState(() {
      result = "正在预取号";
    });
  }

  // 一键登录
  Future<void> getLoginToken() async {
    account.getLoginToken(timeout: 5000).then((tokenResult) => {
      setState(() {
        result = tokenResult.toString();
      }),
    });
    setState(() {
      result = "正在获取token";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Account Flutter Demo'),
        ),
        body: Container(
          color: Colors.white,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      widthFactor: 2,
      child: new Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            color: Colors.blueAccent,
            padding: EdgeInsets.all(8),
            child: Text(result),
            width: double.infinity,
            height: 200,
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new ElevatedButton(
                        onPressed: () {
                          initAccount();
                        },
                        child: const Text('SDK初始化'),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(40, 5, 40, 5),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new ElevatedButton(
                          onPressed: () {
                            preLogin();
                          },
                          child: const Text('预取号')),
                      new Text("   "),
                      new ElevatedButton(
                        onPressed: () {
                          getLoginToken();
                        },
                        child: const Text('一键登录'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      ),
    );
  }
}
