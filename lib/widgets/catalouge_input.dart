import 'package:empire_expert/models/response/problem.dart';
import 'package:empire_expert/services/diagnose_services/diagnose_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CataLougeInput extends StatefulWidget {
  final List<ProblemModel> tags;
  final void Function(List<ProblemModel>) onChanged;

  const CataLougeInput(
      {super.key, required this.tags, required this.onChanged});

  @override
  _CataLougeInputState createState() => _CataLougeInputState();
}

class _CataLougeInputState extends State<CataLougeInput> {
  final TextEditingController _controller = TextEditingController();
  List<ProblemModel> _selectedTags = [];
  List<ProblemModel> _suggestedTags = [];
  final List<ProblemModel> _initSuggestTags = [];
  final bool _loading = true;

  // _fetchInitSuggestTag() async {
  //   var result = await DiagnoseService().getListProblem();
  //   setState(() {
  //     _initSuggestTags = result;
  //     _loading = false;
  //   });
  //   return result;
  // }

  @override
  void initState() {
    super.initState();
    // _fetchInitSuggestTag();
    _selectedTags = widget.tags;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  hintText: 'Nhập danh mục...',
                ),
                onChanged: (value) async {
                  setState(() {
                    // You'll need to replace this with your own logic for
                    // generating tag suggestions based on the user's input.
                    _suggestedTags = _initSuggestTags.where((tag) {
                      return tag.name
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _controller.clear();
                      var result = _initSuggestTags.where((tag) {
                        return tag.name
                            .toLowerCase()
                            .contains(value.toLowerCase());
                      });
                      if (result.toList().isNotEmpty) {
                        _selectedTags.add(result.first);
                      } else {
                        // _selectedTags.add(ProblemModel(id: value));
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
