import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/src/features/issues/presentation/maps/widgets/expanded_view.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';

class IssueCarousel extends StatefulWidget {
  final List<IssueModel> issues;
  final Function(IssueModel) onIssueSelected;
  final String? selectedIssueId;
  final bool isVisible;
  final Function() onToggleVisibility;

  const IssueCarousel({
    super.key,
    required this.issues,
    required this.onIssueSelected,
    this.selectedIssueId,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  _IssueCarouselState createState() => _IssueCarouselState();
}

class _IssueCarouselState extends State<IssueCarousel>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IssueCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIssueId != null &&
        widget.selectedIssueId != oldWidget.selectedIssueId) {
      final index =
          widget.issues.indexWhere((i) => i.id == widget.selectedIssueId);
      if (index != -1 && index != _currentPage) {
        _currentPage = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        // Ensure the PageView is at the correct index when collapsing
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pageController.jumpToPage(_currentPage);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: widget.isVisible ? Offset.zero : const Offset(0, 1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isExpanded ? MediaQuery.of(context).size.height : 150,
        child: _isExpanded
            ? IssuesExpandedView(
                issue: widget.issues[_currentPage],
                onPressed: () {
                  _toggleExpand();
                  widget.onIssueSelected(widget.issues[_currentPage]);
                })
            : _buildCarouselView(),
      ),
    );
  }

  Widget _buildCarouselView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.issues.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
        widget.onIssueSelected(widget.issues[index]);
      },
      itemBuilder: (context, index) {
        final issue = widget.issues[index];
        final isActive = index == _currentPage;

        return GestureDetector(
          onTap: _toggleExpand,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: isActive ? 0 : 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isActive ? 18 : 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(10),
                  Text(
                    issue.description,
                    style: TextStyle(fontSize: isActive ? 14 : 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
