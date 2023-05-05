import 'package:empire_expert/screens/service_details.dart';
import 'package:empire_expert/widgets/loading.dart';
import 'package:empire_expert/widgets/service_card.dart';
import 'package:empire_expert/common/colors.dart';
import 'package:empire_expert/models/response/item.dart';
import 'package:empire_expert/services/item_service/item_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  final String? searchString;

  const SearchPage({super.key, this.searchString});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ItemResponseModel>? _listItem;
  List<ItemResponseModel>? _filteredItem;
  bool _loading = true;
  late String _searchString = "";
  FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [
    // "Thay nhớt",
    // "Thay hộp số",
    // "Thay lốp",
    // "Thay gương"
  ];

  @override
  void initState() {
    if (widget.searchString != null) {
      _searchController.text = widget.searchString.toString();
      _recentSearches.add(widget.searchString.toString());
    }
    _fetchData();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  removeRecentSearch() {
    setState(() {
      _recentSearches = [];
    });
  }

  _fetchData() async {
    _listItem = await ItemService().fetchListItem();
    setState(() {
      _loading = false;
    });
    if (widget.searchString != null) {
      _searchString = widget.searchString.toString();
      _fitlterData(_searchString);
      if (widget.searchString!.isEmpty) {
        _filteredItem = _listItem;
      }
    } else {
      _filteredItem = _listItem;
    }
  }

  _fitlterData(seachString) {
    if (!_loading) {
      _filteredItem = _listItem!
          .where((element) =>
              element.name.toLowerCase().contains(seachString.toLowerCase()) ||
              (element.category != null &&
                  element.category!.name
                      .toLowerCase()
                      .contains(seachString.toLowerCase())))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: AppColors.searchBarColor,
                width: 1.0,
              ),
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.blackTextColor,
                )),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Tìm kiếm',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 335.w,
              height: 45.h,
              child: TextField(
                focusNode: FocusNode(canRequestFocus: true),
                onSubmitted: (value) => {
                  _fitlterData(value),
                  setState(() {
                    if (value.replaceAll(" ", "").isNotEmpty) {
                      _recentSearches.add(value);
                    }
                  }),
                  _searchString = value,
                },
                controller: _searchController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.blueTextColor, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.grey400),
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  focusColor: AppColors.searchBarColor,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      color: AppColors.blueTextColor,
                      size: 30,
                    ),
                  ),
                  hintText: 'Tìm kiếm...',
                ),
              ),
            ),
            _searchString.isEmpty
                ? Expanded(
                    child: _loading
                        ? const Loading()
                        : Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: ListTile(
                                    title: const Text(
                                      'Tìm kiếm gần đây',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: _recentSearches.isNotEmpty
                                        ? InkWell(
                                            onTap: () => {removeRecentSearch()},
                                            child: const Text(
                                              "Xóa tất cả",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children:
                                      _recentSearches.reversed.map((search) {
                                    return ListTile(
                                      title: Text(
                                        search,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      leading: search.isNotEmpty
                                          ? const Icon(Icons.timer_outlined)
                                          : null,
                                      horizontalTitleGap: 0,
                                      onTap: () {
                                        _searchController.text = search;
                                        setState(() {
                                          _searchString = search;
                                        });
                                        _fitlterData(search);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                  )
                : Expanded(
                    child: Column(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ListTile(
                            title: RichText(
                              text: TextSpan(
                                  text: 'Kết quả cho "',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: _searchString,
                                        style: const TextStyle(
                                          color: AppColors.blueTextColor,
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: '"',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ])
                                  ]),
                            ),
                            trailing: Text(
                              _filteredItem != null
                                  ? "${_filteredItem!.length} tìm kiếm"
                                  : "0 tìm kiếm",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blueTextColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _loading
                            ? const Loading()
                            : _filteredItem!.isEmpty
                                ? ListView(children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/image/error-image/not-founded.png",
                                          ),
                                          ListTile(
                                            title: Padding(
                                              padding: EdgeInsets.all(30.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'Không tìm thấy',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily:
                                                          'Roboto',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            subtitle: const Text(
                                                'Rất tiếc từ khóa bạn nhập không tìm thấy, vui lòng kiểm tra lại hoặc tìm với từ khóa khác.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ]),
                                  ])
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: _filteredItem!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServiceDetails(
                                                        itemId: _filteredItem![
                                                                index]
                                                            .id,
                                                      )),
                                            ),
                                            child: SerivceCard(
                                                backgroundImage:
                                                    _filteredItem![index].photo,
                                                title:
                                                    _filteredItem![index].name,
                                                price: _filteredItem![index]
                                                        .prices!
                                                        .isNotEmpty
                                                    ? _filteredItem![index]
                                                        .prices!
                                                        .first
                                                        .price
                                                        .toString()
                                                    : "Liên hệ",
                                                usageCount: "182",
                                                rating: "4.4",
                                                tag: _filteredItem![index]
                                                            .category !=
                                                        null
                                                    ? _filteredItem![index]
                                                        .category!
                                                        .name
                                                    : "Dịch vụ"),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          )
                                        ],
                                      );
                                    }),
                      ),
                    ]),
                  )
          ],
        ),
      ),
    );
  }
}
