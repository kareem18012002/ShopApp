
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2/modules/shop_modules/categories/categories%20details/categories_details_screen.dart';
import 'package:shop2/modules/shop_modules/home/product_details.dart';

import '../../../main/cubit.dart';
import '../../../main/state.dart';
import '../../../models/category_model.dart';
import '../../../models/home_model.dart';
import '../../../shared/components/components.dart';
class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is ChangeFavoritesSuccessStates) {
          if (state.model.status!) {
            showToast(
              text: state.model.message!,
              state: ToastStates.success,
            );
          } else {
            showToast(
              text: state.model.message!,
              state: ToastStates.error,
            );
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: MainCubit.get(context).homeModel != null &&
              MainCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              MainCubit.get(context).homeModel!,
              MainCubit.get(context).categoriesModel!,
              context),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(
      HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: CarouselSlider(
                items: model.data!.banners
                    .map(
                      (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image(
                          image: NetworkImage('${e.image}'),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 140.0,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Scrollbar(
                      thickness: 1,
                      child: ListView.separated(
                        padding:
                        const EdgeInsetsDirectional.only(start: 10.0, top: 10),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => CategoriesItem(
                            categoriesModel.data!.data[index], context),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 10.0,
                        ),
                        itemCount: categoriesModel.data!.data.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New Products',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 1.5,
                    children: List.generate(
                      model.data!.products.length,
                          (index) =>
                          GridProducts(model.data!.products[index], context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget CategoriesItem(DataModel model, context) => InkWell(
    onTap: () {
      MainCubit.get(context).getCategoryDetailsData(model.id!);
      navigateTo(context, CategoriesDetailsScreen());
    },
    child: Container(
      width: 105,
      child: Column(
        children: [
          Container(
            width: 95.0,
            height: 82.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepPurple, width: 2),
              image: DecorationImage(
                image: NetworkImage(
                  model.image!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            model.name!.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  Widget GridProducts(ProductModel model, context) => InkWell(
    onTap:() {
      MainCubit.get(context).getProductData(model.id!);
      navigateTo(context, ProductDetailsScreen());
    },
    child: Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.none,
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: NetworkImage(
                    model.image!,
                  ),
                  width: double.infinity,
                  height: 150.0,
                ),
                SizedBox(height: 10,),
                Column(
                  children: [
                    Text(
                      model.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(
                          '${model.price.round()}\ LE',
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 7.0,
                        ),
                        if (model.discount != 0)
                          Text(
                            '${model.oldPrice.round()}\ LE',
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 0,
          child: IconButton(
            onPressed: () {
              MainCubit.get(context).changeFavorites(model.id!);
            },
            icon: Icon(
              MainCubit.get(context).favorites[model.id]
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: MainCubit.get(context).favorites[model.id]
                  ? Colors.red
                  : Colors.grey,
              size: 26,
            ),
          ),
        ),
        if (model.discount != 0)
          Positioned.fill(
            child: Align(
              alignment: const Alignment(1, -1),
              child: ClipRect(
                child: Banner(
                  message: 'OFFERS',
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                  location: BannerLocation.topStart,
                  color: Colors.red,
                  child: Container(
                    height: 100.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}