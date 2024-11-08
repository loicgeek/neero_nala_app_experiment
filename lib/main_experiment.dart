import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag, Resize, and Rotate Layout',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DraggableArea(),
    );
  }
}

class CustomElement {
  final String id;
  final String type; // 'pool', 'tree', 'table', etc.
  double x; // Position as percentage of parent width
  double y; // Position as percentage of parent height
  double width; // Width as percentage of parent width
  double height; // Height as percentage of parent height
  double angle; // Angle in degrees
  Color color;

  CustomElement({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.angle,
    required this.color,
  });

  // Convert the element to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'angle': angle,
      'color': color.value, // Store color as an int
    };
  }

  // Create an element from a map
  factory CustomElement.fromMap(Map<String, dynamic> map) {
    return CustomElement(
      id: map['id'],
      type: map['type'],
      x: map['x'],
      y: map['y'],
      width: map['width'],
      height: map['height'],
      angle: map['angle'],
      color: Color(map['color']),
    );
  }
}

class DraggableArea extends StatefulWidget {
  @override
  _DraggableAreaState createState() => _DraggableAreaState();
}

class _DraggableAreaState extends State<DraggableArea> {
  List<CustomElement> elements = [];
  late CustomElement selectedElement;
  double parentWidth = 0;
  double parentHeight = 0;

  @override
  void initState() {
    super.initState();
    loadSavedLayout();
  }

  void loadSavedLayout() {
    setState(() {
      elements = [
        CustomElement(
          id: '1',
          type: 'pool',
          x: 0.1, // 10% of parent width
          y: 0.2, // 20% of parent height
          width: 0.2, // 20% of parent width
          height: 0.2, // 20% of parent height
          angle: 0,
          color: Colors.blue,
        ),
        CustomElement(
          id: '2',
          type: 'tree',
          x: 0.4, // 40% of parent width
          y: 0.4, // 40% of parent height
          width: 0.1, // 10% of parent width
          height: 0.3, // 30% of parent height
          angle: 45,
          color: Colors.green,
        ),
      ];
    });
  }

  void saveLayout() {
    elements.forEach((element) {
      print('Element: ${element.id}, x: ${element.x}, y: ${element.y}');
    });
  }

  void onDragUpdate(DragUpdateDetails details, CustomElement element) {
    setState(() {
      double dx = details.delta!.dx / parentWidth;
      double dy = details.delta!.dy / parentHeight;
      element.x += dx;
      element.y += dy;

      // Prevent moving out of bounds
      element.x = element.x.clamp(0.0, 1.0 - element.width);
      element.y = element.y.clamp(0.0, 1.0 - element.height);
    });
  }

  void onResizeUpdate(
      DragUpdateDetails details, CustomElement element, String corner) {
    setState(() {
      double dx = details.delta!.dx / parentWidth;
      double dy = details.delta!.dy / parentHeight;

      switch (corner) {
        case 'bottomRight':
          element.width += dx;
          element.height += dy;
          break;
        case 'bottomLeft':
          element.width -= dx;
          element.height += dy;
          element.x += dx;
          break;
        case 'topRight':
          element.width += dx;
          element.height -= dy;
          element.y += dy;
          break;
        case 'topLeft':
          element.width -= dx;
          element.height -= dy;
          element.x += dx;
          element.y += dy;
          break;
      }

      // Prevent shrinking beyond original size and out of bounds
      element.width = element.width.clamp(0.05, 1.0); // Minimum width is 5%
      element.height = element.height.clamp(0.05, 1.0); // Minimum height is 5%

      element.x = element.x.clamp(0.0, 1.0 - element.width);
      element.y = element.y.clamp(0.0, 1.0 - element.height);
    });
  }

  void onRotateUpdate(Offset touchPosition, CustomElement element) {
    final centerX = element.x * parentWidth + element.width * parentWidth / 2;
    final centerY =
        element.y * parentHeight + element.height * parentHeight / 2;

    final deltaX = touchPosition.dx - centerX;
    final deltaY = touchPosition.dy - centerY;

    final angle = atan2(deltaY, deltaX) * 180 / pi;

    setState(() {
      element.angle = angle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag, Resize, and Rotate Layout'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveLayout,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          parentWidth = constraints.maxWidth;
          parentHeight = constraints.maxHeight;

          return Stack(
            children: [
              // Display all elements
              ...elements.map((element) {
                return Positioned(
                  left: element.x * parentWidth,
                  top: element.y * parentHeight,
                  child: GestureDetector(
                    onPanUpdate: (details) => onDragUpdate(details, element),
                    child: Material(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          // Element itself
                          Transform.rotate(
                            angle: element.angle *
                                pi /
                                180, // Convert angle to radians
                            child: Container(
                              width: element.width * parentWidth,
                              height: element.height * parentHeight,
                              color: element.color,
                              child: Center(child: Text(element.type)),
                            ),
                          ),
                          // Resize handle at bottom-right corner
                          Positioned(
                            bottom: element.x * parentWidth,
                            right: element.y * parentHeight,
                            child: GestureDetector(
                              onPanUpdate: (details) => onResizeUpdate(
                                  details, element, 'bottomRight'),
                              child: Container(
                                width: 20,
                                height: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Rotation handle
                          Positioned(
                            top: 10,
                            left: element.width * parentWidth / 2 - 10,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                onRotateUpdate(details.localPosition, element);
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
