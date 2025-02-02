import 'package:covin/model/response/vaccine_response.dart';
import 'package:flutter/material.dart';

class VaccinationDialog extends StatelessWidget {
  final VaccinationResponse response;
  const VaccinationDialog({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 0,
          left: 0,
          right: 0
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 12,bottom: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF0B3054),
              ),
              child: Text(
                response.country,
                style: const TextStyle(color: Colors.white,fontSize: 12,decoration: TextDecoration.none,fontWeight: FontWeight.bold,fontFamily: ''),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              color: const Color(0xFFE3F2FD),
              padding: const EdgeInsets.only(left: 5,right: 5,top: 6,bottom: 6),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Date',
                      style: TextStyle(fontFamily: '',color:Colors.black,decoration: TextDecoration.none,fontSize: 10,fontWeight: FontWeight.bold),
                    )
                  ),
                  Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(fontFamily: '',color:Colors.black,decoration: TextDecoration.none,fontSize: 10,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center
                    )
                  ),
                  Expanded(
                    child: Text(
                      'Dose1',
                      style: TextStyle(fontFamily: '',color:Colors.black,decoration: TextDecoration.none,fontSize: 10,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right
                    )
                  ),
                  Expanded(
                    child: Text(
                      'Dose2',
                      style: TextStyle(fontFamily: '',color:Colors.black,decoration: TextDecoration.none,fontSize: 10,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right
                    )
                  )
                ]
              )
            ),
            Flexible(
              child: Scrollbar(
                radius: const Radius.circular(15),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: response.data.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context,index){
                    return Container(
                      color: index%2 == 0 ? Colors.white : Colors.grey[100],
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              response.data[index].date.split('-').reversed.join('-'),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: '',color: Colors.black,fontSize: 10,decoration: TextDecoration.none,fontWeight: FontWeight.normal)
                            )
                          ),
                          Expanded(
                            child: Text(
                              response.data[index].totalVaccinations != null
                              ? response.data[index].totalVaccinations.toString()
                              : 'N/A',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: '',color: Colors.black,fontSize: 10,decoration: TextDecoration.none,fontWeight: FontWeight.normal)
                            )
                          ),
                          Expanded(
                            child: Text(
                              response.data[index].peopleVaccinated != null
                              ? response.data[index].peopleVaccinated.toString()
                              : 'N/A',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: '',color: Colors.black,fontSize: 10,decoration: TextDecoration.none,fontWeight: FontWeight.normal)
                            )
                          ),
                          Expanded(
                            child: Text(
                              response.data[index].peopleFullyVaccinated != null
                              ? response.data[index].peopleFullyVaccinated.toString()
                              : 'N/A',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: '',color: Colors.black,fontSize: 10,decoration: TextDecoration.none,fontWeight: FontWeight.normal)
                            )
                          )
                        ],
                      )
                    );
                  }, separatorBuilder: (BuildContext context, int index) => const Divider(height: 1,thickness: 1)
                )
              )
            )
          ]
        )
      )
    );
  }
}
