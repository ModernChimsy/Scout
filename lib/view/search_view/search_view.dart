// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/common%20widget/no_data_found_widget.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/search_view/controller/filter_controller.dart';
import 'package:restaurent_discount_app/view/search_view/controller/location_filter_controller.dart';
import 'package:restaurent_discount_app/view/search_view/search_details_page.dart';

import '../../common widget/custom text/custom_text_widget.dart';

class EventCategoryScreen extends StatefulWidget {
  @override
  _EventCategoryScreenState createState() => _EventCategoryScreenState();
}

class _EventCategoryScreenState extends State<EventCategoryScreen> {
  final List<Category> categories = [
    Category("Music", "https://ciac.uiu.ac.bd/wp-content/uploads/2018/08/austin-neill-247047-unsplash.jpg"),
    Category("Sport", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQujYgGA83X-bf70YeHs5PPzJCP107naLymbg&s"),
    Category("Festivals", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbB14Z-rV5i2EHhz61PgqLVl4a0_BJhTcArg&s"),
    Category(
      "Art & Theatre",
      "https://upload.wikimedia.org/wikipedia/commons/5/5d/Labudovo_jezero%2C_Balet_SNP-a%2C_Jelena_Le%C4%8Di%C4%87%2C_Andrej_Kol%C4%8Deriju%2C_foto_M._Polzovi%C4%87.jpg",
    ),
    Category("Nightlife", "https://ciac.uiu.ac.bd/wp-content/uploads/2018/08/austin-neill-247047-unsplash.jpg"),
    Category("Food & Drink", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_4y-42Isg1bbcN-2wfhw2YwpNMSgkJkWSXg&s"),
  ];

  final TextEditingController _searchC = TextEditingController();
  final FilterController _filterController = Get.put(FilterController());
  final LocationFilterController _locationFilterController = Get.put(LocationFilterController());

  List<Category> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;

    _searchC.addListener(() {
      final query = _searchC.text.trim().toLowerCase();

      setState(() {
        if (query.isEmpty) {
          filteredCategories = categories;
        } else {
          // Filter the displayed categories by what the user is typing (Local filtering)
          filteredCategories = categories.where((category) => category.name.toLowerCase().contains(query)).toList();
        }
      });
    });
  }

  // Function to handle the full-event search and navigation (Remote search)
  void _handleSearchSubmit(String query) {
    if (query.trim().isNotEmpty) {
      // Navigate to SearchDetailsPage with the search query
      Get.to(() => SearchDetailsPage(searchQuery: query.trim()));
      // OPTIONAL: Clear the search field after submitting
      // _searchC.clear();
    }
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: CustomText(text: 'Search', color: isDarkMode ? Colors.white : Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          centerTitle: false,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomTextField(
                controller: _searchC,
                prefixIcon: Icons.search,
                fillColor: Colors.transparent,
                borderColor: Colors.grey,
                hintText: "Search for friends or events",
                showObscure: false,
                onSubmitted: _handleSearchSubmit,
              ),
              SizedBox(height: 10),
              Expanded(
                child: filteredCategories.isEmpty
                    ? Center(child: NotFoundWidget(message: "No Search Result Found"))
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to SearchDetailsPage with the category tag
                        // This triggers the category-based event search
                        Get.to(() => SearchDetailsPage(tag: filteredCategories[index].name.toLowerCase()));
                      },
                      child: EventCategoryCard(category: filteredCategories[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class EventCategoryCard extends StatelessWidget {
  final Category category;

  const EventCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: NetworkImage(category.image), fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomText(textAlign: TextAlign.center, text: category.name, color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final String image;

  Category(this.name, this.image);
}
