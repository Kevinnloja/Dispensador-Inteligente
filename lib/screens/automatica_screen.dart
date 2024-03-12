import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AutomaticaScreen extends StatefulWidget {
  @override
  _AutomaticaScreenState createState() => _AutomaticaScreenState();
}

class _AutomaticaScreenState extends State<AutomaticaScreen> {
  late DatabaseReference _alarmRef;
  List<AlarmModel> alarms = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _alarmRef =
        FirebaseDatabase.instance.reference().child('users/$uid/alarms');
    _loadAlarmsFromDatabase();

    // Iniciar el temporizador para verificar las alarmas cada minuto
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkAlarms();
    });
  }

  @override
  void dispose() {
    // Detener el temporizador cuando se elimine el estado
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadAlarmsFromDatabase() async {
    try {
      _alarmRef.onValue.listen((event) {
        setState(() {
          alarms.clear();
        });

        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> map =
              event.snapshot.value as Map<dynamic, dynamic>;

          map.forEach((key, value) {
            AlarmModel alarm = AlarmModel.fromMap(value, key);
            setState(() {
              alarms.add(alarm);
            });
          });
        }
      });
    } catch (e) {
      print("Error al cargar las alarmas: $e");
    }
  }

  void _checkAlarms() {
    // Obtener la hora actual del dispositivo
    DateTime now = DateTime.now()
        .toUtc()
        .add(Duration(hours: -5)); // Hora de Ecuador (GMT-5)

    // Verificar si alguna alarma coincide con la hora actual
    alarms.forEach((alarm) {
      if (alarm.dateTime.hour == now.hour &&
          alarm.dateTime.minute == now.minute) {
        // Si coincide, enviar un dato a Firebase
        _sendDataToFirebase(alarm);
        // Una vez pasado el tiempo de activación, se elimina la alarma de la lista y de la base de datos
        _deleteAlarmFromDatabase(alarm);
        setState(() {
          alarms.remove(alarm);
        });
      }
    });
  }

  void _sendDataToFirebase(AlarmModel alarm) {
    // Enviar un dato a Firebase indicando que la alarma se activó
    FirebaseDatabase.instance
        .reference()
        .update({'automatica_activo': true}).then((_) {
      print('Alarma activada: ${alarm.dateTime}');
    }).catchError((error) {
      print('Error al activar la alarma: $error');
    });
  }

  void _deleteAlarmFromDatabase(AlarmModel alarm) {
    // Obtener la referencia específica de la alarma en la base de datos
    DatabaseReference alarmRef = _alarmRef.child(alarm.key);
    // Eliminar la alarma de la base de datos
    alarmRef.remove().then((_) {
      // Imprimir un mensaje cuando se elimina con éxito de la base de datos
      print('Alarma eliminada de la base de datos');
    }).catchError((error) {
      // Manejar errores si ocurren al intentar eliminar de la base de datos
      print('Error al eliminar alarma de la base de datos: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alimentación Automática',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3F3F9C), Color(0xFF5A46B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              alarms.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Icon(
                                  Icons.alarm_off,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 64.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'No hay alarmas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey),
                        itemBuilder: (context, index) => buildAlarmItem(index),
                        itemCount: alarms.length,
                      ),
                    ),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  _addAlarm();
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAlarmItem(int index) {
    DateTime alarmDateTime = alarms[index].dateTime;
    String dayOfWeek = _getDayOfWeek(alarmDateTime);
    String formattedDate = _getFormattedDate(alarmDateTime);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          _editAlarmDateTime(index);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: alarms[index].isEnabled
                ? Colors.white
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatTimeWithAMPM(alarmDateTime),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color:
                          alarms[index].isEnabled ? Colors.black : Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        dayOfWeek,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Switch(
                    value: alarms[index].isEnabled,
                    onChanged: (value) {
                      setState(() {
                        alarms[index].isEnabled = value;
                      });
                      _updateAlarmInDatabase(alarms[index]);
                    },
                    activeColor: Colors.deepPurple,
                  ),
                  GestureDetector(
                    onTap: () {
                      _deleteAlarm(index);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTimeWithAMPM(DateTime dateTime) {
    String period = dateTime.hour < 12 ? 'a.m' : 'p.m';
    int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  String _getDayOfWeek(DateTime dateTime) {
    List<String> daysOfWeek = [
      'Lun',
      'Mar',
      'Mié',
      'Jue',
      'Vie',
      'Sáb',
      'Dom',
    ];
    return daysOfWeek[dateTime.weekday - 1];
  }

  String _getFormattedDate(DateTime dateTime) {
    String day = dateTime.day.toString();
    String month;

    switch (dateTime.month) {
      case 1:
        month = 'enero';
        break;
      case 2:
        month = 'febrero';
        break;
      case 3:
        month = 'marzo';
        break;
      case 4:
        month = 'abril';
        break;
      case 5:
        month = 'mayo';
        break;
      case 6:
        month = 'junio';
        break;
      case 7:
        month = 'julio';
        break;
      case 8:
        month = 'agosto';
        break;
      case 9:
        month = 'septiembre';
        break;
      case 10:
        month = 'octubre';
        break;
      case 11:
        month = 'noviembre';
        break;
      case 12:
        month = 'diciembre';
        break;
      default:
        month = '';
        break;
    }

    return '$day  de $month';
  }

  void _editAlarmDateTime(int index) async {
    DateTime? dateResult = await showDatePicker(
      context: context,
      initialDate: alarms[index].dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (dateResult != null) {
      TimeOfDay? timeResult = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(alarms[index].dateTime),
      );

      if (timeResult != null) {
        DateTime selectedDateTime = DateTime(
          dateResult.year,
          dateResult.month,
          dateResult.day,
          timeResult.hour,
          timeResult.minute,
        );

        setState(() {
          alarms[index].dateTime = selectedDateTime;
        });

        _updateAlarmInDatabase(alarms[index]);
      }
    }
  }

  void _deleteAlarm(int index) {
    String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (index < alarms.length && alarms[index].userUID == currentUid) {
      AlarmModel deletedAlarm = alarms[index];

      setState(() {
        alarms.removeAt(index);
      });

      // Obtener la referencia específica de la alarma en la base de datos
      DatabaseReference alarmRef = _alarmRef.child(deletedAlarm.key);

      // Eliminar la alarma de la base de datos
      alarmRef.remove().then((_) {
        // Imprimir un mensaje cuando se elimina con éxito de la base de datos
        print('Alarma eliminada de la base de datos');
      }).catchError((error) {
        // Manejar errores si ocurren al intentar eliminar de la base de datos
        print('Error al eliminar alarma de la base de datos: $error');
        // Volver a agregar la alarma en caso de error para mantener la consistencia
        setState(() {
          alarms.insert(index, deletedAlarm);
        });
      });
    } else {
      print('Índice fuera de rango o permisos insuficientes: $index');
    }
  }

  void _addAlarm() async {
    DateTime? dateResult = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (dateResult != null) {
      TimeOfDay? timeResult = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timeResult != null) {
        DateTime selectedDateTime = DateTime(
          dateResult.year,
          dateResult.month,
          dateResult.day,
          timeResult.hour,
          timeResult.minute,
        );

        setState(() {
          alarms.add(
            AlarmModel(
              name: '',
              dateTime: selectedDateTime,
              isEnabled: true,
              userUID: FirebaseAuth.instance.currentUser?.uid ?? '',
              key: '', // Se asigna una clave única para la nueva alarma
            ),
          );
        });

        _saveAlarmInDatabase(alarms.last);
      }
    }
  }

  void _updateAlarmInDatabase(AlarmModel alarm) {
    _alarmRef.child(alarm.key).set(alarm.toMap());
  }

  void _saveAlarmInDatabase(AlarmModel alarm) {
    DatabaseReference newAlarmRef = _alarmRef.push();
    alarm.key =
        newAlarmRef.key ?? ''; // Asignar la clave única generada por Firebase
    newAlarmRef.set(alarm.toMap());
  }
}

class AlarmModel {
  String name;
  DateTime dateTime;
  bool isEnabled;
  String userUID;
  String key;

  AlarmModel({
    required this.name,
    required this.dateTime,
    required this.isEnabled,
    required this.userUID,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateTime': dateTime.toIso8601String(),
      'isEnabled': isEnabled,
      'userUID': userUID,
    };
  }

  factory AlarmModel.fromMap(Map<dynamic, dynamic> map, String key) {
    return AlarmModel(
      name: map['name'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      isEnabled: map['isEnabled'] ?? false,
      userUID: map['userUID'] ?? '',
      key: key,
    );
  }
}
