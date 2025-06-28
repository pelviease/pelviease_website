import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/models/blog.dart';
import 'package:pelviease_website/backend/providers/blogs_provider.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:pelviease_website/screens/blogs/widgets/custom_tab_bar,dart';
import 'package:pelviease_website/widgets/footer.dart';
import 'package:provider/provider.dart';
import 'widgets/blog_card.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  BlogsScreenState createState() => BlogsScreenState();
}

class BlogsScreenState extends State<BlogsScreen> {
  int _selectedTabIndex = 0;

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
                  child: SizedBox(
                    width: isMobile
                        ? size.width - 20
                        : isTablet
                            ? size.width * 0.6
                            : size.width * 0.4,
                    child: CustomTabBar(
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      tabLabels: const [
                        'All',
                        'Our blogs',
                        'News',
                        'Victories',
                      ],
                      selectedColor: backgroundColor,
                      unselectedColor: Colors.black,
                      backgroundColor: const Color(0xFFF4E1E6),
                      indicatorColor: buttonColor,
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 40 : 20),
                SizedBox(
                  height: isMobile
                      ? size.height * 0.7
                      : isTablet
                          ? size.height * 0.65
                          : size.height * 0.5,
                  child: _buildCurrentTabContent(
                    blogProvider,
                    size,
                    isMobile,
                    isTablet,
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

  Widget _buildCurrentTabContent(
    BlogProvider blogProvider,
    Size size,
    bool isMobile,
    bool isTablet,
  ) {
    List<Blog> Function(List<Blog>) filter;

    switch (_selectedTabIndex) {
      case 0:
        filter = (blogs) => blogs;
        break;
      case 1:
        filter =
            (blogs) => blogs.where((blog) => blog.blogType == 'blogs').toList();
        break;
      case 2:
        filter =
            (blogs) => blogs.where((blog) => blog.blogType == 'news').toList();
        break;
      case 3:
        filter = (blogs) =>
            blogs.where((blog) => blog.blogType == 'successStories').toList();
        break;
      default:
        filter = (blogs) => blogs;
    }

    return _buildBlogList(
      blogProvider.blogsStream,
      filter,
      size,
      isMobile,
      isTablet,
    );
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
                              : (size.width - 150) / 5;
                      return SizedBox(
                        width: cardWidth,
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
