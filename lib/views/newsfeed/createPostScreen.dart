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
          color: AppColors.greyColor
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
                Row(
                  children: [
                    ...Iterable.generate(AppColors.gradientsColor.length,(index){
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: (){
                            newsfeedController.selectGradient(index);
                          },
                          child: Container(
                            height: ProjectResource.fontSizeFactor * 2.2,
                            width: ProjectResource.fontSizeFactor * 2.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: AppColors.gradientsColor[index],
                              border: newsfeedControllerVar.selectedGradientBg == AppColors.feedBackGroundGradientColors[index] ?
                                  Border.all(color: AppColors.blackColor.withAlpha(80), width: 4):null
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