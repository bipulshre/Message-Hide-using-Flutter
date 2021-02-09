import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collageproject/app/app.dart';
import 'services/context/app_context.dart';
import 'package:collageproject/services/states/app_running_states.dart';

void main() {
  AppContext appContext =
      AppContext(appRunningStateOverride: AppRunningState.PRODUCTION);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => appContext),
      ],
      child: CollageProject(),
    ),
  );
}
