import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:social_test/controllers/newsfeed/newsfeedController.dart';
import 'package:social_test/helpers/dialogs.dart';
import 'package:social_test/helpers/images.dart';
import 'package:social_test/helpers/projectResources.dart';
import 'package:social_test/helpers/routes.dart';
import 'package:social_test/helpers/texts.dart';
import 'package:social_test/models/communityListModel.dart';
import 'package:social_test/styles/colors.dart';
import 'package:social_test/views/newsfeed/commentScreen.dart';
import 'package:social_test/views/newsfeed/createPostScreen.dart';

import '../../controllers/authentication/loginController.dart';
import 'postWidgetScreen.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  late NewsfeedController newsfeedController;
  late NewsfeedController newsfeedControllerVar;
  late ScrollController scrollController = ScrollController();

  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      newsfeedController.init();
      newsfeedController.getNewsfeedData(isMore: false);
      scrollController.addListener(() {
        if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 200) {
          print("Loading more...");
          if (!newsfeedControllerVar.loadingMore) {
            newsfeedController.getNewsfeedData(isMore: true);
          }
        }
      });

    });
  }

  @override
  void didChangeDependencies() {
    newsfeedController = Provider.of<NewsfeedController>(context, listen: false);
    newsfeedControllerVar = Provider.of<NewsfeedController>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }


  getPostButton(){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: (){
          Navigator.push(context, SlideBottomRoute(page: CreatePostScreen())).then((v){
            if(v!=null){
              newsfeedController.init();
              newsfeedController.getNewsfeedData(isMore: false);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.themeColor)
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.blackColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Icon(Icons.person,
                  size: ProjectResource.fontSizeFactor * 3.5,
                  color: AppColors.blackColor.withAlpha(60),),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text("Write Something Here...",
                  style: TextStyle(
                      color: AppColors.blackColor.withAlpha(90)
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                    color: AppColors.themeColor,
                    borderRadius: BorderRadius.circular(7)
                ),
                child: Text('Post', style: TextStyle(color: AppColors.whiteColor),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getNewsfeedList(){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: newsfeedControllerVar.newsFeedList.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return PostWidget(
            newsfeedData: newsfeedControllerVar.newsFeedList[index],
            index: index,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Python Developer Community',style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ProjectResource.fontSizeFactor*1
            ),),
            const SizedBox(height: 3,),
            Text('#General', style: TextStyle(
                color: AppColors.whiteColor.withOpacity(0.7),
                fontSize: ProjectResource.fontSizeFactor* .9
            ),),
          ],
        ),
        toolbarHeight: ProjectResource.screenHeight * .09,

        backgroundColor: AppColors.themeColor,
      ),
      drawer: Drawer(),
      body: PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result)  async {
        ProjectResource.onWillPopExit(context: context);
      },
        child: GestureDetector(
          onTap: (){
            if(newsfeedControllerVar.showReactions) {
              newsfeedController.removePopup();
            }
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // Post input
                getPostButton(),
                newsfeedControllerVar.loading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : newsfeedControllerVar.loading
                    ? ProjectResource.getErrorView()
                    : getNewsfeedList(),
                newsfeedControllerVar.loadingMore
                    ? Center(
                    child: CircularProgressIndicator()):Container(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          if(index == 1){
            Dialogs.logoutDialog(context, onResponse: (){
              Navigator.pop(context);
              Provider.of<LoginController>(context,listen: false).performLogout(context: context);
            }, title: "Logout", content: "Are you sure you want to logout?", buttonText: "Yes");
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
