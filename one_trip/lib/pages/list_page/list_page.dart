// import 'package:flutter/material.dart';
// import 'package:one_trip/api/models/recipe.dart';
// import 'package:one_trip/api/models/user.dart';
// import 'package:one_trip/pages/recipes_page/widgets/recipe_card_widget.dart';
// import 'package:one_trip/widgets/text_entry_dialog.dart';

// class RecipesPage extends StatefulWidget {
//   const RecipesPage({super.key});

//   @override
//   State<RecipesPage> createState() => _RecipesPageState();
// }

// class _RecipesPageState extends State<RecipesPage> {
//   late Future<List<Recipe>> _recipes;
//   late User _userInfo;

//   Future<List<Recipe>> _fetchList() async {
//     User? userInfo = await User.getMe();
//     if (userInfo == null || userInfo.homegroup == null) {
//       return [];
//     }
//     _userInfo = userInfo;

//     List<Recipe> recipes = await Recipe.getList(_userInfo.homegroup!);
//     return recipes;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _recipes = _fetchList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _recipes,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text(snapshot.error.toString());
//         } else if (snapshot.hasData &&
//             snapshot.connectionState == ConnectionState.done) {
//           return RecipeList(
//               recipes: snapshot.data!, homegroup: _userInfo.homegroup!);
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }