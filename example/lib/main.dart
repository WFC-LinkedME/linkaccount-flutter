import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:account/account.dart';
import 'package:account/TokenResult.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Account account = Account();
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

  // 设置监听
  Future<void> setTokenResultListener() async {
    account.setTokenResultListener((TokenResult callback) {
      print("callback===" + callback.toString());
      setState(() {
        result = callback.toString();
      });
    });
    setState(() {
      result = "设置监听成功";
    });
  }

  // 预取号
  Future<void> preLogin() async {
    account.preLogin(timeout: 5000);
    setState(() {
      result = "正在预取号";
    });
  }

  // 一键登录
  Future<void> getLoginToken() async {
    account.getLoginToken(timeout: 5000);
    setState(() {
      result = "正在获取token";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          color: Colors.amber[600],
          // width: 48.0,
          // height: 48.0,
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
            margin: EdgeInsets.all(20),
            color: Colors.greenAccent,
            child: Text(result),
            width: 300,
            height: 180,
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
                      new Text("   "),
                      new ElevatedButton(
                        onPressed: () {
                          setTokenResultListener();
                        },
                        child: const Text('设置监听'),
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
