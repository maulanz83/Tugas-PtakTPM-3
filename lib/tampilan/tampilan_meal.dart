import 'package:flutter/material.dart';
import 'package:latihan_kuiz_123210117/source/load_data_source.dart';
import 'package:latihan_kuiz_123210117/tampilan/tampilan_detail.dart';
import 'package:latihan_kuiz_123210117/model/meal.dart';
import 'package:transparent_image/transparent_image.dart';

class PageMeal extends StatefulWidget {
  final String category;

  PageMeal({required this.category});

  @override
  State<PageMeal> createState() => _PageMealState();
}

class _PageMealState extends State<PageMeal> {
  @override
  Widget build(BuildContext context) {
    String category = widget.category;
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.green,
      ),
      body: _buildMealListBody(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildMealListBody() {
    String category = widget.category;
    return Container(
      padding: EdgeInsets.all(16),
      child: FutureBuilder(
        future: ApiDataSource.instance.loadMeal(category),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MealModel mealModel = MealModel.fromJson(snapshot.data);
            return _buildSuccessSection(mealModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Center(
      child: Text(
        "Error occurred while loading data.",
        style: TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.green,
      ),
    );
  }

  Widget _buildSuccessSection(MealModel data) {
    return ListView.builder(
      itemCount: data.meals!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildMealItem(data.meals![index]);
      },
    );
  }

  Widget _buildMealItem(Meals meal) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageDetailMeal(
                idMeal: meal.idMeal!,
                nameMeal: meal.strMeal!,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Hero(
              tag: meal.idMeal!,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: meal.strMealThumb!,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54.withOpacity(0.5), // Ubah opasitas menjadi 0.5
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.strMeal!,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
