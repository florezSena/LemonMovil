class Cliente{
  int idCliente;
  String tipoDocumento;
  BigInt documento;
  String nombreRazonSocial;
  String correo;
  String telefono;
  int estado;
  Cliente(this.idCliente, this.tipoDocumento, this.documento,this.nombreRazonSocial,this.correo, this.telefono, this.estado);
  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'tipoDocumento': tipoDocumento,
      'documento': documento,
      'nombreRazonSocial': nombreRazonSocial,
      'correo':correo,
      'telefono': telefono,
      'estado': estado,
    };
  }
  static Cliente fromJson(Map<String, dynamic> json) {
    return Cliente(
      json['idCliente'],
      json['tipoDocumento'],
      BigInt.from(json['documento']),
      json['nombreRazonSocial'],
      json['correo'],
      json['telefono'],
      json['estado'],
    );
  }
}