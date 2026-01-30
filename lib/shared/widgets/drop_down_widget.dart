import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import '../../../Core/styles/Colors.dart';
import '../../../Core/styles/GeneralConstants.dart';

/// Show multi-select bottom sheet with checkboxes (same design as DropDownBottomSheet)
Future<List<dynamic>?> showMultiSelectBottomSheet({
  required BuildContext context,
  required List<DropdownMenuItem<dynamic>> items,
  required List<int> selectedIds,
  required String Function(dynamic) text,
  required bool Function(dynamic value, dynamic) searchFunction,
  required String title,
}) {
  return showModalBottomSheet<List<dynamic>>(
    context: context,
    clipBehavior: Clip.hardEdge,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _MultiSelectBottomSheetContent(
          items: items,
          selectedIds: selectedIds,
          text: text,
          searchFunction: searchFunction,
          title: title,
        ),
      );
    },
  );
}

class _MultiSelectBottomSheetContent extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final List<int> selectedIds;
  final String Function(dynamic) text;
  final bool Function(dynamic value, dynamic) searchFunction;
  final String title;

  const _MultiSelectBottomSheetContent({
    required this.items,
    required this.selectedIds,
    required this.text,
    required this.searchFunction,
    required this.title,
  });

  @override
  State<_MultiSelectBottomSheetContent> createState() => _MultiSelectBottomSheetContentState();
}

class _MultiSelectBottomSheetContentState extends State<_MultiSelectBottomSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late Set<int> _selectedIds;
  late List<DropdownMenuItem<dynamic>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<int>.from(widget.selectedIds);
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterItems() {
    final value = _searchController.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        _filteredItems = widget.items.where((item) {
          return widget.searchFunction(item.value, value);
        }).toList();
      });
    } else {
      setState(() {
        _filteredItems = widget.items;
      });
    }
  }

  void _toggleSelection(int itemId) {
    setState(() {
      if (_selectedIds.contains(itemId)) {
        _selectedIds.remove(itemId);
      } else {
        _selectedIds.add(itemId);
      }
    });
  }

  void _saveSelection() {
    // Get selected values from all items (not just filtered)
    final selectedValues = widget.items
        .where((item) {
          final itemId = _getItemId(item.value);
          return itemId != null && _selectedIds.contains(itemId);
        })
        .map((item) => item.value)
        .toList();
    Navigator.pop(context, selectedValues);
  }

  int? _getItemId(dynamic value) {
    if (value == null) return null;
    
    // First, try to access 'value' property (for enums like WorkItemPriorityEnum, WorkItemStatusEnum)
    try {
      final dynamic valueProperty = (value as dynamic).value;
      if (valueProperty is int) return valueProperty;
      if (valueProperty != null) {
        final parsed = int.tryParse(valueProperty.toString());
        if (parsed != null) return parsed;
      }
    } catch (e) {
      // If accessing .value fails, continue to other methods
    }
    
    // Then try 'id' property (for objects like CustomListItem, EquipmentLookupItem, etc.)
    try {
      final dynamic idValue = (value as dynamic).id;
      if (idValue is int) return idValue;
      if (idValue != null) {
        final parsed = int.tryParse(idValue.toString());
        if (parsed != null) return parsed;
      }
    } catch (e) {
      // If accessing .id fails, continue to other methods
    }
    
    // If value is already an int, return it
    if (value is int) return value;
    
    // If value is a Map with 'id' key
    if (value is Map && value.containsKey('id')) {
      final id = value['id'];
      if (id is int) return id;
      if (id != null) {
        return int.tryParse(id.toString());
      }
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    // Calculate dynamic sizes based on keyboard presence
    final baseSize = 0.5;
    final minSize = 0.4;
    final maxSize = keyboardHeight > 0 ? 0.9 : 0.7;
    
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Unfocus search field when tapping outside
            _searchFocusNode.unfocus();
            Navigator.pop(context);
          },
        ),
        DraggableScrollableSheet(
          initialChildSize: baseSize,
          minChildSize: minSize,
          maxChildSize: maxSize,
          builder: (BuildContext context, ScrollController controller) {
            return Container(
              decoration: ShapeDecoration(
                color: Theme.of(context).cardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextFormField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintStyle: textFieldHintStyle,
                        hintText: AppLocalizations.of(context)?.trans(StringConsts.Search) ?? 'Search',
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => _filterItems(),
                      onTap: () {
                        // Ensure focus when tapping on search field
                        _searchFocusNode.requestFocus();
                      },
                    ),
                  ),
                  // Selected items count
                  if (_selectedIds.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          '${_selectedIds.length} selected',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorConsts.gunmetalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // List of items with checkboxes
                  Flexible(
                    child: Scrollbar(
                      controller: controller,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _filteredItems[index];
                          final itemId = _getItemId(item.value);
                          final isSelected = itemId != null && _selectedIds.contains(itemId);

                          return Column(
                            children: [
                              ListTile(
                                leading: Checkbox(
                                  value: isSelected,
                                  onChanged: itemId != null
                                      ? (_) => _toggleSelection(itemId)
                                      : null,
                                  activeColor: ColorConsts.gunmetalBlue,
                                ),
                                title: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    widget.text(item.value),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                onTap: itemId != null
                                    ? () => _toggleSelection(itemId)
                                    : null,
                              ),
                              index == _filteredItems.length - 1
                                  ? const SizedBox()
                                  : const Divider(height: 1.0),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  // Save and Cancel buttons at the bottom
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: ColorConsts.gunmetalBlue.withOpacity(0.5),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)?.trans(StringConsts.cancel) ?? 'Cancel',
                              style: TextStyle(
                                color: ColorConsts.gunmetalBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveSelection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConsts.gunmetalBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)?.trans(StringConsts.save) ?? 'Save',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

Future<DropdownMenuItem?> showDropDownBottomSheet(
    {required BuildContext context,
      required List<DropdownMenuItem<dynamic>> item,
      required String lang,
      required ValueChanged<dynamic> onTap,
      required String Function(dynamic) text,
      required bool Function(dynamic value, dynamic) searchFunction,
      bool? checkIsItemZero,
    }) {
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12))),
    builder: (BuildContext context) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      // Calculate dynamic sizes based on keyboard presence
      final baseSize = 0.6;
      final minSize = 0.5;
      final maxSize = keyboardHeight > 0 ? 0.95 : 0.9;
      
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
          ),
          DraggableScrollableSheet(
            initialChildSize: baseSize,
            minChildSize: minSize,
            maxChildSize: maxSize,
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).cardColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
                child: DropDownListWidget(
                  item,
                  lang,
                  text: text,
                  onTap: onTap,
                  checkIsItemZero: checkIsItemZero??false,
                  scrollController: controller,
                  searchBoxDecoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintStyle: textFieldHintStyle,
                      hintText:
                      AppLocalizations.of(context)?.trans(StringConsts.Search) ?? 'Search',
                      border: InputBorder.none),
                  searchFunction: searchFunction,
                ),
              );
            },
          ),
        ]),
      );
    },
  );
}

class DropDownListWidget extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final ValueChanged<dynamic> onTap;
  final ValueChanged<dynamic> text;
  final bool Function(dynamic, dynamic) searchFunction;
  final bool checkIsItemZero;

  const DropDownListWidget(
      this.countries,
      this.locale, {
        super.key,
        this.searchBoxDecoration,
        this.scrollController,
        this.autoFocus = false,
        required this.onTap,
        required this.text,
        required this.searchFunction,
        required this.checkIsItemZero,
      });

  @override
  _DropDownListWidgetState createState() => _DropDownListWidgetState();
}

class _DropDownListWidgetState extends State<DropDownListWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late List<DropdownMenuItem<dynamic>> filteredItem;

  @override
  void initState() {
    filteredItem = filterItem();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        const InputDecoration(labelText: 'Search by country name or dial code');
  }

  /// Filters the list of Country by text from the search box.
  List<DropdownMenuItem<dynamic>> filterItem() {
    final value = _searchController.text.trim();
    if (value.isNotEmpty) {
      return widget.countries.where((DropdownMenuItem<dynamic> country) {
        return widget.searchFunction(country.value, value);
      }).toList();
    }
    return widget.countries;
  }

  /// Returns the country name of a [Country]. if the locale is set and translation in available.
  /// returns the translated name.
  dynamic getItemName(DropdownMenuItem<dynamic> item) {
    if (widget.locale != null && item.value != null) {
      return widget.text(item.value);
    }
    return widget.text(item.value);
  }

  @override
  Widget build(BuildContext context) {
    const String countrySearchInputKeyValue = 'search_input_key';
    return widget.checkIsItemZero?const Center(
      child: Text(StringConsts.noInternetConnection),
    ):Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            key: const Key(countrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            focusNode: _searchFocusNode,
            // autofocus: widget.autoFocus,
            onChanged: (value) => setState(() => filteredItem = filterItem()),
            onTap: () {
              // Ensure the search field can receive focus
              _searchFocusNode.requestFocus();
            },
          ),
        ),
        Expanded(
          child: filteredItem.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)?.trans(StringConsts.noRecordsFound) ?? 'No records found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : Scrollbar(
                  thumbVisibility: true,
                  controller: widget.scrollController,
                  child: ListView.builder(
                    controller: widget.scrollController,
                    shrinkWrap: false,
                    itemCount: filteredItem.length,
                    itemBuilder: (BuildContext context, int index) {
                      DropdownMenuItem item = filteredItem[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text('${getItemName(item)}',
                                    textAlign: TextAlign.start
                                )),
                            onTap: () {
                              Navigator.of(context).pop(item);
                              widget.onTap(item.value);
                            },
                          ),
                          index == filteredItem.length - 1
                              ? const SizedBox()
                              : const Divider(
                            height: 1.0,
                          )
                        ],
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DropDownBottomSheet extends StatelessWidget {
  final dynamic value;
  final String? hint;
  final double? height;
  final bool isReadOnly;
  final String labelText;
  final TextStyle? hintStyle;
  final ScrollController? searchScroll;
  final String? errorText;
  final Color? iconColor;
  final bool? enableSearch;
  final List<DropdownMenuItem>? items;
  final ValueChanged<dynamic>? onChanged;
  final TextEditingController? searchController;
  final Widget? leading;
  final dynamic width;
  final bool? isLeading;
  final String lang;
  final BuildContext context;
  final List<DropdownMenuItem<dynamic>> item;
  final ValueChanged<dynamic> onTap;
  final  String Function(dynamic) text;
  final bool Function(dynamic value, dynamic) searchFunction;
  final bool? enableTap;
  final bool?checkIsItemZero;
  const DropDownBottomSheet(
      {Key? key,
        this.iconColor,
        this.isLeading = false,
        this.value,
        this.hint,
        this.hintStyle,
        this.items,
        this.leading,
        this.isReadOnly = false,
        this.onChanged,
        this.width,
        this.searchScroll,
        this.errorText,
        this.searchController,
        this.enableSearch = false,
        this.height,
        required this.labelText,
        required this.context,
        required this.item,
        required this.lang,
        required this.onTap,
        required this.text,
        required this.searchFunction,
        this.enableTap=false,
        this.checkIsItemZero
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:enableTap==true?(){}: ()async{
        showDropDownBottomSheet(
            context: context,
            item: item,
            lang: lang,
            onTap: onTap,
            text: text,
            searchFunction: searchFunction,
            checkIsItemZero: checkIsItemZero
        );
      },
      child: Container(
        height: 58,
        width: width,
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        decoration: const BoxDecoration(
          // color: Colors.white,
        ),
        child: Row(
          children: [
            Flexible(
              child: DropdownButtonFormField2<dynamic>(
                key:key,
                // dropdownMaxHeight: height ?? 300,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: isLeading == true
                      ? leading != null
                      ? IconButton(
                    icon: leading!,
                    onPressed: () {
                    },
                  )
                      : null
                      : null,
                  labelText: labelText,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                      //color: Colors.red,
                      color: ColorConsts.whiteColor2,
                      // width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: ColorConsts.whiteColor2,
                      // width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  contentPadding:const EdgeInsets.only(
                      right: 10, left: 10, bottom: 10, top: 10),
                  labelStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),

                ),
                // focusColor: Colors.white,
                style: Theme.of(context).textTheme.bodyLarge,
                hint: hint != null
                    ? Text(
                  hint!,
                  style: isReadOnly == true
                      ? Theme.of(context).textTheme.displayMedium
                      : (hintStyle ?? Theme.of(context).textTheme.bodyLarge),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
                    : null,
                items: const [],
                isExpanded: true,
                // searchMatchFn: searchFunction,
                // icon: isReadOnly == true
                //     ? SvgPicture.asset(ImageConsts.dropDownIcon,
                //     color: ColorConsts.grey)
                //     : SvgPicture.asset(ImageConsts.dropDownIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialCustomDropDown extends StatelessWidget {
  final dynamic value;
  final String? hint;
  final TextStyle? hintStyle;
  final String? errorText;
  final List<DropdownMenuItem>? items;
  final ValueChanged<dynamic>? onChanged;
  final Widget? leading;
  final dynamic width;
  final bool? isLeading;

  const SpecialCustomDropDown(
      {Key? key,
        this.isLeading = false,
        this.value,
        this.hint,
        this.hintStyle,
        this.items,
        this.leading,
        this.onChanged,
        this.width,
        this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: width,
      child: Row(
        children: [
          isLeading == true
              ? const SizedBox(
            width: 20,
          )
              : const SizedBox(),
          isLeading == true
              ? leading ?? SvgPicture.asset(ImageConsts.industry)
              : const SizedBox(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: DropdownButton<dynamic>(
                dropdownColor: Colors.white,
                // value: value,
                focusColor: Colors.white,
                style: Theme.of(context).textTheme.bodyLarge,
                // value: value,
                hint: Text(
                  hint!,
                  style: hintStyle!,
                  overflow: TextOverflow.ellipsis,
                ),
                items: const [],
                onChanged: (value) {},
                isExpanded: true,
                underline: const SizedBox(),
                icon: SvgPicture.asset(ImageConsts.dropDownIcon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

