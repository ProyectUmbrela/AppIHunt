import 'package:flutter/material.dart';
import 'registerTenants.dart';

class Tenants extends StatefulWidget {
  @override
  _TenantsState createState() => _TenantsState();
}

class _TenantsState extends State<Tenants> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de inquilinos de propietario'),
      ),
      body: Stack(
          children: <Widget> [ ListView.builder(
              itemCount: entries.length,
              padding: const EdgeInsets.all(5),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shadowColor: Colors.deepPurpleAccent,
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    color: Colors.black12,
                    shadowColor: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.airline_seat_individual_suite),
                          title: Text('inquilino ${entries[index]}'),
                          subtitle: Text(
                            'Texto secundario',
                            style:
                            TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          child: Row(
                            //padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Ocupada:',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '  sí',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: 'Precio: ', style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.bold)),
                                            TextSpan(text: '${entries[index]}' , style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
                                                fontWeight: FontWeight.normal)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              textColor: const Color(0xFF6200EE),
                              onPressed: () {
                                // Perform some action
                              },
                              child: const Text('Editar'),
                            ),
                          ],
                        ),
                        //Image.asset('assets/card-sample-image.jpg'),
                        //Image.asset('assets/card-sample-image-2.jpg'),
                      ],
                    ),
                  ),
                );
              }),
          ]
      ),
        floatingActionButton: new FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new RegisterTenant(),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text("Registrar inquilino"),
          foregroundColor: Colors.black,
          backgroundColor: Colors.cyan,
        ),
    );
  }
}
