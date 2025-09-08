// ====================================================
// MODELO DE NEGOCIO: LICORERA (PRODUCCIÓN) - REFACTORIZADO
// Código para dbdiagram.io
// ====================================================

// ENTIDADES PRINCIPALES
// ====================================================

Table FABRICA {
  idFabrica int [pk, increment]
  razonSocial varchar(200) [not null]
  nit varchar(20) [not null, unique]
  direccion text [not null]
  nombreComercial varchar(150)
  telefono varchar(20)
  email varchar(100)
  fechaFundacion date
  
  Note: 'Tabla principal que representa cada fábrica de licores'
}

Table PRODUCTO {
  idProducto int [pk, increment]
  idFabrica int [ref: > FABRICA.idFabrica, not null]
  nombre varchar(100) [not null]
  tipoProducto varchar(50) [not null]
  requiereFermentacion boolean [not null, default: false]
  requiereDestilacion boolean [not null, default: false]
  descripcion text
  gradoAlcoholico decimal(5,2)
  presentacion varchar(50)
  
  Note: 'Productos elaborados por cada fábrica'
}

Table BODEGA {
  idBodega int [pk, increment]
  idFabrica int [ref: > FABRICA.idFabrica, not null]
  nombre varchar(100) [not null]
  tipoBodega varchar(20) [not null, note: 'materiasPrimas | productoTerminado']
  esRefrigerada boolean [not null, default: false]
  direccion text [not null]
  temperatura decimal(5,2)
  capacidad decimal(10,2)
  estado varchar(20) [default: 'activa', note: 'activa | inactiva']
  
  Note: 'Bodegas de almacenamiento de cada fábrica'
}

Table EMPLEADO {
  idEmpleado int [pk, increment]
  idFabrica int [ref: > FABRICA.idFabrica, not null]
  nombre varchar(100) [not null]
  apellido varchar(100) [not null]
  numeroDocumento varchar(20) [not null, unique]
  cargo varchar(100)
  permisos text
  estado varchar(20) [default: 'activo', note: 'activo | inactivo']
  telefono varchar(20)
  email varchar(100)
  fechaIngreso date
  
  Note: 'Empleados de cada fábrica'
}

Table PROVEEDOR {
  idProveedor int [pk, increment]
  razonSocial varchar(200) [not null]
  nit varchar(20) [not null, unique]
  nombreComercial varchar(150)
  telefono varchar(20)
  email varchar(100)
  ciudad varchar(100)
  pais varchar(100)
  direccion text
  estado varchar(20) [default: 'activo', note: 'activo | inactivo']
  
  Note: 'Proveedores de materias primas'
}

Table MATERIA_PRIMA {
  idMateriaPrima int [pk, increment]
  nombre varchar(100) [not null]
  unidadMedida varchar(20) [not null]
  tipoMateria varchar(50) [not null, note: 'cereal | fruta | azucar | levadura | aditivo | otro']
  descripcion text
  tiempoVidaUtil int [note: 'en días']
  condicionesAlmacenamiento text
  
  Note: 'Materias primas utilizadas en la producción'
}

Table LOTE {
  idLote int [pk, increment]
  idProducto int [ref: > PRODUCTO.idProducto, not null]
  numeroLote varchar(50) [not null, unique]
  cantidad decimal(10,2) [not null]
  unidadMedida varchar(20) [not null]
  fechaProduccion date [not null]
  estado varchar(20) [not null, note: 'enProceso | fermentando | destilando | envejeciendo | terminado | vendido']
  fechaVencimiento date
  observaciones text
  gradoAlcoholicoFinal decimal(5,2)
  
  Note: 'Lotes de producción de cada producto'
}

Table FERMENTACION {
  idFermentacion int [pk, increment]
  idLote int [ref: - LOTE.idLote, not null, unique]
  fechaInicio datetime [not null]
  fechaFin datetime
  temperatura decimal(5,2) [not null]
  estado varchar(20) [not null, note: 'iniciada | enProceso | finalizada | cancelada']
  tiempoEstimado int [note: 'en horas']
  observaciones text
  
  Note: 'Procesos de fermentación (relación 1:1 con LOTE)'
}

// ====================================================
// SUPERTYPE-SUBTYPE: EQUIPOS DE PRODUCCIÓN
// ====================================================

Table EQUIPO {
  idEquipo int [pk, increment]
  idFabrica int [ref: > FABRICA.idFabrica, not null]
  numero varchar(20) [not null, unique]
  capacidad decimal(10,2) [not null]
  material varchar(50) [not null]
  tipoEquipo varchar(30) [not null, note: 'tanqueFermentacion | alambique']
  estado varchar(20) [not null, default: 'disponible', note: 'disponible | ocupado | mantenimiento']
  ubicacion varchar(100)
  fechaUltimoMantenimiento date
  fechaAdquisicion date
  valorAdquisicion decimal(12,2)
  observaciones text
  
  Note: 'Supertype: Equipos de producción (tanques y alambiques)'
}

Table TANQUE_FERMENTACION {
  idEquipo int [pk, ref: - EQUIPO.idEquipo, not null]
  volumenUtilMaximo decimal(10,2)
  sistemaAgitacion varchar(50)
  controlTemperatura boolean [default: false]
  
  Note: 'Subtype: Tanques específicos para fermentación'
}

Table ALAMBIQUE {
  idEquipo int [pk, ref: - EQUIPO.idEquipo, not null]
  tipoAlambique varchar(30) [not null, note: 'continuo | discontinuo | columna']
  numeroColumnas int [default: 1]
  temperaturaMaxima decimal(5,2)
  presionTrabajo decimal(6,2)
  
  Note: 'Subtype: Alambiques específicos para destilación'
}

Table CICLO_DESTILACION {
  idCicloDestilacion int [pk, increment]
  idLote int [ref: > LOTE.idLote, not null]
  idEquipo int [ref: > EQUIPO.idEquipo, not null] // Referencia al equipo (debe ser alambique)
  numeroCiclo int [not null]
  fechaInicio datetime [not null]
  fechaFin datetime
  temperatura decimal(5,2) [not null]
  estado varchar(20) [not null, note: 'iniciado | enProceso | finalizado | cancelado']
  gradoAlcoholicoEntrada decimal(5,2)
  gradoAlcoholicoSalida decimal(5,2)
  observaciones text
  
  Note: 'Ciclos de destilación para cada lote'
}

Table PRUEBA_CALIDAD {
  idPruebaCalidad int [pk, increment]
  nombre varchar(100) [not null]
  descripcion text [not null]
  tipoParametro varchar(30) [not null, note: 'fisico | quimico | microbiologico | organoleptico']
  unidadMedida varchar(20) [not null]
  valorMinimoAceptable decimal(10,4)
  valorMaximoAceptable decimal(10,4)
  metodologia text
  
  Note: 'Tipos de pruebas de calidad disponibles'
}

// TABLAS INTERMEDIAS (RELACIONES M:N)
// ====================================================

Table FABRICA_PROVEEDOR {
  idFabrica int [ref: > FABRICA.idFabrica]
  idProveedor int [ref: > PROVEEDOR.idProveedor]
  fechaInicioRelacion date [not null]
  fechaFinRelacion date
  condicionesPago text
  estado varchar(20) [default: 'activa', note: 'activa | inactiva']
  
  indexes {
    (idFabrica, idProveedor) [pk]
  }
  
  Note: 'Relación entre fábricas y proveedores'
}

Table LOTE_MATERIA_PRIMA {
  idLote int [ref: > LOTE.idLote]
  idMateriaPrima int [ref: > MATERIA_PRIMA.idMateriaPrima]
  cantidad decimal(10,2) [not null]
  unidadMedida varchar(20) [not null]
  fechaUso date [not null]
  loteMateriaPrima varchar(50)
  fechaVencimiento date
  
  indexes {
    (idLote, idMateriaPrima) [pk]
  }
  
  Note: 'Materias primas utilizadas en cada lote'
}

Table LOTE_BODEGA {
  idLote int [ref: > LOTE.idLote]
  idBodega int [ref: > BODEGA.idBodega]
  cantidadAlmacenada decimal(10,2) [not null]
  fechaAlmacenamiento date [not null]
  fechaSalida date
  observaciones text
  
  indexes {
    (idLote, idBodega) [pk]
  }
  
  Note: 'Distribución de lotes en bodegas'
}

Table FERMENTACION_EQUIPO {
  idFermentacion int [ref: > FERMENTACION.idFermentacion]
  idEquipo int [ref: > EQUIPO.idEquipo] // Referencia al equipo (debe ser tanque fermentación)
  fechaInicio datetime [not null]
  fechaFin datetime
  observaciones text
  
  indexes {
    (idFermentacion, idEquipo, fechaInicio) [pk]
  }
  
  Note: 'Uso de equipos en procesos de fermentación'
}

Table LOTE_PRUEBA_CALIDAD {
  idLote int [ref: > LOTE.idLote]
  idPruebaCalidad int [ref: > PRUEBA_CALIDAD.idPruebaCalidad]
  fechaPrueba datetime
  resultado decimal(10,4) [not null]
  unidadMedida varchar(20) [not null]
  cumpleEstandar boolean [not null]
  observaciones text
  
  indexes {
    (idLote, idPruebaCalidad, fechaPrueba) [pk]
  }
  
  Note: 'Pruebas de calidad aplicadas a cada lote'
}

Table EMPLEADO_PRUEBA_CALIDAD {
  idEmpleado int [ref: > EMPLEADO.idEmpleado]
  idLote int [ref: > LOTE.idLote]
  idPruebaCalidad int [ref: > PRUEBA_CALIDAD.idPruebaCalidad]
  fechaPrueba datetime
  responsable boolean [not null, default: false]
  observaciones text
  
  indexes {
    (idEmpleado, idLote, idPruebaCalidad, fechaPrueba) [pk]
  }
  
  Note: 'Empleados que ejecutan pruebas de calidad'
}

Table PROVEEDOR_MATERIA_PRIMA {
  idProveedor int [ref: > PROVEEDOR.idProveedor]
  idMateriaPrima int [ref: > MATERIA_PRIMA.idMateriaPrima]
  precio decimal(12,4) [not null]
  unidadMedida varchar(20) [not null]
  fechaVigenciaInicio date [not null]
  fechaVigenciaFin date
  tiempoEntrega int [note: 'en días']
  cantidadMinimaPedido decimal(10,2)
  
  indexes {
    (idProveedor, idMateriaPrima) [pk]
  }
  
  Note: 'Precios y condiciones de materias primas por proveedor'
}

// ====================================================
// TABLA ADICIONAL: MANTENIMIENTO DE EQUIPOS
// ====================================================

Table MANTENIMIENTO_EQUIPO {
  idMantenimiento int [pk, increment]
  idEquipo int [ref: > EQUIPO.idEquipo, not null]
  idEmpleado int [ref: > EMPLEADO.idEmpleado, not null]
  tipoMantenimiento varchar(30) [not null, note: 'preventivo | correctivo | emergencia']
  fechaProgramada date [not null]
  fechaEjecucion date
  fechaFinalizacion date
  descripcionTrabajo text [not null]
  costo decimal(10,2)
  estado varchar(20) [not null, default: 'programado', note: 'programado | enProceso | completado | cancelado']
  observaciones text
  
  Note: 'Registro de mantenimientos realizados a los equipos'
}
