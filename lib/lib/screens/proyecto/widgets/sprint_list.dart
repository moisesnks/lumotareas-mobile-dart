import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/sprint/sprint.dart';
import 'package:lumotareas/lib/screens/proyecto/widgets/sprint_tile.dart';
import 'package:lumotareas/lib/utils/constants.dart';

class SprintList extends StatelessWidget {
  final List<Sprint> sprints;
  final void Function(Sprint) onTap;

  const SprintList({
    super.key,
    required this.sprints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: secondaryColor,
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sprints',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: primaryColor,
                thickness: 1,
              ),
            ],
          ),
        ),
        ...sprints.map((sprint) {
          int index = sprints.indexOf(sprint);
          return SprintTile(
            sprint: sprint,
            index: index,
            onTap: () => onTap(sprint),
          );
        }),
      ],
    );
  }
}
