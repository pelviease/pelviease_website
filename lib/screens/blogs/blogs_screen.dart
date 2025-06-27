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
  _BlogsScreenState createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen>
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
    return Consumer<BlogProvider>(builder: (context, blogProvider, _) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Our Latest Blogs",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4E1E6), // Light pink background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: backgroundColor,
                        unselectedLabelColor: Colors.black,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: buttonColor,
                        ),
                        indicatorPadding:
                            const EdgeInsets.symmetric(horizontal: 1),
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Our blogs'),
                          Tab(text: 'News'),
                          Tab(text: 'Success stories'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * 0.6, // Adjust height as needed
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBlogList(
                          blogProvider.blogsStream, (blogs) => blogs),
                      _buildBlogList(
                          blogProvider.blogsStream,
                          (blogs) => blogs
                              .where((blog) => blog.blogType == 'blogs')
                              .toList()),
                      _buildBlogList(
                          blogProvider.blogsStream,
                          (blogs) => blogs
                              .where((blog) => blog.blogType == 'news')
                              .toList()),
                      _buildBlogList(
                          blogProvider.blogsStream,
                          (blogs) => blogs
                              .where((blog) => blog.blogType == 'sucessStories')
                              .toList()),
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
      Stream<List<Blog>> stream, List<Blog> Function(List<Blog>) filter) {
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
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        final blogs = filter(snapshot.data!);
        return SizedBox(
          width: MediaQuery.of(context).size.width > 600
              ? MediaQuery.of(context).size.width * 0.82
              : MediaQuery.of(context).size.width,
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: blogs.map((blog) => BlogCard(blog: blog)).toList(),
          ),
        );
      },
    );
  }
}
