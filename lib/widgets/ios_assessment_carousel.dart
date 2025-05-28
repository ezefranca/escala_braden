import 'package:flutter/cupertino.dart';

class IOSAssessmentCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> domains;
  final bool isComplete;
  final bool saving;
  final VoidCallback onSave;
  const IOSAssessmentCarousel({required this.domains, required this.isComplete, required this.saving, required this.onSave, super.key});

  @override
  State<IOSAssessmentCarousel> createState() => _IOSAssessmentCarouselState();
}

class _IOSAssessmentCarouselState extends State<IOSAssessmentCarousel> {
  late final PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.ease);
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    final lastPage = _page == widget.domains.length - 1;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Avaliação Braden'),
        trailing: lastPage && widget.isComplete && !widget.saving
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Salvar'),
                onPressed: widget.onSave,
              )
            : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.domains.length,
                itemBuilder: (context, i) {
                  final domain = widget.domains[i];
                  final title = domain['title']?.toString() ?? '';
                  final desc = domain['desc']?.toString() ?? '';
                  final widgetField = domain['widget'] is Widget ? domain['widget'] as Widget : const SizedBox.shrink();
                  // Only show the header here. Do NOT use showHeader or any conditional for the header.
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(desc, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        widgetField,
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_page > 0)
                  CupertinoButton(
                    child: const Text('Anterior'),
                    onPressed: () => _goTo(_page - 1),
                  )
                else
                  const SizedBox(width: 80),
                Text('Etapa ${_page + 1} de ${widget.domains.length}'),
                if (_page < widget.domains.length - 1)
                  CupertinoButton(
                    child: const Text('Próximo'),
                    onPressed: () => _goTo(_page + 1),
                  )
                else
                  const SizedBox(width: 80),
              ],
            ),
            if (widget.saving)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
