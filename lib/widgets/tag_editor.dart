import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/common/style.dart';
import 'package:empire_expert/models/response/orderservices.dart'
    as order_service;
import 'package:empire_expert/models/response/problem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TagEditor extends StatefulWidget {
  final List<ProblemModel> tags;
  final void Function(List<ProblemModel>) onChanged;
  final order_service.Car car;
  final List<order_service.Symptom> symptoms;
  final List<ProblemModel> initSuggestTags;

  const TagEditor(
      {super.key,
      required this.tags,
      required this.onChanged,
      required this.car,
      required this.initSuggestTags,
      required this.symptoms});

  @override
  _TagEditorState createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  List<ProblemModel> _selectedTags = [];
  List<ProblemModel> _suggestedTags = [];
  final FocusNode _diagnoseFocusNode = FocusNode();
  Color _suffixIconColor = Colors.grey.shade500;
  IconData _suffixIconData = Icons.keyboard_arrow_down;
  bool _isInit = true;
  final TextEditingController _textController = TextEditingController();
  final List<MultiSelectCard<int>> _listCard = [];

  _hasThisSymptom(int symptomId) {
    if (widget.symptoms.any((element) => element.id == symptomId)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _selectedTags = widget.tags;
    _suggestedTags = widget.initSuggestTags;
    for (var element in widget.symptoms) {
      _listCard.add(MultiSelectCard(value: element.id, label: element.name));
    }
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

  _getSuggestions(pattern) {
    if (_isInit == true) {
      return _suggestedTags.where((element) =>
          _hasThisSymptom(element.symptom != null ? element.symptom!.id : 0) &&
          element.name.toLowerCase().contains(pattern.toLowerCase()));
    }
    return _suggestedTags.where((element) =>
        element.name.toLowerCase().contains(pattern.toLowerCase()));
  }

  @override
  void dispose() {
    _diagnoseFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MultiSelectContainer(
              itemsDecoration: MultiSelectDecorations(
                  selectedDecoration: BoxDecoration(
                      color: AppColors.blue600,
                      borderRadius: BorderRadius.circular(16))),
              items: _listCard,
              onChange: (allSelectedItems, selectedItem) {
                if (_diagnoseFocusNode.hasFocus) {
                  _diagnoseFocusNode.unfocus();
                }
                setState(() {
                  if (allSelectedItems.isEmpty) {
                    _suggestedTags = widget.initSuggestTags;
                  } else {
                    _suggestedTags = widget.initSuggestTags
                        .where((element) =>
                            allSelectedItems.contains(element.symptom!.id))
                        .toList();
                  }
                });
              },
            ),
            SizedBox(
              height: 10.sp,
            ),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textController,
                focusNode: _diagnoseFocusNode,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _isInit = false;
                  });
                },
                decoration: AppStyles.textbox12(
                  hintText: "Chọn kết quả chẩn đoán",
                  suffixIcon: Icon(
                    _suffixIconData,
                    color: _suffixIconColor,
                  ),
                ),
                onTapOutside: (event) {
                  if (_diagnoseFocusNode.hasFocus) {
                    _diagnoseFocusNode.unfocus();
                  }
                },
              ),
              suggestionsCallback: (pattern) {
                // Implement your logic to fetch suggestions based on the input pattern
                // and return a list of suggestions.
                // You can make API calls or use local data for suggestions.
                return _getSuggestions(pattern);
              },
              onSuggestionSelected: (suggestion) {
                // Implement the logic when a suggestion is selected.
                // You can update the state or perform any other action.
                setState(() {
                  _textController.text = "";
                  _suggestedTags.remove(suggestion);
                  _selectedTags.add(suggestion as ProblemModel);
                  widget.onChanged(_selectedTags);
                });
              },
              noItemsFoundBuilder: (context) {
                return ListTile(title: Text('Không tìm thấy từ khóa', style: AppStyles.header600(fontsize: 12.sp, color: Colors.grey.shade400),));
              },
              errorBuilder: (context, error) {
                return ListTile(title: Text('Xảy ra lỗi', style: AppStyles.header600(fontsize: 12.sp, color: Colors.grey.shade400),));
              },
              itemBuilder: (context, suggestion) {
                // Customize how each suggestion is rendered.
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text((suggestion as ProblemModel).name,
                              style: AppStyles.text400(fontsize: 12.sp)),
                        ),
                        Visibility(
                          visible: suggestion.symptom != null &&
                              _hasThisSymptom(suggestion.symptom!.id),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Visibility(
                                    visible: suggestion.symptom != null &&
                                        suggestion.symptom!.name != null,
                                    child: Text(
                                      suggestion.symptom!.name!,
                                      style: AppStyles.text400(
                                          fontsize: 10.sp,
                                          color: Colors.grey.shade500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.lightbulb,
                                color: Colors.yellow.shade500,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = _selectedTags.removeAt(oldIndex);
                    _selectedTags.insert(newIndex, item);
                    widget.onChanged(_selectedTags);
                  });
                },
                children: _selectedTags.map((tag) {
                  return Container(
                    key: Key('${_selectedTags.indexOf(tag)}'),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tag.name.toString(),
                          style: AppStyles.text400(fontsize: 14.sp),
                        ),
                        Row(
                          children: [
                            Visibility(
                              visible: tag.symptom != null &&
                                  _hasThisSymptom(tag.symptom!.id),
                              child: Visibility(
                                visible: tag.symptom != null &&
                                    tag.symptom!.name != null,
                                child: Text(
                                  tag.symptom!.name!,
                                  style: AppStyles.text400(
                                      fontsize: 12.sp,
                                      color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTags.remove(tag);
                                  _suggestedTags.add(tag);
                                  _suggestedTags.sort((a, b) =>
                                      _hasThisSymptom(b.symptom!.id) ? 1 : -1);
                                  widget.onChanged(_selectedTags);
                                });
                              },
                              child: const Icon(
                                Icons.cancel,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
