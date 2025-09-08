# Modelo de Base de Datos: Licorera (Producción)

## Descripción del Negocio

En una fábrica de licores, el negocio se centra en la producción de múltiples productos. Cada producto es elaborado por una única fábrica. Para su operación, cada fábrica cuenta con muchos empleados, y cada empleado trabaja para una sola fábrica. La producción terminada se almacena en varias bodegas de la misma fábrica, y cada bodega pertenece exclusivamente a una sola fábrica. Los proveedores pueden abastecer a una o varias fábricas, y cada fábrica puede ser abastecida por varios proveedores.

La producción se organiza en lotes: cada lote es una unidad de producción de un producto específico, fabricada bajo las mismas condiciones en un periodo determinado. Cada lote pertenece a un único producto, y cada producto puede tener muchos lotes a lo largo del tiempo. Cada lote se origina a partir de una combinación de diversas materias primas, y un mismo tipo de materia prima puede utilizarse en muchos lotes. Estas materias primas son entregadas por los proveedores: un proveedor puede suministrar distintos tipos de materia prima, y cada materia prima puede ser ofrecida por varios proveedores. Las unidades de un mismo lote pueden distribuirse en varias bodegas, y cada bodega puede almacenar unidades de múltiples lotes.

Según el tipo de producto, un lote puede requerir fermentación. Cuando aplica, cada lote es sometido a un único proceso de fermentación y cada fermentación corresponde a un único lote. La fermentación se realiza en tanques: una fermentación puede llevarse a cabo en varios tanques en momentos distintos, y un tanque solo atiende una fermentación a la vez.

También según el producto, un lote puede requerir destilación. En ese caso, un lote puede tener varios ciclos de destilación y cada ciclo de destilación corresponde a un único lote. La destilación se realiza en alambiques. Cada ciclo usa un solo alambique. Un alambique puede realizar muchos ciclos, pero no al mismo tiempo.

Para garantizar los estándares, a cada lote se le aplican distintos tipos de pruebas de calidad, y un mismo tipo de prueba puede aplicarse a múltiples lotes. Las pruebas son realizadas por los empleados; un empleado puede ejecutar muchas pruebas, y un mismo tipo de prueba puede ser llevada a cabo por diferentes empleados.

---

## Entidades del Modelo

### FABRICA

```
# idFabrica
* razonSocial
* nit
* direccion
° nombreComercial
° telefono
° email
° fechaFundacion
```

**Justificación:** Entidad central que representa la empresa productora. Tiene identidad jurídica propia (NIT) y controla toda la operación productiva. Necesaria para diferenciar múltiples plantas en sistemas empresariales complejos.

### PRODUCTO

```
# idProducto
* idFabrica (FK)
* nombre
* tipoProducto
* requiereFermentacion (T|F)
* requiereDestilacion (T|F)
° descripcion
° gradoAlcoholico
° presentacion
```

**Justificación:** Cada tipo de licor tiene características únicas (whisky, ron, vodka) con procesos de producción específicos. Define las reglas de negocio para la fabricación y es fundamental para la trazabilidad del producto.

### BODEGA

```
# idBodega
* idFabrica (FK)
* nombre
* tipoBodega (materiasPrimas|productoTerminado)
* esRefrigerada (T|F)
* direccion
° temperatura
° capacidad
° estado (activa|inactiva)
```

**Justificación:** Espacios físicos de almacenamiento con características operativas específicas. Es un recurso limitado que requiere gestión eficiente para inventarios y control de condiciones ambientales.

### EMPLEADO

```
# idEmpleado
* idFabrica (FK)
* nombre
* apellido
* numeroDocumento
° cargo
° permisos
° estado (activo|inactivo)
° telefono
° email
° fechaIngreso
```

**Justificación:** Personal con responsabilidades específicas en procesos críticos. Necesario para trazabilidad (quién ejecutó qué proceso), control de acceso y cumplimiento de normativas laborales y de calidad.

### PROVEEDOR

```
# idProveedor
* razonSocial
* nit
° nombreComercial
° telefono
° email
° ciudad
° pais
° direccion
° estado (activo|inactivo)
```

**Justificación:** Actores externos con identidad jurídica independiente. Cada uno tiene condiciones comerciales, historial de desempeño y contratos específicos que afectan la cadena de suministro.

### MATERIA_PRIMA

```
# idMateriaPrima
* nombre
* unidadMedida
* tipoMateria (cereal|fruta|azucar|levadura|aditivo|otro)
° descripcion
° tiempoVidaUtil
° condicionesAlmacenamiento
```

**Justificación:** Insumos con propiedades físicas y químicas únicas que determinan la calidad del producto final. Cada tipo requiere manejo, almacenamiento y control de calidad específicos según normativas alimentarias.

### LOTE

```
# idLote
* idProducto (FK)
* numeroLote
* cantidad
* unidadMedida
* fechaProduccion
* estado (enProceso|fermentando|destilando|envejeciendo|terminado|vendido)
° fechaVencimiento
° observaciones
° gradoAlcoholicoFinal
```

**Justificación:** Unidad fundamental de trazabilidad en la industria alimentaria. Requerido por regulaciones sanitarias para seguimiento desde materias primas hasta consumidor final. Facilita recalls y control de calidad.

### FERMENTACION

```
# idFermentacion
* idLote (FK)
* fechaInicio
* fechaFin
* temperatura
* estado (iniciada|enProceso|finalizada|cancelada)
° tiempoEstimado
° observaciones
```

**Justificación:** Proceso bioquímico crítico con ciclo de vida independiente. Requiere monitoreo constante de parámetros (temperatura, tiempo), puede fallar independientemente del lote, y gestiona recursos especializados (tanques). No es simplemente un estado del lote sino un proceso complejo.

### TANQUE_FERMENTACION

```
# idTanque
* numero
* capacidad
* material
* estado (disponible|ocupado|mantenimiento)
° ubicacion
° fechaUltimoMantenimiento
```

**Justificación:** Activos físicos especializados con características que afectan el proceso (capacidad, material). Su disponibilidad impacta la programación de producción y requieren mantenimiento programado con historial propio.

### ALAMBIQUE

```
# idAlambique
* numero
* capacidad
* tipoAlambique (continuo|discontinuo|columna)
* estado (disponible|ocupado|mantenimiento)
° material
° ubicacion
° fechaUltimoMantenimiento
```

**Justificación:** Equipos críticos cuyo tipo determina las características del destilado final. Requieren programación especializada, mantenimiento técnico y control de disponibilidad para optimizar la producción.

### CICLO_DESTILACION

```
# idCicloDestilacion
* idLote (FK)
* idAlambique (FK)
* numeroCiclo
* fechaInicio
* fechaFin
* temperatura
* estado (iniciado|enProceso|finalizado|cancelado)
° gradoAlcoholicoEntrada
° gradoAlcoholicoSalida
° observaciones
```

**Justificación:** Cada ejecución de destilación produce resultados únicos con parámetros específicos. Un lote puede requerir múltiples ciclos, cada uno con características que afectan la calidad final y requieren trazabilidad individual.

### PRUEBA_CALIDAD

```
# idPruebaCalidad
* nombre
* descripcion
* tipoParametro (fisico|quimico|microbiologico|organoleptico)
* unidadMedida
° valorMinimoAceptable
° valorMaximoAceptable
° metodologia
```

**Justificación:** Catálogo de análisis con metodologías específicas y parámetros de aceptación únicos. Reutilizable para múltiples lotes, permite estandarización de procesos y cumplimiento de regulaciones sanitarias.

---

## Tablas Intermedias (Relaciones M:N)

### FABRICA_PROVEEDOR

```
# idFabrica (FK)
# idProveedor (FK)
* fechaInicioRelacion
° fechaFinRelacion
° condicionesPago
° estado (activa|inactiva)
```

### LOTE_MATERIA_PRIMA

```
# idLote (FK)
# idMateriaPrima (FK)
* cantidad
* unidadMedida
* fechaUso
° loteMateriaPrima
° fechaVencimiento
```

### LOTE_BODEGA

```
# idLote (FK)
# idBodega (FK)
* cantidadAlmacenada
* fechaAlmacenamiento
° fechaSalida
° observaciones
```

### FERMENTACION_TANQUE

```
# idFermentacion (FK)
# idTanque (FK)
* fechaInicio
* fechaFin
° observaciones
```

### LOTE_PRUEBA_CALIDAD

```
# idLote (FK)
# idPruebaCalidad (FK)
# fechaPrueba
* resultado
* unidadMedida
* cumpleEstandar (T|F)
° observaciones
```

### EMPLEADO_PRUEBA_CALIDAD

```
# idEmpleado (FK)
# idLote (FK)
# idPruebaCalidad (FK)
# fechaPrueba
* responsable (T|F)
° observaciones
```

### PROVEEDOR_MATERIA_PRIMA

```
# idProveedor (FK)
# idMateriaPrima (FK)
* precio
* unidadMedida
* fechaVigenciaInicio
° fechaVigenciaFin
° tiempoEntrega
° cantidadMinimaPedido
```

---

## Relaciones del Modelo

### Relaciones 1:N

- **FABRICA → PRODUCTO**: Una fábrica produce múltiples productos
- **FABRICA → BODEGA**: Una fábrica opera múltiples bodegas
- **FABRICA → EMPLEADO**: Una fábrica emplea múltiples trabajadores
- **PRODUCTO → LOTE**: Un producto genera múltiples lotes a lo largo del tiempo
- **LOTE → CICLO_DESTILACION**: Un lote puede pasar por múltiples ciclos de destilación
- **ALAMBIQUE → CICLO_DESTILACION**: Un alambique realiza múltiples ciclos en el tiempo
- **FERMENTACION → TANQUE_FERMENTACION**: Una fermentación puede usar múltiples tanques

### Relaciones 1:1

- **LOTE ↔ FERMENTACION**: Un lote puede requerir una fermentación (opcional)

### Relaciones M:N

- **FABRICA ↔ PROVEEDOR**: Relaciones comerciales múltiples
- **LOTE ↔ MATERIA_PRIMA**: Un lote usa múltiples materias primas
- **LOTE ↔ BODEGA**: Un lote puede distribuirse en múltiples bodegas
- **LOTE ↔ PRUEBA_CALIDAD**: Un lote se somete a múltiples pruebas
- **EMPLEADO ↔ PRUEBA_CALIDAD**: Un empleado puede realizar múltiples tipos de pruebas
- **PROVEEDOR ↔ MATERIA_PRIMA**: Un proveedor suministra múltiples materias primas

---

---

## Leyenda de Notación

- **#** = Clave primaria
- **\*** = Atributo obligatorio
- **°** = Atributo opcional
- **(FK)** = Clave foránea
- **(T|F)** = Valores booleanos
- **(valor1|valor2)** = Valores enumerados

---
