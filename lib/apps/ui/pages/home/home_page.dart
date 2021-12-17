import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salud_y_mas/apps/ui/pages/home/home_crontroller.dart';
import 'package:salud_y_mas/apps/ui/pages/home/widgets/googleMaps.dart';


class HomePageGoogle extends StatelessWidget {
  const HomePageGoogle ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
        create: (_){
          final controller = HomeController();
          controller.onMarkerTap.listen((String id) {
            print("go to $id");
          });
          return controller;
        },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Builder(builder: (context)=> IconButton(
                onPressed: (){
                final controller = context.read<HomeController>();
                controller.newPolygon();
                },
                icon: Icon(Icons.map)
            ),
            ),
          ],
        ),
        body: Selector<HomeController,bool>(
          selector: (_,controller)=>controller.loading,
          builder: (context, loading, loadingWidget){
            if(loading){
              return loadingWidget!;
            }
            return MapView();
          },
          child: Center(
            child: CircularProgressIndicator(
            ),
          ),
        )
      ),
    );
  }
}
