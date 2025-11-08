import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rfw/rfw.dart';
import 'package:rfw/formats.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Runtime _runtime = Runtime();
  final DynamicContent _data = DynamicContent();
  bool _loaded = false;

  static const LibraryName remoteLib =
      LibraryName(<String>['remote', 'widgets']);

  @override
  void initState() {
    super.initState();
    _setupRuntime();
    _fetchRemoteWidget();
  }

  void _setupRuntime() {
    // core + material widgets
    _runtime.update(
        const LibraryName(['core', 'widgets']), createCoreWidgets());
    _runtime.update(const LibraryName(['material', 'widgets']),
        createMaterialWidgets());

    // custom FontAwesome widget library
    _runtime.update(
        const LibraryName(['custom', 'widgets']), createCustomWidgets());
  }

  // -----------------------------
  // ✅ Custom widgets (FaIcon, FaButton)
  // -----------------------------

  LocalWidgetLibrary createCustomWidgets() {
    return LocalWidgetLibrary({
      'FaIcon': (BuildContext context, DataSource source) {
        final String iconName =
            source.v<String>(['icon']) ?? 'question';
        final double size = source.v<double>(['size']) ?? 24.0;
        final int colorVal = source.v<int>(['color']) ?? 0xFF000000;

        final IconData icon =
            _faIconMap[iconName] ?? FontAwesomeIcons.circleQuestion;

        return FaIcon(icon, size: size, color: Color(colorVal));
      },

      'FaButton': (BuildContext context, DataSource source) {
        final String iconName =
            source.v<String>(['icon']) ?? 'question';
        final String label =
            source.v<String>(['label']) ?? '';

        final VoidCallback? onPressed =
            source.voidHandler(['onPressed'], null);

        final IconData icon =
            _faIconMap[iconName] ?? FontAwesomeIcons.circleQuestion;

        return ElevatedButton.icon(
          onPressed: onPressed,
          icon: FaIcon(icon),
          label: Text(label),
        );
      },
    });
  }

  // icons supported
  final Map<String, IconData> _faIconMap = {
    'home': FontAwesomeIcons.house,
    'user': FontAwesomeIcons.user,
    'heart': FontAwesomeIcons.heart,
    'github': FontAwesomeIcons.github,
    'question': FontAwesomeIcons.circleQuestion,
  };

  // -----------------------------
  // ✅ Fetching RFW from Flask backend
  // -----------------------------
  Future<void> _fetchRemoteWidget() async {
    try {
      final url = Uri.parse('http://192.168.1.37:8000/remote_widget');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final rfwText = decoded['rfw'] as String;
        final dataMap = decoded['data'] as Map<String, dynamic>;

        final library = parseLibraryFile(rfwText);
        _runtime.update(remoteLib, library);

        _data.updateAll(dataMap);

        setState(() => _loaded = true);
      } else {
        debugPrint('❌ Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching widget: $e');
    }
  }

  // -----------------------------
  // ✅ Send event to Flask backend
  // -----------------------------
  Future<void> _sendEventToFlask(
      String event, Map<String, dynamic> args) async {
    try {
      final url = Uri.parse('http://192.168.1.37:8000/receive_event');
      await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'event': event, 'args': args}));
    } catch (e) {
      debugPrint('⚠️ Error sending event: $e');
    }
  }

  // -----------------------------
  // ✅ UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic Flask + RFW + FA Icons')),
        body: Center(
          child: _loaded
              ? RemoteWidget(
                  runtime: _runtime,
                  data: _data,
                  widget: const FullyQualifiedWidgetName(
                    remoteLib,
                    'MyCard',
                  ),
                  onEvent: (String name, DynamicMap args) {
                    _sendEventToFlask(
                        name, args.cast<String, dynamic>());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Event sent: $name')),
                    );
                  },
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
