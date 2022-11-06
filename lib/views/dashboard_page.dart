import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[dashBg, _content(context)],
      ),
    );
  }

  get dashBg => Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(color: Colors.deepPurple),
          ),
          Expanded(
            flex: 5,
            child: Container(color: Colors.transparent),
          ),
        ],
      );

  _content(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          header,
          _grid(context),
        ],
      ),
    );
  }

  get header => const ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 50),
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Faxinei',
          style: TextStyle(color: Colors.blue),
        ),
        trailing: CircleAvatar(),
      );

  _grid(BuildContext context){
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: GridView.count(
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
          childAspectRatio: .90,
          children: [
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/clients'),
                  splashColor: Colors.amberAccent,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        /*Image.asset(
                        'assets/images/clients.png',
                      ),*/
                        Text("Clientes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                      ],
                    ),
                  ),
                )
            ),
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/cobrancas'),
                  splashColor: Colors.amberAccent,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        /*Image.asset(
                        'assets/images/clients.png',
                      ),*/
                        Text("Cobranças", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                      ],
                    ),
                  ),
                )
            ),
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/horas'),
                  splashColor: Colors.amberAccent,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        /*Image.asset(
                        'assets/images/clients.png',
                      ),*/
                        Text("Registro de Horas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                      ],
                    ),
                  ),
                )
            ),
            Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/ganhos'),
                  splashColor: Colors.amberAccent,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        /*Image.asset(
                        'assets/images/clients.png',
                      ),*/
                        Text("Registro de Ganhos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
