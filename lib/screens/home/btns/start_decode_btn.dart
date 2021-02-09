import 'package:flutter/material.dart';

class HomeScreenStartDecodeBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/receive');
      },
      child: Container(
        height: 50.0,
        width: 150.0,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(0.0, 20.0),
              blurRadius: 30.0,
              color: Colors.black12)
        ], color: Colors.white, borderRadius: BorderRadius.circular(22.0)),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 110.0,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Text(
                'Decode',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .apply(color: Colors.black),
              ),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(95.0),
                      topLeft: Radius.circular(95.0),
                      bottomRight: Radius.circular(200.0))),
            ),
            Icon(
              Icons.lock_open,
              size: 30.0,
            )
          ],
        ),
      ),
    );
  }
}
