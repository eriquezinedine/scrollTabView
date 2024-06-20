import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

ItemPosition _findMinIndex(List<ItemPosition> positions) {
  return positions.reduce((a, b) => a.index < b.index ? a : b);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 50, vsync: this);

  late final _itemScrollController = ItemScrollController();
  late final _itemPositionsListener = ItemPositionsListener.create();

  int indexP = 0;
  int indexC = 0;

  @override
  void initState() {
    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value.toList();

      final position = _findMinIndex(positions);

      tabController.animateTo(position.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 80,
              child: TabBar(
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                isScrollable: true,
                controller: tabController,
                onTap: (value) {
                  _itemScrollController.scrollTo(
                    duration: Duration(milliseconds: 300),
                    index: value,
                    curve: Easing.standard,
                  );
                },
                tabs: List.generate(
                  50,
                  (index) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('$index'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                itemCount: 50,
                itemBuilder: (context, index) {
                  return Container(
                    height: 250,
                    color: Colors.red,
                    margin: const EdgeInsets.all(5),
                    child: Center(child: Text('$index')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
