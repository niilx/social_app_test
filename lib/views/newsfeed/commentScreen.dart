import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:social_test/controllers/newsfeed/newsfeedController.dart';
import 'package:social_test/helpers/images.dart';
import 'package:social_test/helpers/projectResources.dart';
import 'package:social_test/models/commentListModel.dart';
import 'package:social_test/models/communityListModel.dart';
import 'package:social_test/styles/colors.dart';

class CommentBottomSheet extends StatefulWidget {
  CommunityListModel feedData;

  CommentBottomSheet({super.key, required this.feedData});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late NewsfeedController newsfeedController;
  late NewsfeedController newsfeedControllerVar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      newsfeedController.initComment();
      newsfeedController.getFeedCommentData(
          feedId: (widget.feedData.id ?? 0).toString());
    });
  }

  @override
  void didChangeDependencies() {
    newsfeedController =
        Provider.of<NewsfeedController>(context, listen: false);
    newsfeedControllerVar =
        Provider.of<NewsfeedController>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProjectResource.setScreenSize(context);
    return Container(
      height: ProjectResource.screenHeight * .7,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (Reactions)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.feedData.likeCount == 0
                ? Container()
                : Row(
                    children: [
                      ...Iterable.generate(
                          widget.feedData.likeType?.length ?? 0, (index) {
                        return widget.feedData.likeType?[index].reactionType ==
                                "LIKE"
                            ? SvgPicture.asset("assets/icons/like.svg",
                                width: ProjectResource.fontSizeFactor * 1.2)
                            : widget.feedData.likeType?[index].reactionType ==
                                    "LOVE"
                                ? Image.asset("assets/icons/love.png",
                                    width: ProjectResource.fontSizeFactor * 1.2)
                                : widget.feedData.likeType?[index]
                                            .reactionType ==
                                        "CARE"
                                    ? Image.asset("assets/icons/care.png",
                                        width: ProjectResource.fontSizeFactor *
                                            1.2)
                                    : widget.feedData.likeType?[index]
                                                .reactionType ==
                                            "WOW"
                                        ? Image.asset("assets/icons/wow.png",
                                            width:
                                                ProjectResource.fontSizeFactor *
                                                    1.2)
                                        : widget.feedData.likeType?[index]
                                                    .reactionType ==
                                                "SAD"
                                            ? Image.asset(
                                                "assets/icons/sad.png",
                                                width: ProjectResource
                                                        .fontSizeFactor *
                                                    1.2)
                                            : Container();
                      }),
                      Text(
                        '  ${widget.feedData.likeCount} ${widget.feedData.likeCount == 1 ? '' : 'Others'}',
                        style: TextStyle(
                            fontSize: ProjectResource.fontSizeFactor * .9,
                            color: AppColors.blackColor.withAlpha(700)),
                      ),
                    ],
                  ),
          ),

          Divider(),

          // Comment List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  newsfeedControllerVar.loadingComment ?
                      CircularProgressIndicator():
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: newsfeedControllerVar.commentList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return CommentTile(
                          commentListModel: newsfeedControllerVar.commentList[index]
                        );
                      }),
                ],
              ),
            ),
          ),

          // Comment Input Box
          _buildCommentInputField(),
        ],
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 16,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: newsfeedControllerVar.commentController,
              decoration: InputDecoration(
                hintText: "Write a Comment",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(icon:
          newsfeedControllerVar.loadingCreateComment ?
              Container(
                height: ProjectResource.fontSizeFactor * 1.4,
                width:ProjectResource.fontSizeFactor * 1.4 ,
                child: CircularProgressIndicator(),
              ):
          Icon(Icons.send, color: AppColors.themeColor),
          onPressed: (){
            if(newsfeedControllerVar.commentController.text.isNotEmpty){
              newsfeedController.createCommentData(feedId: (widget.feedData.id??0).toString(), feedUserId: (widget.feedData.user?.id??0).toString());
            }
          },
          ),
        ],
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  final CommentListModel commentListModel;

  const CommentTile({
    required this.commentListModel
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: ClipOval(
            child: Opacity(
              opacity: 0.4,
              child: CachedImage(
                url: commentListModel.user?.profilePic??'',
                fit: BoxFit.cover,
                height: ProjectResource.screenHeight * .04,
                width: ProjectResource.screenHeight * .04,
              ),
            ),
          ),
          title: Text(commentListModel.user?.fullName??'', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(commentListModel.commentTxt??''),
          trailing: Icon(Icons.more_horiz),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              SizedBox(width: ProjectResource.screenHeight * .05,),
              Text(ProjectResource.timeAgoShort(commentListModel.createdAt!), style: TextStyle(color: Colors.grey)),
              SizedBox(width: 10),
              Text("Like",
                  style: TextStyle(
                      color: AppColors.blackColor.withAlpha(700), fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text("Reply", style: TextStyle(color: AppColors.blackColor.withAlpha(700))),
              Spacer(),
              Row(
                children: [
                  Text("${commentListModel.commentlike??''}"),
                  SizedBox(width: 5),
                  Icon(Icons.thumb_up, color: Colors.blue, size: 18),
                ],
              ),
            ],
          ),
        ),

        // Replies
        commentListModel.replyCount != 0?
          Provider.of<NewsfeedController>(context,listen: true).loadingCommentReply &&
              Provider.of<NewsfeedController>(context,listen: true).replyCommentId == commentListModel.id.toString()?
          Padding(
            padding: EdgeInsets.only(left: ProjectResource.screenHeight * .07, top: 5),
            child: Container(
                height: ProjectResource.fontSizeFactor,
                width: ProjectResource.fontSizeFactor,
                child: CircularProgressIndicator()),
          ):
          Provider.of<NewsfeedController>(context,listen: true).commentReplyList.any((e)=>e.parrentId.toString()==commentListModel.id.toString())?
          Padding(
            padding:  EdgeInsets.only(left: ProjectResource.screenWidth * .1),
            child: Column(
              children: Provider.of<NewsfeedController>(context, listen: true)
                  .commentReplyList
                  .where((e) => e.parrentId.toString() == commentListModel.id.toString())
                  .map((reply) => CommentTile(commentListModel: reply))
                  .toList(),
            ),
          ):
          InkWell(
            onTap: (){
              Provider.of<NewsfeedController>(context,listen: false).getFeedCommentReplyData(commentId: commentListModel.id.toString());
            },
            child: Padding(
              padding: EdgeInsets.only(left: ProjectResource.screenHeight * .07, top: 5),
              child: Text("View ${commentListModel.replyCount} Replies",style: TextStyle(
                fontSize: ProjectResource.fontSizeFactor,
                color: AppColors.blackColor.withAlpha(700),
                decoration: TextDecoration.underline
              ),),
            ),
          ):Container(),
      ],
    );
  }
}
