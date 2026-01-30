/// flutter selection_model

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';



class SelectionModal extends StatefulWidget {
  @override
  _SelectionModalState createState() => _SelectionModalState();

  final List dataSource;
  final List values;
  final bool filterable;
  final String textField;
  final String valueField;
  final String title;
  final int? maxLength;
  final String? maxLengthText;
  final Color? buttonBarColor;
  final String? cancelButtonText;
  final IconData? cancelButtonIcon;
  final Color? cancelButtonColor;
  final Color? cancelButtonTextColor;
  final String? saveButtonText;
  final IconData? saveButtonIcon;
  final Color? saveButtonColor;
  final Color? saveButtonTextColor;
  final String? clearButtonText;
  final IconData? clearButtonIcon;
  final Color? clearButtonColor;
  final Color? clearButtonTextColor;
  final String? deleteButtonTooltipText;
  final IconData? deleteIcon;
  final Color? deleteIconColor;
  final Color? selectedOptionsBoxColor;
  final String? selectedOptionsInfoText;
  final Color? selectedOptionsInfoTextColor;
  final IconData? checkedIcon;
  final IconData? uncheckedIcon;
  final Color? checkBoxColor;
  final Color? searchBoxColor;
  final String? searchBoxHintText;
  final Color? searchBoxFillColor;
  final Color? searchBoxTextColor;
  final IconData? searchBoxIcon;
  final String? searchBoxToolTipText;
  const SelectionModal(
      {this.filterable = true,
        this.dataSource = const [],
        this.title = 'Please select one or more option(s)',
        this.values = const [],
        this.textField = 'text',
        this.valueField = 'value',
        this.maxLength,
        this.maxLengthText,
        this.buttonBarColor,
        this.cancelButtonText,
        this.cancelButtonIcon,
        this.cancelButtonColor,
        this.cancelButtonTextColor,
        this.saveButtonText,
        this.saveButtonIcon,
        this.saveButtonColor,
        this.saveButtonTextColor,
        this.clearButtonText,
        this.clearButtonIcon,
        this.clearButtonColor,
        this.clearButtonTextColor,
        this.deleteButtonTooltipText,
        this.deleteIcon,
        this.deleteIconColor,
        this.selectedOptionsBoxColor,
        this.selectedOptionsInfoText,
        this.selectedOptionsInfoTextColor,
        this.checkedIcon,
        this.uncheckedIcon,
        this.checkBoxColor,
        this.searchBoxColor,
        this.searchBoxHintText,
        this.searchBoxFillColor,
        this.searchBoxTextColor,
        this.searchBoxIcon,
        this.searchBoxToolTipText})
      : super();
}

class _SelectionModalState extends State<SelectionModal> {
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  List _localDataSourceWithState = [];
  List _searchresult = [];

  _SelectionModalState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
        });
      } else {
        setState(() {
          _isSearching = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.dataSource.forEach((item) {
      var newItem = {
        'value': item[widget.valueField],
        'text': item[widget.textField],
        'checked': widget.values.contains(item[widget.valueField])
      };
      _localDataSourceWithState.add(newItem);
    });

    _searchresult = List.from(_localDataSourceWithState);
    _isSearching = false;
  }

  // PreferredSizeWidget _buildAppBar(BuildContext context) {
  //   return AppBar(
  //     leading: Container(),
  //     elevation: 0.0,
  //     title: Center(child: Text(widget.title, style: TextStyle(fontSize: 25,color:Colors.green ))),
  //     actions: <Widget>[
  //       IconButton(
  //         icon: Icon(
  //           Icons.close,
  //           size: 26.0,
  //         ),
  //         onPressed: () {
  //           Navigator.pop(context, null);
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: widget.buttonBarColor ?? Colors.grey.shade600,
          child:
          ButtonBar(alignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: <Widget>[
            ButtonTheme(
              height: 50.0,
              child: ElevatedButton.icon(
                label: Text(widget.cancelButtonText ?? 'Cancel'),
                icon: Icon(
                  widget.cancelButtonIcon ?? Icons.clear,
                  size: 10.0,
                ),
                style: ElevatedButton.styleFrom(
                    foregroundColor: widget.cancelButtonTextColor ?? Colors.black87, backgroundColor: widget.cancelButtonColor ?? Colors.grey.shade100),
                onPressed: () {
                  Navigator.pop(context, null);
                },
              ),
            ),
            // ButtonTheme(
            //    height: 50.0,
            //    child: ElevatedButton.icon(
            //      label: Text(widget.clearButtonText ?? 'Clear All'),
            //      icon: Icon(
            //        widget.clearButtonIcon ?? Icons.clear_all,
            //        size: 20.0,
            //      ),
            //      style: ElevatedButton.styleFrom(
            //          primary: widget.clearButtonColor ?? Colors.black,
            //          onPrimary: widget.clearButtonTextColor ?? Colors.white),
            //      onPressed: () {
            //
            //      },
            //    ),
            //  ),
            ButtonTheme(
              height: 50.0,
              child: ElevatedButton.icon(
                label: Text(widget.saveButtonText ?? 'Save'),
                icon: Icon(
                  widget.saveButtonIcon ?? Icons.save,
                  size: 10.0,
                ),
                style: ElevatedButton.styleFrom(
                    foregroundColor: widget.saveButtonTextColor ?? Theme.of(context).colorScheme.onPrimary, backgroundColor: widget.saveButtonColor ?? Theme.of(context).colorScheme.primary),
                onPressed:
                _localDataSourceWithState.where((item) => item['checked']).length <= (widget.maxLength ?? -1)
                    ? () {
                  var selectedValuesObjectList =
                  _localDataSourceWithState.where((item) => item['checked']).toList();
                  var selectedValues = [];
                  selectedValuesObjectList.forEach((item) {
                    selectedValues.add(item['value']);
                  });
                  Navigator.pop(context, selectedValues);
                }
                    : null,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 5,),
        widget.filterable ? _buildSearchText() : const SizedBox(),
        Expanded(
          child: _optionsList(context),
        ),
        // _currentlySelectedOptions(),

      ],
    );
  }


  ListView _optionsList(context) {
    List<Widget> options = [];
    _searchresult.forEach((item) {
      options.add(ListTile(
          selected: true,
          title: Text(item['text'] ?? '',style: TextStyle(color:Theme.of(context).primaryColorLight,fontSize: 14.0,fontWeight: FontWeight.w600,fontFamily: "Almarai-Regular"),),
          leading: Transform.scale(
            scale: 1.5,
            child:(item['text']=="All"||item['text']=="الكل")?Icon(Icons.select_all,color:Theme.of(context).primaryColor): Icon(
                item['checked']
                    ? widget.checkedIcon ?? Icons.check_box
                    : widget.uncheckedIcon ?? Icons.check_box_outline_blank,
                color: widget.checkBoxColor ?? Theme.of(context).primaryColor),
          ),
          onTap: () {
            if (item['text']=="All"||item['text']=="الكل"){
              //item['checked']=true;
              _addSelection();
              item['checked'] = !item['checked'];
            }
            else{
              //item['checked']=false;
              item['checked'] = !item['checked'];
            }
            setState(() {});
          }));
      options.add(const Divider(height: 1.0));
    });
    return ListView(children: options);
  }

  Widget _buildSearchText() {
    var textStyle = Theme.of(context).textTheme.titleMedium;
    return Container(
      color: widget.searchBoxColor ?? Theme.of(context).primaryColor,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _controller,
            keyboardAppearance: Brightness.light,
            onChanged: searchOperation,
            style: textStyle,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 12, right: 12),
              border:InputBorder.none,
              filled: true,
              hintText: widget.searchBoxHintText ?? "Search...",
              hintStyle: textStyle,
              fillColor: widget.searchBoxFillColor ?? Colors.white,
              suffix: Container(
                padding: const EdgeInsets.only(top: 8),
                height: 32,
                child: IconButton(
                  iconSize: 24,
                  icon: Icon(widget.searchBoxIcon ?? Icons.clear, color: Theme.of(context).canvasColor),
                  onPressed: () {
                    _controller.clear();
                    searchOperation('');
                  },
                  padding: const EdgeInsets.all(0.0),
                  tooltip: widget.searchBoxToolTipText ?? 'Clear',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      //key: globalKey,
      //appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }


  void _addSelection() {
    _localDataSourceWithState = _localDataSourceWithState.map((item) {
      item['checked'] = true;
      return item;
    }).toList();
    setState(() {});
  }

  void searchOperation(String searchText) {
    _searchresult.clear();
    if (_isSearching && searchText.toString().trim() != '') {
      for (int i = 0; i < _localDataSourceWithState.length; i++) {
        String data = '${_localDataSourceWithState[i]['value']} ${_localDataSourceWithState[i]['text']}';
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          _searchresult.add(_localDataSourceWithState[i]);
        }
      }
    } else {
      _searchresult = List.from(_localDataSourceWithState);
    }
  }
}
///Flutter multiselect

class MultiSelect extends FormField<dynamic> {
  final String titleText;
  final String? hintText;
  final bool required;
  final String? errorText;
  final dynamic value;
  final bool filterable;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function? change;
  final Function? open;
  final Function? close;
  final Widget? leading;
  final Widget? trailing;
  final int? maxLength;
  final Color? inputBoxFillColor;
  final Color? errorBorderColor;
  final Color? enabledBorderColor;
  final String? maxLengthText;
  final Color? maxLengthIndicatorColor;
  final Color? titleTextColor;
  final Widget selectIcon;
  final Color? selectIconColor;
  final Color? hintTextColor;

  // modal overrides
  final Color? buttonBarColor;
  final String? cancelButtonText;
  final IconData? cancelButtonIcon;
  final Color? cancelButtonColor;
  final Color? cancelButtonTextColor;
  final String? saveButtonText;
  final IconData? saveButtonIcon;
  final Color? saveButtonColor;
  final Color? saveButtonTextColor;
  final String? clearButtonText;
  final IconData? clearButtonIcon;
  final Color? clearButtonColor;
  final Color? clearButtonTextColor;
  final String? deleteButtonTooltipText;
  final IconData? deleteIcon;
  final Color? deleteIconColor;
  final Color? selectedOptionsBoxColor;
  final String? selectedOptionsInfoText;
  final Color? selectedOptionsInfoTextColor;
  final IconData? checkedIcon;
  final IconData? uncheckedIcon;
  final Color? checkBoxColor;
  final Color? searchBoxColor;
  final String? searchBoxHintText;
  final Color? searchBoxFillColor;
  final IconData? searchBoxIcon;
  final String? searchBoxToolTipText;
  final Size? responsiveDialogSize;

  MultiSelect({
    FormFieldSetter<dynamic>? onSaved,
    FormFieldValidator<dynamic>? validator,
    dynamic initialValue,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    this.titleText = 'Title',
    this.titleTextColor,
    this.hintText = 'Tap to select one or more...',
    this.hintTextColor = Colors.grey,
    this.required = false,
    this.errorText = 'Please select one or more option(s)',
    this.value,
    this.leading,
    this.filterable = true,
    required this.dataSource,
    this.textField = 'text',
    this.valueField = 'value',
    this.change,
    this.open,
    this.close,
    this.trailing,
    this.maxLength,
    this.maxLengthText,
    this.maxLengthIndicatorColor = Colors.red,
    this.inputBoxFillColor = Colors.white,
    this.errorBorderColor = Colors.red,
    this.enabledBorderColor = Colors.grey,
    required this.selectIcon,
    this.selectIconColor,
    this.buttonBarColor,
    this.cancelButtonText,
    this.cancelButtonIcon,
    this.cancelButtonColor,
    this.cancelButtonTextColor,
    this.saveButtonText,
    this.saveButtonIcon,
    this.saveButtonColor,
    this.saveButtonTextColor,
    this.clearButtonText,
    this.clearButtonIcon,
    this.clearButtonColor,
    this.clearButtonTextColor,
    this.deleteButtonTooltipText,
    this.deleteIcon,
    this.deleteIconColor,
    this.selectedOptionsBoxColor,
    this.selectedOptionsInfoText,
    this.selectedOptionsInfoTextColor,
    this.checkedIcon,
    this.uncheckedIcon,
    this.checkBoxColor,
    this.searchBoxColor,
    this.searchBoxHintText,
    this.searchBoxFillColor,
    this.searchBoxIcon,
    this.searchBoxToolTipText,
    this.responsiveDialogSize,
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<dynamic> state) {

        List<Widget> _buildSelectedOptions(dynamic values, state) {
          List<Widget> selectedOptions = [];
          if (values != null) {
            values.forEach((item) {
              final notFound = Map<String, dynamic>();
              var existingItem = dataSource.singleWhere((
                  itm) => itm[valueField] == item, orElse: () => notFound);
              if (existingItem != notFound) {
                selectedOptions.add(
                    Chip(
                      backgroundColor:Theme.of(state.context).colorScheme.background ,
                      label: Text(
                        existingItem[textField], overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14,
                            fontFamily: "Almarai-Regular",
                            fontWeight: FontWeight.w600,
                            color: Theme.of(state.context).colorScheme.onSecondary),),
                    ));
              }
            });
          }

          return selectedOptions;
        }

        return InkWell(
            onTap: () async {
              // bool isDlg = false;
              // if (responsiveDialogSize != null) {
              //   var m = MediaQuery.of(state.context);
              //   if (m.size.width - 100 > responsiveDialogSize.width &&
              //       m.size.height - 100 > responsiveDialogSize.height) {
              //     isDlg = true;
              //   }
              // }
              var results = await showModalBottomSheet(
                clipBehavior: Clip.hardEdge,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12))),
                context: state.context,
                builder: (context) {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(state.context),
                      ),
                      DraggableScrollableSheet(
                          initialChildSize: 0.6,
                          builder: (BuildContext context,
                              ScrollController controller) {
                            return Container(
                              decoration: ShapeDecoration(
                                color: Theme.of(state.context).canvasColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                              ),
                              child: SelectionModal(
                                  title: titleText,
                                  filterable: filterable,
                                  valueField: valueField,
                                  textField: textField,
                                  dataSource: dataSource,
                                  values: state.value ?? [],
                                  maxLength: maxLength,
                                  maxLengthText: maxLengthText,
                                  buttonBarColor: buttonBarColor,
                                  cancelButtonText: cancelButtonText,
                                  cancelButtonIcon: cancelButtonIcon,
                                  cancelButtonColor: cancelButtonColor,
                                  cancelButtonTextColor: cancelButtonTextColor,
                                  saveButtonText: saveButtonText,
                                  saveButtonIcon: saveButtonIcon,
                                  saveButtonColor: saveButtonColor,
                                  saveButtonTextColor: saveButtonTextColor,
                                  clearButtonText: clearButtonText,
                                  clearButtonIcon: clearButtonIcon,
                                  clearButtonColor: clearButtonColor,
                                  clearButtonTextColor: clearButtonTextColor,
                                  deleteButtonTooltipText: deleteButtonTooltipText,
                                  deleteIcon: deleteIcon,
                                  deleteIconColor: deleteIconColor,
                                  selectedOptionsBoxColor: selectedOptionsBoxColor,
                                  selectedOptionsInfoText: selectedOptionsInfoText,
                                  selectedOptionsInfoTextColor: selectedOptionsInfoTextColor,
                                  checkedIcon: checkedIcon,
                                  uncheckedIcon: uncheckedIcon,
                                  checkBoxColor: checkBoxColor,
                                  searchBoxColor: searchBoxColor,
                                  searchBoxHintText: searchBoxHintText,
                                  searchBoxFillColor: searchBoxFillColor,
                                  searchBoxIcon: searchBoxIcon,
                                  searchBoxToolTipText: searchBoxToolTipText),
                            );
                          }
                      ),
                    ],
                  );
                },
              );
              // await Navigator.push(
              //     state.context,
              //     _CustomMaterialPageRoute<dynamic>(
              //       isOpaque: false,
              //       builder: (BuildContext context) {
              //         return _wrapAsDialog(
              //           isDlg,
              //           context,
              //           dialogSize: responsiveDialogSize,
              //           child: SelectionModal(
              //               title: titleText,
              //               filterable: filterable,
              //               valueField: valueField,
              //               textField: textField,
              //               dataSource: dataSource,
              //               values: state.value ?? [],
              //               maxLength: maxLength,
              //               maxLengthText: maxLengthText,
              //               buttonBarColor: buttonBarColor,
              //               cancelButtonText: cancelButtonText,
              //               cancelButtonIcon: cancelButtonIcon,
              //               cancelButtonColor: cancelButtonColor,
              //               cancelButtonTextColor: cancelButtonTextColor,
              //               saveButtonText: saveButtonText,
              //               saveButtonIcon: saveButtonIcon,
              //               saveButtonColor: saveButtonColor,
              //               saveButtonTextColor: saveButtonTextColor,
              //               clearButtonText: clearButtonText,
              //               clearButtonIcon: clearButtonIcon,
              //               clearButtonColor: clearButtonColor,
              //               clearButtonTextColor: clearButtonTextColor,
              //               deleteButtonTooltipText: deleteButtonTooltipText,
              //               deleteIcon: deleteIcon,
              //               deleteIconColor: deleteIconColor,
              //               selectedOptionsBoxColor: selectedOptionsBoxColor,
              //               selectedOptionsInfoText: selectedOptionsInfoText,
              //               selectedOptionsInfoTextColor: selectedOptionsInfoTextColor,
              //               checkedIcon: checkedIcon,
              //               uncheckedIcon: uncheckedIcon,
              //               checkBoxColor: checkBoxColor,
              //               searchBoxColor: searchBoxColor,
              //               searchBoxHintText: searchBoxHintText,
              //               searchBoxFillColor: searchBoxFillColor,
              //               searchBoxIcon: searchBoxIcon,
              //               searchBoxToolTipText: searchBoxToolTipText),
              //         );
              //       },
              //       fullscreenDialog: !isDlg,
              //     ));

              if (results != null) {
                dynamic newValue;
                if (results.length > 0) {
                  newValue = results;
                }
                state.didChange(newValue);
                if (onSaved != null) {
                  onSaved(newValue);
                }
                if (change != null) {
                  change(newValue);
                }
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: inputBoxFillColor,
                contentPadding: const EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: kIsWeb ? 20 : 0),
                errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                        color: errorBorderColor ?? Colors.red)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(
                        color: enabledBorderColor ??
                            Theme
                                .of(state.context)
                                .inputDecorationTheme
                                .enabledBorder
                                ?.borderSide
                                .color ??
                            Colors.grey)),
                errorText: state.hasError ? state.errorText : null,
                errorMaxLines: 50,
              ),

              isEmpty:
              (state.value == null || state.value == '' ||
                  (state.value != null && state.value.length == 0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                text: titleText,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Almarai-Regular',
                                    color: titleTextColor ?? Theme
                                        .of(state.context)
                                        .primaryColor),
                                children: [
                                  TextSpan(
                                    text: required ? ' *' : '',
                                    style: TextStyle(
                                        color: maxLengthIndicatorColor,
                                        fontSize: 16.0),
                                  ),
                                  TextSpan(
                                    text: maxLength != null ? '' : '',
                                    style: TextStyle(
                                        color: maxLengthIndicatorColor,
                                        fontSize: 13.0),
                                  )
                                ]),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            selectIcon,
                            // Icon(
                            //   selectIcon,
                            //   color: selectIconColor ?? Theme.of(state.context).primaryColor,
                            //   size: 30.0,
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                  (state.value == null || state.value == '' ||
                      (state.value != null && state.value.length == 0))
                      ? Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 6.0),
                    child: Text(
                      hintText ?? '',
                      style: TextStyle(
                        color: hintTextColor,
                      ),
                    ),
                  )
                      : Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 1.0, // gap between lines
                    children: _buildSelectedOptions(state.value, state),
                  )
                ],
              ),
            ));
      });


}

// ignore: unused_element
class _CustomMaterialPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  final bool isOpaque;

  _CustomMaterialPageRoute({required this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
    this.isOpaque = true})
      : super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  final bool maintainState;

  @override
  bool get opaque => isOpaque;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}



class MultiSelectDropDown extends StatelessWidget {
  final dynamic initialValue;
  final String titleText;
  final String hintText;
  final String saveButtonText;
  final String cancelButtonText;
  final int maxLength;
  final List dataSource;
  final FormFieldSetter<dynamic> onSaved;
  final String textField;
  final String valueField;
  const MultiSelectDropDown({
    required this.initialValue,
    required this.titleText,
    required this.hintText,
    required this.cancelButtonText,
    required this.saveButtonText,
    required this.maxLength,
    required this.dataSource,
    required this.onSaved,
    required this.textField,
    required this.valueField,
    super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSelect(
      inputBoxFillColor:Theme.of(context).cardColor,
      searchBoxColor: Theme.of(context).cardColor,
      searchBoxFillColor:Theme.of(context).cardColor,
      buttonBarColor:Theme.of(context).cardColor,
      searchBoxHintText:"${AppLocalizations.of(context)!.trans(StringConsts.Search)}",
      change: (value){
      },
      initialValue: initialValue,
      titleText: titleText,
      enabledBorderColor: ColorConsts.whiteColor2,
      checkBoxColor: ColorConsts.gunmetalBlue,
      hintTextColor: ColorConsts.brownishGrey,
      hintText: hintText,
      saveButtonText: saveButtonText,
      cancelButtonText: cancelButtonText,
      maxLength: maxLength,
      errorBorderColor: ColorConsts.whiteColor,
      errorText: 'Please select one or more option(s)',
      dataSource:dataSource,
      textField: textField,
      selectIconColor: ColorConsts.gunmetalBlue,
      valueField: valueField,
      filterable: true,
      onSaved: onSaved,
      selectIcon: Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
            height: 17,
            child: SvgPicture.asset(
                ImageConsts.dropDownIcon)),
      ),
      saveButtonColor: Theme.of(context).primaryColor,
      clearButtonColor: ColorConsts.tomato,
    );
  }
}
