import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../src/model/tasks.dart';
import '../const.dart';
import 'package:url_launcher/url_launcher.dart';

class TextToMarkdown extends StatelessWidget {
  const TextToMarkdown({
    super.key,
    required this.note,
  });

  final Tasks note;

  Future<void> _lauchLink (String url) async {
    final Uri copyUrl = Uri.parse(url);
    if((url != '')  && await canLaunchUrl(copyUrl)){
      await launchUrl(copyUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        MarkdownBody(data: '# ${note.title}'),
        Text(
          note.createdTime != null
              ? 'Created at: ${DateFormat('dd/MM/yyyy HH:mm').format(note.createdTime!)}'
              : '',
          style: kSmallText,
        ),
        const SizedBox(height: 16),
        MarkdownBody(
          selectable: true,
          data: note.content!,
          onTapLink: (text, url, title) {
            _lauchLink(url ?? '');
          },
          styleSheet: MarkdownStyleSheet(
            a: const TextStyle(
              color: Colors.indigo,
            ),
            horizontalRuleDecoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            blockquoteDecoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.circular(10.0), // Adjust margin for sidebar
            ),
            checkbox: const TextStyle(color: Colors.white),
            code: const TextStyle(
                color: Colors.black,
                backgroundColor: Colors.grey),
            codeblockPadding: const EdgeInsets.all(8),
            codeblockDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
