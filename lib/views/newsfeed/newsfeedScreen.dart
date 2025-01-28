import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_test/controllers/newsfeed/newsfeedController.dart';
import 'package:social_test/helpers/projectResources.dart';
import 'package:social_test/helpers/routes.dart';
import 'package:social_test/styles/colors.dart';
import 'package:social_test/views/newsfeed/createPostScreen.dart';

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
          return PostWidget(username: newsfeedControllerVar.newsFeedList[index].user?.fullName??'',
            timeAgo: newsfeedControllerVar.newsFeedList[index].createdAt.toString(),
            content: newsfeedControllerVar.newsFeedList[index].feedTxt??'',
            screenWidth: ProjectResource.screenWidth * .9,);
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
      body: SingleChildScrollView(
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
      bottomNavigationBar: BottomNavigationBar(
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

class PostWidget extends StatefulWidget {
  final String username;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  final double screenWidth;

  const PostWidget({
    Key? key,
    required this.username,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.screenWidth,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with TickerProviderStateMixin {
  bool showReactions = false;
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
    if (showReactions) {
      _animationController.reverse();
        setState(() => showReactions = false);

    } else {
      setState(() => showReactions = true);
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
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.timeAgo),
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
            Text(widget.content),
            const SizedBox(height: 10),
            if (widget.imageUrl != null)
              Image.network(
                widget.imageUrl!,
                width: widget.screenWidth,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
            // Reactions
            Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onLongPressDown: (_) {
                        toggleReactions();
                      },
                      onTap: () {
                        // Handle like
                      },
                      child: const Text('👍 Like'),
                    ),
                    Spacer(),
                    const Text('💬 Comment'),
                  ],
                ),
                if (showReactions)
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
                            children: const [
                              ReactionBubble(reaction: '👍'),
                              ReactionBubble(reaction: '❤'),
                              ReactionBubble(reaction: '😢'),
                              ReactionBubble(reaction: '😘'),
                              ReactionBubble(reaction: '😡'),
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

  const ReactionBubble({Key? key, required this.reaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
            reaction,
            style: const TextStyle(fontSize: 20),
            ),
        );
    }
}