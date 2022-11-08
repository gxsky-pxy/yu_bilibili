import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:yu_bilibili/provider/theme_provider.dart';

List<SingleChildWidget> topProviders = [
  ChangeNotifierProvider(create: (_) => ThemeProvider())
];