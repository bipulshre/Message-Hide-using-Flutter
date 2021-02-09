import 'package:flutter/material.dart';

class TokenInputField extends StatefulWidget {
  final TextEditingController ctrl;
  final bool enable;
  final String keyVal;
  const TokenInputField(this.enable, this.ctrl, {this.keyVal});
  @override
  State<StatefulWidget> createState() {
    return _TokenInputField();
  }
}

class _TokenInputField extends State<TokenInputField> {
  bool visible;
  @override
  void initState() {
    super.initState();
    this.visible = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enable) {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                key: Key(widget.keyVal),
                controller: widget.ctrl,
                obscureText: !this.visible,
                decoration: InputDecoration(
                    labelText: 'Enter the secret key',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: this.visible ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => this.visible = !this.visible);
                        FocusManager.instance.primaryFocus.unfocus();
                        FocusNode().canRequestFocus = false;
                      },
                    )),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
