import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/orderservices.dart' as order_service;
import 'package:empire_expert/models/response/problem.dart';
import 'package:empire_expert/services/diagnose_services/diagnose_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagEditor extends StatefulWidget {
  final List<ProblemModel> tags;
  final void Function(List<ProblemModel>) onChanged;
  final order_service.Car car;
  final List<order_service.Symptom>? symptoms;

  const TagEditor(
      {super.key,
      required this.tags,
      required this.onChanged,
      required this.car,
      this.symptoms
      });

  @override
  _TagEditorState createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  final TextEditingController _controller = TextEditingController();
  List<ProblemModel> _selectedTags = [];
  List<ProblemModel> _suggestedTags = [];
  late List<ProblemModel> _initSuggestTags;
  bool _loading = true;
  final FocusNode _diagnoseFocusNode = FocusNode();
  Color _suffixIconColor = Colors.grey.shade500;
  IconData _suffixIconData = Icons.keyboard_arrow_down;

  _fetchInitSuggestTag() async {
    var result = await DiagnoseService().getListProblem(widget.car);
    setState(() {
      result.sort((a, b) => _hasThisSymptom(b.symptom!.id) ? 1 : -1);
      _initSuggestTags = result;
      _suggestedTags = _initSuggestTags;
      _loading = false;
    });
    return result;
  }

  _hasThisSymptom(int symptomId) {
    if (widget.symptoms != null && widget.symptoms!.any((element) => element.id == symptomId)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _fetchInitSuggestTag();
    _selectedTags = widget.tags;
    super.initState();
    _diagnoseFocusNode.addListener(() {
      setState(() {
        _suffixIconColor = _diagnoseFocusNode.hasFocus
            ? AppColors.blue600
            : Colors.grey.shade500;
        _suffixIconData = _diagnoseFocusNode.hasFocus
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down;
      });
    });
  }

  @override
  void dispose() {
    _diagnoseFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_suggestedTags.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade500),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestedTags.length,
                      itemBuilder: (context, index) {
                        final tag = _suggestedTags[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.clear();
                              _selectedTags.add(tag);
                              widget.onChanged(_selectedTags);
                              _suggestedTags = [];
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    tag.name,
                                    style: AppStyles.text400(fontsize: 12.sp),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Visibility(
                                  visible: tag.symptom != null && _hasThisSymptom(tag.symptom!.id),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Visibility(
                                            visible: tag.symptom != null && tag.symptom!.name != null,
                                            child: Text(
                                               tag.symptom!.name!,
                                                style: AppStyles.text400(fontsize: 10.sp, color: Colors.grey.shade500),
                                                overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.lightbulb, color: Colors.yellow.shade500,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              TextFormField(
                focusNode: _diagnoseFocusNode,
                controller: _controller,
                decoration: AppStyles.textbox12(
                  hintText: "Chọn kết quả chẩn đoán",
                  suffixIcon: Icon(
                    _suffixIconData,
                    color: _suffixIconColor,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _suggestedTags = _initSuggestTags;
                  });
                },
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
                    });
                  }
                },
              ),
              SizedBox(
                height: 8.sp,
              ),
              Wrap(
                spacing: 8.sp,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(
                      tag.name,
                      style: AppStyles.text400(fontsize: 10.sp),
                    ),
                    onDeleted: () {
                      setState(() {
                        _selectedTags.remove(tag);
                        widget.onChanged(_selectedTags);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          );
  }
}
