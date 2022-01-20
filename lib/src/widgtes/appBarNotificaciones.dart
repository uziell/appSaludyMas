import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salud_y_mas/notification_providers/push_notification_providers.dart';
import 'package:salud_y_mas/src/requests/notificaciones_request.dart';

class AppBarNotificaciones extends StatefulWidget {
  final String titulo;
  const AppBarNotificaciones({Key? key, required this.titulo}) : super(key: key);

  @override
  _AppBarNotificacionesState createState() => _AppBarNotificacionesState();
}

class _AppBarNotificacionesState extends State<AppBarNotificaciones> {
  int numeroNotificaciones = 0;
  @override
  void initState() {
    super.initState();
    PushNotificationProvider.messageStream.listen((message) {
      print("entra listener app bar ");

      obtenerNumeroNotificacionesNoVistas();
    });
    obtenerNumeroNotificacionesNoVistas();
  }

  obtenerNumeroNotificacionesNoVistas() async {
    numeroNotificaciones = 0;
    List<dynamic> notificaciones = await NotificacionesRequest.obtenerNotificaciones();
    if (this.mounted) {
      setState(() {
        for (int i = 0; i < notificaciones.length; i++) {
          if (notificaciones[i]['estadoNot'] == "0") {
            numeroNotificaciones += 1;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.titulo,
        style: GoogleFonts.abrilFatface(),
      ),
      actions: [
        Badge(
          position: BadgePosition.topEnd(top: 5, end: 3),
          badgeColor: Colors.red,
          badgeContent: Text('$numeroNotificaciones', style: TextStyle(color: Colors.white, fontSize: 9)),
          child: IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, 'notificaciones');
            },
          ),
        ),
      ],
    );
  }
}
