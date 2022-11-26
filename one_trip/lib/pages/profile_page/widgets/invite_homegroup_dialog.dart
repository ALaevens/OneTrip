import 'package:flutter/material.dart';
import 'package:one_trip/api/models/simpleuser.dart';
import 'package:one_trip/pages/profile_page/widgets/user_chip.dart';
import 'package:one_trip/theme.dart';
import 'package:one_trip/widgets/pagination_listview.dart';

class InviteHomegroupDialog extends StatefulWidget {
  const InviteHomegroupDialog({super.key});

  @override
  State<InviteHomegroupDialog> createState() => _InviteHomegroupDialogState();
}

class _InviteHomegroupDialogState extends State<InviteHomegroupDialog> {
  final TextEditingController _searchController = TextEditingController();
  ListViewState _listState = ListViewState.inactive;
  List<int> selectedIDs = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invite to Homegroup",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            TextFormField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                setState(() {
                  _listState = ListViewState.changed;
                });
              },
              onChanged: (value) {
                setState(() {
                  _listState = ListViewState.inactive;
                });
              },
              decoration: InputDecoration(
                label: const Text("Search"),
                isDense: true,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _listState = ListViewState.changed;
                    });

                    // https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (builder, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints.expand(
                    width: constraints.maxWidth - 8,
                    height: 160,
                  ),
                  child: PaginationListView(
                    state: _listState,
                    shrinkWrap: true,
                    itemBuilder: (context, data) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            // _ready = false;
                            _listState = ListViewState.inUse;
                            if (selectedIDs.contains(data.id)) {
                              selectedIDs.remove(data.id);
                            } else {
                              selectedIDs.add(data.id);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: selectedIDs.contains(data.id)
                              ? Theme.of(context).colorScheme.secondary
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SmallUserChip(
                                user: data,
                                radius: 20,
                                textColor: selectedIDs.contains(data.id)
                                    ? Theme.of(context).colorScheme.onSecondary
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    seperatorBuilder: (context, data) {
                      return const Divider();
                    },
                    dataProvider: (int page) async {
                      SearchResult result =
                          await SimpleUser.search(_searchController.text, page);
                      List<dynamic> users = List<dynamic>.from(result.users);

                      if (result.next == null) {
                        users.add(null);
                      }

                      return users;
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, selectedIDs),
                      child: const Text("Done")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<List<int>?> inviteHomegroupDialog(BuildContext context) async {
  List<int>? selectedIDs = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: ScrollConfiguration(
            behavior: MyBehavior(), child: const InviteHomegroupDialog()),
      );
    },
  );

  return selectedIDs;
}
