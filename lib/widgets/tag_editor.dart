import 'package:empire_expert/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagEditor extends StatefulWidget {
  final List<Tag> tags;
  final void Function(List<Tag>) onChanged;

  const TagEditor({super.key, required this.tags, required this.onChanged});

  @override
  _TagEditorState createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  final TextEditingController _controller = TextEditingController();
  List<Tag> _selectedTags = [];
  List<Tag> _suggestedTags = [];
  final List<Tag> _initSuggestTags = [
    Tag('Hư bố thắng'),
    Tag('Hư xe'),
    Tag('Tag 3'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedTags = widget.tags;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Kết quả',
            hintText: 'Nhập kết quả...',
          ),
          onChanged: (value) async {
            setState(() {
              // You'll need to replace this with your own logic for
              // generating tag suggestions based on the user's input.
              _suggestedTags = _initSuggestTags.where((tag) {
                return tag.name.toLowerCase().contains(value.toLowerCase());
              }).toList();
            });
          },
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _controller.clear();
                var result = _initSuggestTags.where((tag) {
                  return tag.name.toLowerCase().contains(value.toLowerCase());
                });
                if (result.toList().isNotEmpty) {
                  _selectedTags.add(result.first);
                } else {
                  _selectedTags.add(Tag(value));
                }
                widget.onChanged(_selectedTags);
                _suggestedTags.clear();
              });
            }
          },
        ),
        SizedBox(
          height: 10.h,
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _selectedTags.map((tag) {
            return Chip(
              label: Text(tag.name),
              onDeleted: () {
                setState(() {
                  _selectedTags.remove(tag);
                  widget.onChanged(_selectedTags);
                });
              },
            );
          }).toList(),
        ),
        if (_suggestedTags.isNotEmpty)
          SizedBox(
            height: 100.0,
            child: ListView.builder(
              itemCount: _suggestedTags.length,
              itemBuilder: (context, index) {
                final tag = _suggestedTags[index];
                return ListTile(
                  title: Text(tag.name),
                  onTap: () {
                    setState(() {
                      _controller.clear();
                      _selectedTags.add(tag);
                      widget.onChanged(_selectedTags);
                      _suggestedTags = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
