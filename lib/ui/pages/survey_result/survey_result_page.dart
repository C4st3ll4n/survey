import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder:(contexto){
  
          presenter.isLoadingStream.listen(
                (isLoading) {
              if (isLoading == true) {
                showSimpleLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );
          
          presenter.loadData();
          
          
          return ListView.builder(
          itemCount: (4 + 1),
          itemBuilder: (contexto, indice) {
            if (indice == 0) {
              return Container(
                padding: EdgeInsets.only(top: 40, bottom: 20, right: 20, left: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withAlpha(90),
                ),
                  child: Text("Qual seu frame fav ?"));
            } else {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network("https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png",
                        width: 50,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Vue JS ?", style: TextStyle(fontSize: 16),),
                        )),
                        Text("100 %", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorDark),),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.check_circle, color: Theme.of(context).highlightColor,),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1,),
                ],
              );
            }
          },
        );
        },
      ),
    );
  }
}
