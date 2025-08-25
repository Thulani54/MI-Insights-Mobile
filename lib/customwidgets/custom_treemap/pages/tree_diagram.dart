import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../treemap/treemap.dart';

bool isShowingFirstLevel = true;
Key kghgjhg = UniqueKey();

class CustomTreemap extends StatefulWidget {
  final Map<String, dynamic> treeMapdata;
  const CustomTreemap({Key? key, required this.treeMapdata}) : super(key: key);

  @override
  _CustomTreemapState createState() => _CustomTreemapState();
}

class _CustomTreemapState extends State<CustomTreemap> {
  late List<Map<String, dynamic>> treemapData;
  String?
      currentLevelTitle; // null for the first level, module name for the second level

  @override
  void initState() {
    super.initState();

    setState(() {});

    treemapData = parseModules(widget.treeMapdata);
  }

  List<Map<String, dynamic>> parseModules(Map<String, dynamic> treeMapData) {
    if (kDebugMode) {
      //print("treeMapData $treeMapData");
    }
    return treeMapData.entries.map((entry) {
      double totalWeight = entry.value.values.fold(0.0, (sum, item) {
        return sum + double.parse(item.toString());
      });

      if (kDebugMode) {
        //print("${entry.key} ---- $totalWeight");
      }

      return {
        'title': entry.key,
        'weight': totalWeight,
        'value': totalWeight,
      };
    }).toList();
  }

  List<Map<String, dynamic>> parseEvents(
      String moduleName, Map<String, int> eventData) {
    return eventData.entries.map((entry) {
      if (kDebugMode) {
        // print("ghjhhj0 ${entry.key} ---- ${entry.value}");
      }
      return {
        'title': entry.key,
        'weight': entry.value.toDouble(),
        'value': entry.value.toDouble(),
        'parent': moduleName,
      };
    }).toList();
  }

  List<Map<String, dynamic>> parseEvents2(
      String moduleName, Map<String, dynamic> eventData) {
    List<Map<String, dynamic>> eventsList = [];

    eventData.forEach((eventName, count) {
      if (kDebugMode) {
        // print("ghjhhj1 ${eventName} ---- ${count}");
      }
      eventsList.add({
        'title': eventName,
        'weight': double.parse(count.toString()),
        'value': double.parse(count.toString()),
        'parent': moduleName,
      });
    });

    return eventsList;
  }

  void onTileTap(String title) {
    if (currentLevelTitle == null) {
      if (kDebugMode) {
        print("Tapped on module: $title");
      }
      if (widget.treeMapdata.containsKey(title)) {
        var eventData = parseEvents2(title, widget.treeMapdata[title]);
        // print("Event Data for $title: $eventData"); // Debugging line
        treemapData = eventData;
        currentLevelTitle = title;
      }
    } else {
      // print("Returning to module view from: $currentLevelTitle");
      treemapData = parseModules(widget.treeMapdata);
      currentLevelTitle = null;
    }
    //  print("Updated treemapData: $treemapData"); // Debugging line
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        /*   appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          currentLevelTitle ?? "Modules",
          style: TextStyle(fontSize: 16),
        ),
      ),*/
        body: Center(
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1), // Duration of the transition
            transitionBuilder: (Widget child, Animation<double> animation) {
              // Define the slide transition
              var begin = Offset(1.0, 0.0); // Begin from the right
              var end = Offset.zero; // End at the center
              var curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            child: (treemapData.isEmpty)
                ? Text(
                    "No data for the selected range",
                    style: TextStyle(color: Colors.grey),
                  )
                : Container(
                    child: Treemap(
                      key: ValueKey<String>(currentLevelTitle ?? 'modules'),
                      data: treemapData,
                      customSize: const Size(750, 700),
                      textColor: Colors.white,
                      borderColor: Colors.white,
                      onTileTap: onTileTap,
                    ),
                  ),
          ),
        ));
  }
}

List<Map<String, dynamic>> parseTreeMapData(Map<String, dynamic> treeMapData) {
  List<Map<String, dynamic>> parsedData = [];

  treeMapData.forEach((moduleName, events) {
    double moduleWeight = 0;
    events.forEach((eventName, count) {
      moduleWeight += count;
      parsedData.add({
        'title': eventName,
        'weight': count.toDouble(),
        'value': count.toDouble(),
        'parent': moduleName,
      });
    });
    parsedData.add({
      'title': moduleName,
      'weight': moduleWeight,
      'value': moduleWeight,
      'parent': null,
    });
  });

  return parsedData;
}
