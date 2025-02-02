import '../controllers/covid_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});
  @override
  State createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CovidStatusProvider>(
      create: (context) => CovidStatusProvider(),
      child: Consumer<CovidStatusProvider>(
        builder: (context, covidProvider, child) {
          return MainScreen(provider: covidProvider);
        }
      )
    );
  }
}

class MainScreen extends StatefulWidget {
  final CovidStatusProvider provider;
  const MainScreen({super.key, required this.provider});
  @override
  State createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {

  var subHeaderLeftMargin = 0.0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.provider.loadFAQData();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subHeaderLeftMargin = MediaQuery.of(context).size.width * 0.035;
  }

  _scrollListener(){
    if (_scrollController.offset > _scrollController.position.viewportDimension) {
      if(!widget.provider.faqFABVisible) widget.provider.fabVisibility();
    } else if(widget.provider.faqFABVisible){
      widget.provider.fabVisibility();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.provider.faqFABVisible
        ? FloatingActionButton.extended(
            backgroundColor: const Color(0xFF0B3054),
            onPressed: () => _scrollController.animateTo(0.0, duration: const Duration(seconds: 1), curve: Curves.bounceInOut),
            icon: const Icon(Icons.arrow_upward_sharp,size: 22),
            label: const Text('TOP'),
            isExtended: false,
          )
        : null,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers:[
          const SliverAppBar(
            backgroundColor: Color(0xFF0B3054),
            centerTitle: true,
            floating: true,
            title: Text('FAQs',style: TextStyle(color: Colors.white)),
            expandedHeight: kToolbarHeight,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              widget.provider.loadFAQ
              ? loadingDialog()
              : faqWidget()
            ])
          )
        ]
      )
    );
  }

  Widget loadingDialog(){
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - (kToolbarHeight + kBottomNavigationBarHeight),
      child: const Center(
        child: Text('Loading...',style: TextStyle(fontSize: 12))
      ),
    );
  }

  Widget faqWidget(){
    var response = widget.provider.faqResponse;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: response.length,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.zero,
      itemBuilder: (context,index){
        return Container(
          margin: const EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 0.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0XFFBDBDBD),
                blurRadius: 1.0
              )
            ]
          ),
          child: ExpansionTile(
            title: Text(response[index].question,style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.normal)),
            subtitle: Text(response[index].tag,style: TextStyle(fontSize: 11,fontStyle: FontStyle.italic,color: response[index].tag == 'corona' ? Colors.red : Colors.green)),
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(subHeaderLeftMargin, 0, 10, 10),
                child: Text(response[index].answer,style: const TextStyle(fontSize: 11))
              )
            ]
          )
        );
      }
    );
  }
}
