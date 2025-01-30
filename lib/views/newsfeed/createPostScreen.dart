import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_test/controllers/newsfeed/newsfeedController.dart';
import 'package:social_test/helpers/projectResources.dart';
import 'package:social_test/styles/colors.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late NewsfeedController newsfeedController;
  late NewsfeedController newsfeedControllerVar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      newsfeedController.initPost();
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

  @override
  Widget build(BuildContext context) {
    ProjectResource.setScreenSize(context);
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Close", style: TextStyle(
          color: AppColors.blackColor.withAlpha(650)
        ),)),
        leadingWidth: ProjectResource.screenWidth * .2,
        centerTitle: true,
        title: Text('Create Post',style: TextStyle(
            color: AppColors.blackColor,
            fontSize: ProjectResource.fontSizeFactor*1
        ),),
        actions: [
          TextButton(onPressed: (){
            newsfeedController.createPostData(context: context);
          }, child:
          newsfeedControllerVar.loadingPost?
              CircularProgressIndicator():
          Text("Create"))
        ],
        
      ),
      body: Column(
        children: [
          // Post input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: newsfeedControllerVar.postController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: newsfeedControllerVar.postControllerNode,
                  keyboardType: TextInputType.text,
                  cursorColor: AppColors.greyColor,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    filled: true,
                    fillColor: AppColors.whiteColor,
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: AppColors.greyColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                        new BorderSide(color: AppColors.themeColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: AppColors.greyColor)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: new BorderSide(color: AppColors.greyColor)),
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  validator: (String? value) {
                    return value == null
                        ? "Invalid post"
                        : null;
                  },
                ),
                SizedBox(height: ProjectResource.screenHeight * .02,),

               !newsfeedControllerVar.showSetBg? InkWell(
                 onTap: (){
                   newsfeedController.toggleSetBg();
                 },
                 child: Container(
                   padding: EdgeInsets.all(7),
                    height: ProjectResource.fontSizeFactor * 2.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.format_color_fill,
                        size: ProjectResource.fontSizeFactor * 1.5,
                        ),
                        SizedBox(width: 7,),
                        Text("Set Background",style: TextStyle(
                          fontSize: ProjectResource.fontSizeFactor * .9
                        ),)
                      ],
                    ),
                  ),
               ):
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        newsfeedController.toggleSetBg();
                      },
                      child: Container(
                        height: ProjectResource.fontSizeFactor * 2.7,
                        width: ProjectResource.fontSizeFactor * 2.7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.whiteColor,
                        ),
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    ...Iterable.generate(AppColors.gradientsColor.length,(index){
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: (){
                            newsfeedController.selectGradient(index);
                          },
                          child: Container(
                            height: ProjectResource.fontSizeFactor * 2.7,
                            width: ProjectResource.fontSizeFactor * 2.7,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: AppColors.gradientsColor[index],
                              border: newsfeedControllerVar.selectedGradientBg == AppColors.feedBackGroundGradientColors[index] ?
                                  Border.all(color: AppColors.blackColor.withAlpha(400), width: 4):null
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}