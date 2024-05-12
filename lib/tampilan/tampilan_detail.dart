import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latihan_kuiz_123210117/source/load_data_source.dart';
import 'package:latihan_kuiz_123210117/model/detail_meal.dart';


class PageDetailMeal extends ConsumerWidget {
  final String idMeal;
  final String nameMeal;

  const PageDetailMeal({
    required this.idMeal,
    required this.nameMeal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String id = idMeal;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nameMeal,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green, // Ubah warna latar belakang AppBar
      ),
      body: _buildDetailMealBody(),
      backgroundColor: Colors.grey[200], // Ubah warna latar belakang body
    );
  }

  Widget _buildDetailMealBody() {
    String id = idMeal;
    return Container(
      padding: EdgeInsets.all(16),
      child: FutureBuilder(
        future: ApiDataSource.instance.loadDetailMeal(id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MealDetailModel mealDetail =
                MealDetailModel.fromJson(snapshot.data);
            return _buildSuccessSection(mealDetail);
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
        color: Colors.green, // Ubah warna indikator loading
      ),
    );
  }

  Widget _buildSuccessSection(MealDetailModel data) {
    return ListView.builder(
      itemCount: data.meals!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildDetailMealItem(context, data.meals![index]);
      },
    );
  }

  Widget _buildDetailMealItem(BuildContext context, Meals meal) {
    return Card(
      elevation: 4, // Tambahkan elevasi ke kartu
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Tambahkan logika ketika kartu diklik (jika diperlukan)
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              meal.strMealThumb!,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category : ${meal.strCategory}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink, // Ubah warna teks kategori
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Region : ${meal.strArea}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink, // Ubah warna teks region
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ingredients',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < meal.ingredients.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${meal.ingredients[i]} - ${meal.measures[i]}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Steps',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                meal.strInstructions!,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                launchURL(meal.strYoutube!);
              },
              child: Text(
                'Watch Tutorial',
                style: TextStyle(
                  color: Colors.white, // Ubah warna teks tombol
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pink), // Ubah warna latar belakang tombol
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

Future<void> launchURL(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await canLaunch(_url.toString())) {
    throw "Couldn't launch $_url";
  }
  await launch(_url.toString());
}
