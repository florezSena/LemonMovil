class Producto{
  int idProducto;
  String nombre;
  double cantidad;
  double precio;
  String? descripcion;
  int estado;
  Producto(this.idProducto, this.nombre, this.cantidad,this.precio, this.descripcion, this.estado);
  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'cantidad': cantidad,
      'precio': precio,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
  static Producto fromJson(Map<String, dynamic> json) {
    return Producto(
      json['idProducto'],
      json['nombre'],
      json['cantidad'].toDouble(),
      json['precio']==null?0:json['precio'].toDouble(),
      json['descripcion'],
      json['estado'],
    );
  }
}