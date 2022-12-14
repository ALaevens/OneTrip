import 'package:flutter/material.dart';
import 'package:one_trip/api/models/recipe.dart';
import 'package:one_trip/api/searchresult.dart';
import 'package:one_trip/theme.dart';
import 'package:one_trip/widgets/pagination_listview.dart';

class SearchRecipesDialog extends StatefulWidget {
  const SearchRecipesDialog({super.key});

  @override
  State<SearchRecipesDialog> createState() => _SearchRecipesDialogState();
}

class _SearchRecipesDialogState extends State<SearchRecipesDialog> {
  final TextEditingController _searchController = TextEditingController();
  ListViewState _listState = ListViewState.inactive;
  List<int> selectedIDs = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              "Search your Recipes",
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
                    prefetchOne: true,
                    itemBuilder: (context, data) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
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
                          child: Text(
                            data.name,
                            style: TextStyle(
                                color: selectedIDs.contains(data.id)
                                    ? Theme.of(context).colorScheme.onSecondary
                                    : null),
                          ),
                        ),
                      );
                    },
                    seperatorBuilder: (context, data) {
                      return const Divider();
                    },
                    dataProvider: (int page) async {
                      SearchResult<Recipe> result =
                          await Recipe.search(_searchController.text, page);
                      List<dynamic> recipes =
                          List<dynamic>.from(result.results);

                      if (result.next == null) {
                        recipes.add(null);
                      }

                      return recipes;
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
                    style: negativeButtonStyle(context),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: positiveButtonStyle(context),
                    onPressed: () => Navigator.pop(context, selectedIDs),
                    child: const Text("Done"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<List<int>?> searchRecipesDialog(BuildContext context) async {
  List<int>? selectedIDs = await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: ScrollConfiguration(
            behavior: MyBehavior(), child: const SearchRecipesDialog()),
      );
    },
  );

  return selectedIDs;
}
