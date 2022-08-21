import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:local_notification/bloc/bloc.dart';
import 'package:local_notification/bloc/event.dart';
import 'package:local_notification/bloc/state.dart';
import 'package:local_notification/costants.dart';
import 'package:local_notification/response/typicode_response.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  JsonPlaceHolderBloc? jsonPlaceHolderBloc;
  List? typiCodeResponse;
  List filterList=[];
  late Box<String> cachedData;
  @override
  void initState() {
    cachedData=Hive.box<String>(HiveConstant.cached_json_response);
    if(cachedData.get(HiveConstant.cached_key)!=null){
      List res=jsonDecode(cachedData.get(HiveConstant.cached_key)!);
      typiCodeResponse=res.map((e) => TypiCodeResponse.fromJson(e)).toList();
      filterList.addAll(typiCodeResponse!);
    }
    jsonPlaceHolderBloc = BlocProvider.of<JsonPlaceHolderBloc>(context);
    jsonPlaceHolderBloc?.add(JsonPlaceHolderEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
          bloc: jsonPlaceHolderBloc,
          listener: (BuildContext context, state) {
            handleApiResponse(state);
          },
          child: BlocBuilder(
            bloc: jsonPlaceHolderBloc,
            builder: (BuildContext context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  searchField(onChangeText: (value){
                    updateList(value);
                  }),
                  filterList.isNotEmpty ? Expanded(
                    child: ListView.builder(
                      itemCount: filterList.isEmpty ? 0 : filterList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return listContent(filterList[index]);
                      }),
                  ) : Container(
                      margin: const EdgeInsets.only(top: 21),
                      child: const Text("Nothing Found!!",style: TextStyle(
                        fontSize: 24,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600
                      ),))
                ],
              ) ;
            },
          )),
    );
  }


  void updateList(String query) {
    setState(() {
      filterList.clear();
      if (query.isEmpty) {
        filterList.addAll(typiCodeResponse!.toList());
      } else {
        filterList.addAll(typiCodeResponse!.toList()
            .where((element) => element.username!
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList());
      }
    });
  }

  void handleApiResponse(Object? apiState){
    if(apiState is JsonPlaceHolderState){
      if(apiState.apiResponse!.isSuccess!){
        typiCodeResponse=apiState.apiResponse?.dataResponse;
        cachedData.put(HiveConstant.cached_key, jsonEncode(typiCodeResponse));
        typiCodeResponse=typiCodeResponse?.map((e) => TypiCodeResponse.fromJson(e)).toList();
        filterList.addAll(typiCodeResponse!);
      }
    }
  }

  Widget listContent(TypiCodeResponse typiCodeResponse){
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: const BorderRadius.all( Radius.circular(12))
      ),
      child: Column(
        children: [
          Text("${typiCodeResponse.username}"),
          Text("${typiCodeResponse.email}"),
          Text("${typiCodeResponse.name}"),
          Text("${typiCodeResponse.website}"),
        ],
      ),
    );
  }

  searchField({required Function(String) onChangeText}) {
    return Container(
      height: 24,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: TextField(
        onChanged: (value) {
          onChangeText(value);
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.search, size: 16, color: Colors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          focusedBorder:  const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.orange),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.grey[400]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.grey[300]!),
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                width: 1,
              )),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.black)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.yellowAccent)),
          labelText: "Search",
        ),
      ),
    );
  }

}
