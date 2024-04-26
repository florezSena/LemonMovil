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
}