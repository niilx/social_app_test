import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:social_test/models/communityListModel.dart';

import '../../controllers/newsfeed/newsfeedController.dart';
import '../../helpers/images.dart';
import '../../helpers/projectResources.dart';
import '../../helpers/texts.dart';
import '../../styles/colors.dart';
import 'commentScreen.dart';

class PostWidget extends StatefulWidget {
  final CommunityListModel newsfeedData;
  final int index;

  const PostWidget({
    Key? key,
    required this.newsfeedData,
    required this.index,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with TickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _positionAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: const Offset(0, 0))
        .animate(_animationController);
  }

  void toggleReactions() {
    if (Provider.of<NewsfeedController>(context,listen: false).showReactions) {
      _animationController.reverse();
      setState(() => Provider.of<NewsfeedController>(context,listen: false).showReactions = false);

    } else {
      setState(() => Provider.of<NewsfeedController>(context,listen: false).showReactions = true);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsController = Provider.of<NewsfeedController>(context,listen: false);
    final newsControllerVar = Provider.of<NewsfeedController>(context);

    getCommentView(){
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => CommentBottomSheet(feedData: widget.newsfeedData,),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                ClipOval(
                  child: Opacity(
                    opacity: 0.4,
                    child: CachedImage(
                      url: widget.newsfeedData.user?.profilePic??'',
                      fit: BoxFit.cover,
                      height: ProjectResource.screenHeight * .04,
                      width: ProjectResource.screenHeight * .04,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.newsfeedData.name??'',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(ProjectResource.timeAgo(widget.newsfeedData.createdAt!)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
// Content

            // Post & Reactions
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    widget.newsfeedData.bgColor != null && (widget.newsfeedData.feedTxt?.length??0) < 120?
                    GradientText(text: widget.newsfeedData.feedTxt??'', jsonResponse: widget.newsfeedData.bgColor??'',
                        style: TextStyle(
                            fontSize: ProjectResource.fontSizeFactor * 1.2,
                            fontWeight: FontWeight.w500
                        )):
                    Text(widget.newsfeedData.feedTxt??''),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        widget.newsfeedData.likeCount == 0?Container():  Row(
                          children: [


                            ...Iterable.generate(widget.newsfeedData.likeType?.length??0,(index){
                              return
                                widget.newsfeedData.likeType?[index].reactionType == "LIKE"?
                                SvgPicture.asset(
                                    "assets/icons/like.svg",
                                    width: ProjectResource.fontSizeFactor * 1.2
                                ):
                                widget.newsfeedData.likeType?[index].reactionType == "LOVE"?
                                Image.asset(
                                    "assets/icons/love.png",
                                    width: ProjectResource.fontSizeFactor * 1.2
                                ):
                                widget.newsfeedData.likeType?[index].reactionType == "CARE"?
                                Image.asset(
                                    "assets/icons/care.png",
                                    width: ProjectResource.fontSizeFactor * 1.2
                                ):
                                widget.newsfeedData.likeType?[index].reactionType == "WOW"?
                                Image.asset(
                                    "assets/icons/wow.png",
                                    width: ProjectResource.fontSizeFactor * 1.2
                                ):
                                widget.newsfeedData.likeType?[index].reactionType == "SAD"?
                                Image.asset(
                                    "assets/icons/sad.png",
                                    width: ProjectResource.fontSizeFactor * 1.2
                                ):Container()
                              ;
                            }),

                            Text('  ${widget.newsfeedData.likeCount} ${widget.newsfeedData.likeCount== 1?'':'Others'}', style: TextStyle(
                                fontSize: ProjectResource.fontSizeFactor * .9,
                                color: AppColors.blackColor.withAlpha(700)
                            ),),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            getCommentView();
                          },
                          child: Row(
                            children: [
                              widget.newsfeedData.commentCount == 0?Container():
                              SvgPicture.asset(
                                  "assets/icons/comment_transparent.svg",
                                  width: ProjectResource.fontSizeFactor * 1,
                                  colorBlendMode: BlendMode.screen

                              ),
                              widget.newsfeedData.commentCount == 0?Container(): Text(' ${widget.newsfeedData.commentCount} Comment', style: TextStyle(
                                  fontSize: ProjectResource.fontSizeFactor * 1.1,
                                  color: AppColors.button2Color
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onLongPressDown: (_) {
                            toggleReactions();
                          },
                          onTap: () {
                            // Handle like
                          },
                          child: Row(
                            children: [
                              newsControllerVar.loadingLike && (newsControllerVar.likeFeedId == widget.newsfeedData.id.toString()) ?
                              Container(
                                  height: ProjectResource.fontSizeFactor *1,
                                  width: ProjectResource.fontSizeFactor *1,
                                  child: CircularProgressIndicator()): SvgPicture.asset(
                                "assets/icons/like.svg",
                                width: ProjectResource.fontSizeFactor * 1.5,

                                colorBlendMode: BlendMode.srcIn,
                                color: AppColors.blackColor.withAlpha(700),

                              ),
                              Text(' Like', style: TextStyle(
                                  fontSize: ProjectResource.fontSizeFactor * 1.1,
                                  color: AppColors.blackColor.withAlpha(700)
                              ),),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            getCommentView();
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/icons/comment.svg",
                                  width: ProjectResource.fontSizeFactor * 1.3,

                                  colorBlendMode: BlendMode.screen

                              ),
                              Text(' Comment', style: TextStyle(
                                  fontSize: ProjectResource.fontSizeFactor * 1.1,
                                  color: AppColors.button2Color
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (Provider.of<NewsfeedController>(context).showReactions)
                  Positioned(
                    bottom: 30,
                    child: SlideTransition(
                      position: _positionAnimation,
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [

                              ReactionBubble(reaction: 'assets/icons/liker.png', reactionType: 'LIKE',action: "create",feedId: widget.newsfeedData.id.toString()),
                              ReactionBubble(reaction: 'assets/icons/love.png', reactionType: 'LOVE',action: "create",feedId: widget.newsfeedData.id.toString()),
                              ReactionBubble(reaction: 'assets/icons/sad.png', reactionType: 'SAD',action: "create",feedId: widget.newsfeedData.id.toString()),
                              ReactionBubble(reaction: 'assets/icons/care.png', reactionType: 'CARE',action: "create",feedId: widget.newsfeedData.id.toString()),
                              ReactionBubble(reaction: 'assets/icons/wow.png', reactionType: 'WOW',action: "create",feedId: widget.newsfeedData.id.toString()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReactionBubble extends StatelessWidget {
  final String reaction;
  final String feedId;
  final String action;
  final String reactionType;

  const ReactionBubble({Key? key, required this.reaction,required this.reactionType, required this.feedId, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print("2");
        Provider.of<NewsfeedController>(context,listen: false)
            .createUpdateLikeData(feedId: feedId, reactionType: reactionType, action: action);

      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child:
        Image.asset(
          reaction,
          width: ProjectResource.fontSizeFactor * 2.5,
        ),
      ),
    );
  }
}