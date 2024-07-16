import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/lib/models/sprint/sprint.dart';
import 'package:lumotareas/lib/screens/proyecto/widgets/sprint_tile.dart';
import 'package:lumotareas/lib/utils/constants.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class SprintList extends StatefulWidget {
  final List<Sprint> sprints;
  final void Function(Sprint) onTap;

  const SprintList({
    super.key,
    required this.sprints,
    required this.onTap,
  });

  @override
  SprintListState createState() => SprintListState();
}

class SprintListState extends State<SprintList> {
  bool _isListVisible = false;

  Widget _buildButton(Icon icon, Function() onTap, Color? backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        shape: BoxShape.rectangle,
      ),
      child: IconButton(
        icon: icon,
        onPressed: onTap,
      ),
    );
  }

  void _toggleListVisibility() {
    setState(() {
      _isListVisible = !_isListVisible;
      Logger().i(_isListVisible
          ? 'Mostrar lista de sprints'
          : 'Ocultar lista de sprints');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledListTile(
          index: 0,
          leading: const Icon(Icons.folder),
          title: const Text('Sprints'),
          trailing: _buildButton(
            Icon(
              _isListVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.white,
            ),
            _toggleListVisibility,
            primaryColor,
          ),
          subtitle: Text(
            '${widget.sprints.length} sprint${widget.sprints.length == 1 ? '' : 's'}',
          ),
          onTap: _toggleListVisibility,
        ),
        if (_isListVisible)
          ...widget.sprints.map((sprint) {
            int index = widget.sprints.indexOf(sprint) + 1;
            return SprintTile(
              sprint: sprint,
              index: index,
              onTap: () => widget.onTap(sprint),
            );
          }),
      ],
    );
  }
}
