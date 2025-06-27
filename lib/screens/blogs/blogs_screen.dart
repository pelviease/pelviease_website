import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/models/blog.dart';
import 'package:pelviease_website/backend/providers/blogs_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:pelviease_website/widgets/footer.dart';
import 'package:provider/provider.dart';
import 'widgets/blog_card.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  BlogsScreenState createState() => BlogsScreenState();
}

class BlogsScreenState extends State<BlogsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 900;

    return Consumer<BlogProvider>(builder: (context, blogProvider, _) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: 16,
          ),
          child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Our Latest Blogs",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: isMobile
                            ? 24
                            : isTablet
                                ? 28
                                : 32,
                      ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: isMobile
                        ? size.width - 60
                        : isTablet
                            ? size.width * 0.6
                            : size.width * 0.4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4E1E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: isMobile,
                      labelColor: backgroundColor,
                      unselectedLabelColor: Colors.black,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: buttonColor,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Our blogs'),
                        Tab(text: 'News'),
                        Tab(text: 'Success stories'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 40 : 20),
                SizedBox(
                  height: isMobile
                      ? size.height * 0.7
                      : isTablet
                          ? size.height * 0.65
                          : size.height * 0.7,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBlogList(
                        blogProvider.blogsStream,
                        (blogs) => blogs,
                        size,
                        isMobile,
                        isTablet,
                      ),
                      _buildBlogList(
                        blogProvider.blogsStream,
                        (blogs) => blogs
                            .where((blog) => blog.blogType == 'blogs')
                            .toList(),
                        size,
                        isMobile,
                        isTablet,
                      ),
                      _buildBlogList(
                        blogProvider.blogsStream,
                        (blogs) => blogs
                            .where((blog) => blog.blogType == 'news')
                            .toList(),
                        size,
                        isMobile,
                        isTablet,
                      ),
                      _buildBlogList(
                        blogProvider.blogsStream,
                        (blogs) => blogs
                            .where((blog) => blog.blogType == 'successStories')
                            .toList(),
                        size,
                        isMobile,
                        isTablet,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const FooterSection(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBlogList(
    Stream<List<Blog>> stream,
    List<Blog> Function(List<Blog>) filter,
    Size size,
    bool isMobile,
    bool isTablet,
  ) {
    return StreamBuilder<List<Blog>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No blogs available',
              style: TextStyle(color: textColor),
            ),
          );
        }
        final blogs = filter(snapshot.data!);
        return blogs.isEmpty
            ? const Center(
                child: Text(
                  'No blogs available',
                  style: TextStyle(color: textColor),
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    spacing: isMobile ? 16 : 24,
                    runSpacing: isMobile ? 16 : 24,
                    alignment: WrapAlignment.start,
                    children: blogs.map((blog) {
                      final cardWidth = isMobile
                          ? size.width - 32
                          : isTablet
                              ? (size.width - 48) / 2
                              : (size.width - 72) / 3;
                      return SizedBox(
                        width: cardWidth.clamp(300, 400),
                        child: BlogCard(blog: blog),
                      );
                    }).toList(),
                  ),
                ),
              );
      },
    );
  }
}
