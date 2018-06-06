import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }

}

class MainState extends State<MainPage> {
  final String mKey = "key";

  TextEditingController titleController = new TextEditingController();
  TextEditingController msgController = new TextEditingController();
  TextEditingController keyController = new TextEditingController();

  MainState();

  @override
  Widget build(BuildContext context) {
    save() async {
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      sharedPreferences.setString(mKey, keyController.text.toString());
    }

    Future<String> get() async {
      var getKey;
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      getKey = sharedPreferences.getString(mKey);
      return getKey;
    }

    final ThemeData themeData = Theme.of(context);
    final TextStyle linkStyle = themeData.textTheme.body2.copyWith(
        color: themeData.accentColor);

    Future<String> key = get();
    key.then((String key) {
      keyController.text = key;
    });


    send(BuildContext context) {
      var url = "https://sc.ftqq.com/" + keyController.text.toString() +
          ".send";
      print("url:"+url+"\ntext:"+titleController.text.toString()+"\ndesp:"+msgController.text.toString());
      http.post(url, body: {
        "text": titleController.text.toString(),
        "desp": msgController.text.toString()
      }).catchError((error) {
        print("请求出错");
      }).whenComplete(() {
        print("请求完成");
      }).then((response) {
        print("返回：" + response.body);
        save();

        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("返回：" + response.body)));
      });
    }


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("使用 Server酱 发送微信推送"),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 24.0),
              new TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "消息标题",
                  hintText: '必填，最长265字节',
                  helperText: "",
                  helperStyle: new TextStyle(
                      fontSize: 14.0
                  ),
                ),
                maxLength: 128,
                maxLines: 2,
              ),

              const SizedBox(height: 24.0),
              new TextField(
                controller: msgController,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "消息内容",
                  helperText: "最长64K，选填，支持MaerkDown",
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24.0),
              new Align(
                child: new Padding(
                  child: new Builder(builder: (BuildContext context) {
                    return new RaisedButton(
                      onPressed: () {
                        if (titleController.text
                            .toString()
                            .isEmpty) {
                          Scaffold.of(context).showSnackBar(
                              new SnackBar(content: new Text("标题不能为空")));
                          return;
                        }
                        if (keyController.text
                            .toString()
                            .isEmpty) {
                          Scaffold.of(context).showSnackBar(
                              new SnackBar(content: new Text("KEY不能为空")));
                          return;
                        }
                        send(context);
                      },
                      color: Colors.blue,
                      highlightColor: Colors.lightBlueAccent,
                      disabledColor: Colors.lightBlueAccent,
                      child: new Text("发送",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                  padding: new EdgeInsets.only(
                      left: 8.0, top: 20.0, right: 8.0, bottom: 8.0),
                ),
                alignment: Alignment.topRight,
              ),

              const SizedBox(height: 24.0),
              new Align(
                child: new PasswordField(
                  controller: keyController,
                  fieldKey: new Key(keyController.text.toString()),
                  helperText: '不可或缺',
                  labelText: 'SCKEY',
                  maxLines: 2,
                ),
                alignment: Alignment.topLeft,
              ),

              new Align(
                child: new Padding(padding: new EdgeInsets.only(
                    left: 10.0, top: 100.0, right: 0.0, bottom: 10.0),
                  child: new RichText(
                      text: new TextSpan(
                          children: <TextSpan>[
                            new TextSpan(
                                text: "更多：",
                                style: new TextStyle(color: Colors.black)
                            ),
                            new LinkTextSpan(
                                style: linkStyle,
                                url: 'http://sc.ftqq.com/?c=code'
                            ),
                          ]
                      )
                  ),
                ),
                alignment: Alignment.topLeft,
              ),
            ],

          ),

        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final int maxLines;
  final TextEditingController controller;

  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.maxLines,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return new _PasswordFieldState();
  }
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      controller: widget.controller,
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLines: widget.maxLines,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: new InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: new Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: new TapGestureRecognizer()
        ..onTap = () {
          launch(url);
        }
  );
}

