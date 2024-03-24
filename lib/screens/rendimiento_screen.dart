import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: RendimientoScreen(),
  ));
}

class RendimientoScreen extends StatefulWidget {
  @override
  _RendimientoScreenState createState() => _RendimientoScreenState();
}

class _RendimientoScreenState extends State<RendimientoScreen> {
  double _manualFeedCount = 0;
  double _automaticFeedCount = 0;

  final DatabaseReference _database = FirebaseDatabase.instance.reference().child(
      'contador'); // Referencia al nodo contador en la base de datos Firebase

  @override
  void initState() {
    super.initState();
    _loadData();
    _database.onValue.listen((event) {
      // Escuchar cambios en el nodo contador
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          _automaticFeedCount = double.parse(snapshot.value.toString());
        });
      }
    });
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _manualFeedCount = (prefs.getInt('manualFeedCount') ?? 0).toDouble();
    });
  }

  void _resetCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('manualFeedCount', 0);

    // Restablecer los contadores a cero y actualizar la interfaz de usuario
    setState(() {
      _manualFeedCount = 0;
      _automaticFeedCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Activaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (_manualFeedCount > _automaticFeedCount
                          ? _manualFeedCount
                          : _automaticFeedCount) +
                      2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String title;
                        switch (group.x.toInt()) {
                          case 0:
                            title = 'Manual';
                            break;
                          case 1:
                            title = 'Automático';
                            break;
                          default:
                            title = '';
                            break;
                        }
                        return BarTooltipItem(
                          '$title\n${rod.y}',
                          TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) {
                        switch (value.toInt()) {
                          case 0:
                            return TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                          case 1:
                            return TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                          default:
                            return TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );
                        }
                      },
                      margin: 20,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Manual';
                          case 1:
                            return 'Automático';
                          default:
                            return '';
                        }
                      },
                    ),
                    topTitles: SideTitles(
                      // Agregado para eliminar los números del eje X de arriba
                      showTitles: false,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      margin: 20,
                      interval: 1,
                    ),
                    rightTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          y: _manualFeedCount,
                          width: 20, // Grosor de la barra
                          colors: [Colors.purple],
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          y: _automaticFeedCount,
                          width: 20, // Grosor de la barra
                          colors: [Colors.blue],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _resetCounters,
              child: Text('Limpiar'),
            ),
          ],
        ),
      ),
    );
  }
}
