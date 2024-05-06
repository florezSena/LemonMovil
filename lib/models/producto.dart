class Producto{
  int idProducto;
  String nombre;
  double cantidad;
  double costo;
  String? descripcion;
  int estado;
  Producto(this.idProducto, this.nombre, this.cantidad,this.costo, this.descripcion, this.estado);
  Map<String, dynamic> productoToJson() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'cantidad': cantidad,
      'costo': costo,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
  static Producto productoFromJson(Map<String, dynamic> json) {
    return Producto(
      json['idProducto'],
      json['nombre'],
      json['cantidad'].toDouble(),
      json['costo']==null?0:json['costo'].toDouble(),
      json['descripcion'],
      json['estado'],
    );
  }
}