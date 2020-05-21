import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/dado_produto.dart';

class ProdutoTitle extends StatelessWidget {
  final String tipo;
  final DadoProduto produto;

  ProdutoTitle(this.tipo, this.produto);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
          child: tipo == "grid"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(
                        produto.imagens[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              produto.titulo,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$ ${produto.preco.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Row()),
    );
  }
}
