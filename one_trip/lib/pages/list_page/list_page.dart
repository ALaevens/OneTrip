import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_trip/api/auth.dart';
import 'package:one_trip/api/consts.dart';
import 'package:one_trip/api/models/list.dart';
import 'package:one_trip/api/models/listingredient.dart';
import 'package:one_trip/api/models/user.dart';
import 'package:one_trip/pages/list_page/widgets/listrow.dart';
import 'package:one_trip/pages/list_page/widgets/search_recipes.dart';
import 'package:one_trip/widgets/text_entry_dialog.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ShoppingList? _list;
  late Future<bool> _isLoaded;
  User? _userInfo;
  WebSocket? _ws;

  Future<bool> _fetchList() async {
    User? userInfo = await User.getMe();
    _userInfo = userInfo;

    if (userInfo == null || userInfo.homegroup == null) {
      return false;
    }

    _list = await ShoppingList.get(userInfo.homegroup!);
    return true;
  }

  void _connectSocket() async {
    String token = TokenSingleton().getToken();
    _ws = await WebSocket.connect("$baseWsURL/ws/",
        headers: {"Authorization": "Token $token"});

    if (_ws == null) {
      return;
    }

    _ws!.listen((event) async {
      Map<String, dynamic> json = jsonDecode(event);

      if (json.keys.contains("type") && json["type"] == "recommend_update") {
        if (json["hash"] != _list.hashCode) {
          ShoppingList? newList = await ShoppingList.get(_list!.homegroup);

          if (newList != null) {
            setState(() {
              _list = newList;
            });
          }
        }
      }
    });
  }

  void _sendUpdate() async {
    if (_ws == null) {
      return;
    }
    _ws!.add(jsonEncode({"type": "broadcast_update", "hash": _list.hashCode}));
  }

  @override
  void dispose() {
    if (_ws != null) {
      _ws!.close();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isLoaded = _fetchList();
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isLoaded,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          if (_userInfo == null) {
            return const Center(
              child: Text("Could not load user, try logging in again..."),
            );
          } else if (_userInfo!.homegroup == null) {
            return const Center(
              child: Text("You must be in a homegroup to use this feature"),
            );
          } else if (_list == null) {
            return const Center(
              child: Text("Issue loading list"),
            );
          } else {
            return ListArea(
              list: _list!,
              onAddOne: () async {
                String? itemName =
                    await textEntryDialog(context, "Item Name", "Item");

                if (itemName == null || itemName == "") {
                  return;
                }

                ListIngredient? newIngredient =
                    await ListIngredient.create(itemName, _list!.homegroup);
                if (newIngredient == null) {
                  return;
                }

                ShoppingList? newList =
                    await ShoppingList.get(_list!.homegroup);

                if (newList != null) {
                  setState(() {
                    _list = newList;
                  });
                }

                _sendUpdate();
              },
              onAddMany: () async {
                List<int>? selectedIDs = await searchRecipesDialog(context);

                if (selectedIDs == null) {
                  return;
                }

                ShoppingList tempList = _list!;
                for (int id in selectedIDs) {
                  ShoppingList? newList = await tempList.addRecipe(id);

                  if (newList != null) {
                    tempList = newList;
                  }
                }

                setState(() {
                  _list = tempList;
                });

                _sendUpdate();
              },
              onDelete: (ingredient) async {
                bool success = await ingredient.delete();
                if (success) {
                  // ShoppingList? newList =
                  //     await _list!.patch(updates: _list!.updates + 1);

                  ShoppingList? newList =
                      await ShoppingList.get(_list!.homegroup);

                  setState(() {
                    _list = newList;
                  });

                  _sendUpdate();
                }

                return success;
              },
              onUpdate: (ingredient, {inCart, name}) async {
                ListIngredient? updated =
                    await ingredient.patch(name: name, inCart: inCart);
                if (updated != null) {
                  ShoppingList? newList =
                      await ShoppingList.get(_list!.homegroup);

                  setState(() {
                    _list = newList;
                  });

                  _sendUpdate();
                }
              },
              onClear: () async {
                ShoppingList? newList = await _list!.clear();

                if (newList != null) {
                  setState(() {
                    _list = newList;
                  });
                }

                _sendUpdate();
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ListArea extends StatelessWidget {
  final ShoppingList list;
  final Function() onAddOne;
  final Function() onAddMany;
  final Function() onClear;
  final Future<bool> Function(ListIngredient ingredient) onDelete;
  final Function(ListIngredient ingredient, {String? name, bool? inCart})
      onUpdate;
  const ListArea({
    super.key,
    required this.list,
    required this.onAddOne,
    required this.onAddMany,
    required this.onDelete,
    required this.onUpdate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.separated(
            key: UniqueKey(),
            itemCount: list.ingredients.length,
            padding: const EdgeInsets.all(8),
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListRow(
                ingredient: list.ingredients[index],
                onToggle: (value) {
                  onUpdate(list.ingredients[index], inCart: value);
                },
                apiRemove: (ingredient) async => await onDelete(ingredient),
                index: index,
              );
            },
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            ButtonStyle buttonStyle = ButtonStyle(
                fixedSize: MaterialStatePropertyAll(
                  Size(constraints.maxWidth / 3, 45),
                ),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.zero, top: Radius.circular(10)),
                  ),
                ),
                padding: const MaterialStatePropertyAll(EdgeInsets.zero));

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () => onAddMany(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.post_add), Text("Add Recipes")],
                  ),
                ),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () => onAddOne(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.add), Text("Add Item")],
                  ),
                ),
                ElevatedButton(
                  style: buttonStyle.copyWith(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.error),
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.onError),
                  ),
                  onPressed: () => onClear(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.delete), Text("Clear List")],
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }
}
