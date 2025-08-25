import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mi_insights/customwidgets/custom_treemap/treemap/tile_details.dart';
import 'package:mi_insights/customwidgets/custom_treemap/treemap/tile_widget.dart';
import 'package:mi_insights/customwidgets/custom_treemap/treemap/utils.dart';

const defaultTextColor = Colors.white;
const defaultBorderColor = Colors.black;

class Treemap extends StatefulWidget {
  const Treemap(
      {Key? key,
      required this.data,
      this.customSize,
      this.textColor = defaultTextColor,
      this.borderColor = defaultBorderColor,
      required this.onTileTap})
      : super(key: key);

  final List data;

  final Color textColor;
  final Color borderColor;
  final void Function(String) onTileTap;

  final Size? customSize;

  @override
  State<Treemap> createState() => TreemapState();
}

class TreemapState extends State<Treemap> {
  late Size calculatedSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      calculatedSize = widget.customSize ??
          Size(constraints.maxWidth, constraints.maxHeight);

      if (calculatedSize.width > constraints.maxWidth) {
        calculatedSize = Size(constraints.maxWidth, calculatedSize.height);
      }

      if (calculatedSize.height > constraints.maxHeight) {
        calculatedSize = Size(calculatedSize.width, constraints.maxHeight);
      }

      return SizedBox(
          width: calculatedSize.width,
          height: calculatedSize.height,
          child: Stack(children: getTiles()));
    });
  }

  List thresholdsColors = [
    {'threshold': 100000.00, 'color': const Color(0xFF1A5276)}, // New
    {'threshold': 4000.00, 'color': const Color(0xFF27AE60)},
    {'threshold': 85000.00, 'color': const Color(0xFF5499C7)}, // New
    {'threshold': 80000.00, 'color': const Color(0xFF5DADE2)}, // New
    {'threshold': 75000.00, 'color': const Color(0xFF1E9642)},
    {'threshold': 95000.00, 'color': const Color(0xFF2471A3)},
    {'threshold': 70000.00, 'color': const Color(0xFF27AE60)}, // New
    {'threshold': 65000.00, 'color': const Color(0xFF30CC5A)}, // New
    {'threshold': 60000.00, 'color': const Color(0xFF52BE80)}, // New
    {'threshold': 55000.00, 'color': const Color(0xFF76D7C4)}, // New
    {'threshold': 50000.00, 'color': const Color(0xFF1A5276)}, // New
    {'threshold': 45000.00, 'color': const Color(0xFF2471A3)}, // New
    {'threshold': 40000.00, 'color': const Color(0xFF2980B9)}, // New
    {'threshold': 35000.00, 'color': const Color(0xFF5499C7)}, // New
    {'threshold': 30000.00, 'color': const Color(0xFF5DADE2)}, // New
    {'threshold': 25000.00, 'color': const Color(0xFF1E9642)}, // New
    {'threshold': 23000.00, 'color': const Color(0xFF27AE60)},
    {'threshold': 22000.00, 'color': const Color(0xFF2980B9)},
    {'threshold': 21000.00, 'color': const Color(0xFF30CC5A)}, // New
    {'threshold': 19000.00, 'color': const Color(0xFF52BE80)},
    {'threshold': 17000.00, 'color': const Color(0xFF76D7C4)}, // New
    {'threshold': 15000.00, 'color': const Color(0xFF2F9E4F)},
    {'threshold': 14000.00, 'color': const Color(0xFF5DADE2)},
    {'threshold': 13000.00, 'color': const Color(0xFF414554)},
    {'threshold': 12000.00, 'color': const Color(0xFF5499C7)},
    {'threshold': 11000.00, 'color': const Color(0xFF8B444E)},
    {'threshold': 10000.00, 'color': const Color(0xFFA569BD)},
    {'threshold': 9000.00, 'color': const Color(0xFFBF4045)},
    {'threshold': 8000.00, 'color': const Color(0xFFF1948A)},
    {'threshold': 7000.00, 'color': const Color(0xFFF5B041)},
    {'threshold': 6000.00, 'color': const Color(0xFFD35400)},
    {'threshold': 5000.00, 'color': const Color(0xFFCB4335)},
    {'threshold': 4000.00, 'color': const Color(0xFF27AE60)},
    {'threshold': 3000.00, 'color': const Color(0xFF943126)},
    {'threshold': 2500.00, 'color': const Color(0xFFF1948A)},
    {'threshold': 2000.00, 'color': const Color(0xFF2471A3)},
    {'threshold': 1800.00, 'color': const Color(0xFF30CC5A)},
    {'threshold': 1500.00, 'color': const Color(0xFFF5B041)},
    {'threshold': 1200.00, 'color': const Color(0xFF30CC5A)},
    {'threshold': 1000.00, 'color': const Color(0xFFF63538)},
    {'threshold': 700.00, 'color': const Color(0xFF2980B9)},
    {'threshold': 600.00, 'color': const Color(0xFF30CC5A)},
    {'threshold': 500.00, 'color': const Color(0xFFCD6155)},
    {'threshold': 400.00, 'color': const Color(0xFF30CC5A)},
    {'threshold': 350.00, 'color': const Color(0xFFBF4045)},
    {'threshold': 250.00, 'color': const Color(0xFF1A5276)},
    {'threshold': 200.00, 'color': const Color(0xFFCB4335)},
    {'threshold': 150.00, 'color': const Color(0xFFF63538)},

    {'threshold': 100.00, 'color': const Color(0xFF27AE60)},
    {'threshold': 70.00, 'color': const Color(0xFFF1948A)},
    {'threshold': 50.00, 'color': const Color(0xFF5499C7)},
    {'threshold': 40.00, 'color': const Color(0xFF2471A3)},
    {'threshold': 35.00, 'color': const Color(0xFF30CC5A)},
    {'threshold': 30.00, 'color': const Color(0xFFA569BD)},
    {'threshold': 25.00, 'color': const Color(0xFF943126)},
    {'threshold': 20.00, 'color': const Color(0xFFD35400)},
    {'threshold': 15.00, 'color': const Color(0xFF52BE80)},
    {'threshold': 10.00, 'color': const Color(0xFFCB4335)},
    {'threshold': 5.00, 'color': const Color(0xFF414554)},
    {'threshold': 3.00, 'color': const Color(0xFFD35400)},
    {'threshold': 2.00, 'color': const Color(0xFF1A5276)}, //
    {'threshold': 0.00, 'color': const Color(0xFF30CC5A)}
  ];

  List<Widget> getTiles() {
    List<TileDetails> tiles = <TileDetails>[];
    var aggregatedWeight = 0.0;

    for (int i = 0; i < widget.data.length; i++) {
      TileDetails tile = TileDetails(
        weight: double.parse((widget.data[i]['weight']).toString()),
        value: double.parse((widget.data[i]['value']).toString()),
        title: widget.data[i]['title'],
        textColor: widget.textColor,
        borderColor: widget.borderColor,
        onTap: (title) => widget.onTileTap(title),
      );

      tiles.add(tile);

      aggregatedWeight += widget.data[i]['weight'];
    }

    return buildTiles(
        tiles, aggregatedWeight, calculatedSize, thresholdsColors);
  }
}

List<Widget> buildTiles(List<TileDetails> source, double aggregatedWeight,
    Size size, List thresholdsColors,
    {Offset offset = Offset.zero, int start = 0, int? end}) {
  final Size widgetSize = size;
  double groupArea = 0;
  double referenceArea;
  double? prevAspectRatio;
  double? groupInitialTileArea;
  final List<TileDetails> tiles = source;

  // Sorting the tiles in descending order.
  tiles.sort((src, target) => target.weight.compareTo(src.weight));

  end ??= tiles.length;

  final List<Widget> children = <Widget>[];
  for (int i = start; i < end; i++) {
    final TileDetails tile = tiles[i];
    // Area of rectangle = length * width.
    // Divide the tile weight with aggregatedWeight to get the area factor.
    // Multiply it with rectangular area to get the actual area of a tile.
    tile.area =
        widgetSize.height * widgetSize.width * (tile.weight / aggregatedWeight);

    groupInitialTileArea ??= tile.area;
    // Group start tile height or width based on the shortest side.
    //height or width of group
    final double area = (groupArea + tile.area!) / size.shortestSide;

    // width or height of group
    referenceArea = groupInitialTileArea! / area;

    final double currentAspectRatio = getAspectRatio(referenceArea, area);

    if (prevAspectRatio == null || currentAspectRatio < prevAspectRatio) {
      prevAspectRatio = currentAspectRatio;
      groupArea += tile.area!;
    } else {
      // Aligning the tiles vertically.
      if (size.width > size.height) {
        children.addAll(
          getTileWidgets(tiles, Size(groupArea / size.height, size.height),
              offset, start, i, thresholdsColors,
              axis: Axis.vertical),
        );

        offset += Offset(groupArea / size.height, 0);
        size = Size(max(0, size.width) - groupArea / size.height, size.height);
      }
      // Aligning the tiles horizontally.
      else {
        children.addAll(getTileWidgets(
            tiles,
            Size(size.width, groupArea / size.width),
            offset,
            start,
            i,
            thresholdsColors,
            axis: Axis.horizontal));
        offset += Offset(0, groupArea / size.width);
        size = Size(size.width, max(0, size.height) - groupArea / size.width);
      }

      start = i;

      groupInitialTileArea = groupArea = tile.area!;
      referenceArea = tile.area! / (groupInitialTileArea / size.shortestSide);
      prevAspectRatio =
          getAspectRatio(referenceArea, tile.area! / size.shortestSide);
    }
  }

  // Calculating the size and offset of the last tile or last group area in
  // the given source.
  if (size.width > size.height) {
    children.addAll(
      getTileWidgets(tiles, Size(groupArea / size.height, size.height), offset,
          start, end, thresholdsColors,
          axis: Axis.vertical),
    );
  } else {
    children.addAll(
      getTileWidgets(tiles, Size(groupArea / size.height, size.height), offset,
          start, end, thresholdsColors,
          axis: Axis.horizontal),
    );
  }

  return children;
}

List<Widget> getTileWidgets(List<TileDetails> source, Size size, Offset offset,
    int start, int end, List thresholdsColors,
    {Axis? axis}) {
  final List<TileWidget> tiles = <TileWidget>[];

  for (int i = start; i < end; i++) {
    final TileDetails tileDetails = source[i];

    if (axis == Axis.vertical) {
      tileDetails
        ..size = Size(size.width, tileDetails.area! / size.width)
        ..offset = offset;
      offset += Offset(0, tileDetails.size!.height);
    } else {
      tileDetails
        ..size = Size(tileDetails.area! / size.height, size.height)
        ..offset = offset;
      offset += Offset(tileDetails.size!.width, 0);
    }

    for (int j = 0; j <= thresholdsColors.length; j++) {
      double min = j == thresholdsColors.length
          ? double.negativeInfinity
          : thresholdsColors[j]['threshold'];
      double max =
          j == 0 ? double.infinity : thresholdsColors[j - 1]['threshold'];

      if (between(tileDetails.value, min, max)) {
        tileDetails.color = j == thresholdsColors.length
            ? thresholdsColors[j - 1]['color']
            : thresholdsColors[j]['color'];
      }
    }

    tiles.add(TileWidget(details: tileDetails));
  }

  return tiles;
}
