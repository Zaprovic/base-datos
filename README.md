# Modelo de Base de Datos: Licorera UNALcoholico S.A.S

## Descripción del Negocio

En una **fábrica** de licores, identificada por su **idFabrica**, su **razónSocial**, **nit** y **dirección fiscal**, y reconocida por su **nombreComercial**, el negocio se centra en la producción de múltiples **productos**. Cada **producto** es elaborado por una única **fábrica**. Para su operación, cada **fábrica** cuenta con muchos **empleados**, y cada **empleado** trabaja para una sola **fábrica**. Cada **Empleado**, a quien se le asigna un **idEmpleado** único, se registra con su **nombre** completo, **cargo**, **permisos de operación**, **estado** (activo o inactivo), y datos de contacto como **telefono** y **email**. La producción terminada se almacena en varias **bodegas**, cada una con su **idBodega** y un **nombre** para su fácil localización. Estas se clasifican según su **tipoBodega** (materias primas o producto terminado), se especifica si **esRefrigerada** (T/F), y se registran su **dirección**, **temperatura de operación** y **capacidad**. Los **Proveedores**, cada uno con un **idProveedor**, se registran con su **razonSocial**, **nit** y datos de contacto y ubicación como **telefono**, **email**, **direccion**, **ciudad** y **pais**, además de su **estado** actual; estos pueden abastecer a una o varias **fábricas**, y cada **fábrica** puede ser abastecida por varios **proveedores**.


La producción se organiza en **lotes**. Cada **Lote** es trazable gracias a su **idLote** y se registra con su **fechaInicio** de producción, **fechaFin**, la **cantidad** producida con su respectiva **unidad** (unidades, L, kg) y su **estado** (en proceso, aprobado, rechazado). Cada **lote** es una unidad de producción de un **producto** específico, el cual se identifica con un **idProducto** único y se define por su **nombre** y **tipoProducto**. Cada **lote** pertenece a un único **producto**, y cada **producto** puede tener muchos **lotes** a lo largo del tiempo. Cada **lote** se origina a partir de una combinación de diversas **materias primas**, cada una registrada con un **idMateriaPrima**, **nombre**, **unidad de medida**, y si es **perecedera** (T/F) junto con su **vidaUtilDias**. Estas **materias primas** son entregadas por los **proveedores**, estableciéndose una relación donde se registra el precio y la moneda de compra para cada **idMateriaPrima** por cada **idProveedor**. Las unidades de un mismo **lote** pueden distribuirse en varias **bodegas**, y cada **bodega** puede almacenar unidades de múltiples **lotes**.


Según el tipo de **producto**, un **lote** puede requerir **fermentación**. Cuando aplica, cada **lote** es sometido a un único proceso de **fermentación**, identificado con un **idFermentacion** y definido por su **fechaInicio**, **fechaFin** y la **temperaturaObjetivo** a mantener. Cada **fermentación** corresponde a un único **lote**. La **fermentación** se realiza en **tanques**, los cuales son un tipo de equipo y se definen por su **tipoTanque** (abierto, cerrado, etc.). Una **fermentación** puede llevarse a cabo en varios **tanques** en momentos distintos, y un **tanque** solo atiende una **fermentación** a la vez. La relación de uso se gestiona registrando la **idFermentacion** con la **idTanque** utilizada, junto con la **fechaInicio** y **fechaFin** de dicha ocupación.


También según el **producto**, un **lote** puede requerir destilación. En ese caso, un **lote** puede tener varios **ciclos de destilación**, donde cada **Ciclo_Destilacion** se registra con su **idCiclo**, **fechaInicio**, **fechaFin**, el **volumenEntrada**, **volumenSalida** y el **gradoAlcohol** obtenido. Cada **ciclo de destilación** corresponde a un único **lote**. La destilación se realiza en **alambiques**, que son otro tipo de equipo y se diferencian por su **tipoAlambique** (olla o columna) y el material del que está hecho (cobre, acero, etc.). Cada **ciclo** usa un solo **alambique**. Tanto los tanques como los **alambiques** son registrados en una tabla general de **Equipo**, donde cada uno posee un **idEquipo** único para toda la fábrica. Este registro incluye su capacidad con su **unidadCapacidad**, **estado** (activo, mantenimiento), **fabricante**, **modelo** y **numeroSerie**. Un **alambique** puede realizar muchos ciclos, pero no al mismo tiempo.


Para garantizar los estándares, a cada **lote** se le aplican distintos tipos de **pruebas de calidad**, donde cada **Tipo_Prueba** se identifica con un **idTipoPrueba** y se define por su **nombre** y el **metodo** a utilizar. Un mismo tipo de **prueba** puede aplicarse a múltiples **lotes**. El registro de cada **Ejecucion_Prueba** vincula el **idLote**, el **idTipoPrueba** y la **fecha** en que se realizó. Además, es fundamental registrar el **idEmpleado** responsable y el **resultado** obtenido en dicha **prueba**. Las **pruebas** son realizadas por los **empleados**; un **empleado** puede ejecutar muchas **pruebas**, y un mismo tipo de prueba puede ser llevada a cabo por diferentes **empleados**.

## Entidades

#### **FABRICA**
- `# idFabrica`
- `* razónSocial`
- `* nit`
- `* dirección`
- `° nombreComercial`

#### **PRODUCTO**
- `# idProducto`
- `* idFabrica`
- `* nombre`
- `* tipoProducto`

#### **EMPLEADO**
- `# idEmpleado`
- `* idFabrica`
- `* nombre`
- `° cargo`
- `° permisos`
- `° estado (activo | inactivo)`
- `° telefono`
- `° email`

#### **BODEGA**
- `# idBodega`
- `* idFabrica`
- `* tipoBodega (materiasPrimas | productoTerminado)`
- `* esRefrigerada (T | F)`
- `* dirección`
- `° nombre`
- `° temperatura`
- `° capacidad`

#### **LOTE**
- `# idLote`
- `* idProducto`
- `* fechaInicio`
- `° fechaFin`
- `° cantidad`
- `° unidad (unidades | L | kg | cajas, …)`
- `° estado ( enProceso | aprobado | rechazado)`

#### **PROVEEDOR**
- `# idProveedor`
- `* razonSocial`
- `* nit`
- `° telefono`
- `° email`
- `° ciudad`
- `° pais`
- `° direccion`
- `° estado`

#### **MATERIA_PRIMA**
- `# idMateriaPrima`
- `* nombre`
- `* unidad (L, kg, g, mL, etc)`
- `° perecedera (T | F)`
- `° vidaUtilDias`

#### **PROVEEDOR_MATERIA**
- `# idProveedor`
- `# idMateriaPrima`
- `* precio`
- `° moneda`

#### **FERMENTACIÓN**
- `# idFermentacion`
- `* idLote`
- `* fechaInicio`
- `° fechaFin`
- `° temperaturaObjetivo`

#### **TANQUE**
- `# idEquipo`
- `° tipoTanque (abierto | cerrado, ...)`

#### **USO_TANQUE**
- `# idFermentacion`
- `# idTanque`
- `# fechaInicio`
- `° fechaFin`

#### **CICLO_DESTILACION**
- `# idCiclo`
- `* idLote`
- `* idAlambique`
- `* fechaInicio`
- `° fechaFin`
- `° volumenEntrada`
- `° volumenSalida`
- `° gradoAlcohol`

#### **ALAMBIQUE**
- `# idEquipo`
- `* tipoAlambique (olla | columna)`
- `° material (cobre | acero, …)`

#### **EQUIPO**
- `# idEquipo`
- `* idFabrica`
- `° capacidad`
- `° unidadCapacidad`
- `° estado (activo | mantenimiento)`
- `° fabricante`
- `° modelo`
- `° numeroSerie`

#### **TIPO_PRUEBA**
- `# idTipoPrueba`
- `* nombre`
- `° metodo`

#### **EJECUCION_PRUEBA**
- `# idLote`
- `# idTipoPrueba`
- `# fecha`
- `* idEmpleado`
- `° resultado`

## Relaciones

#### **FÁBRICA – PRODUCTO**
Una fábrica debe producir muchos productos (1:N). Un producto debe ser elaborado por una única fábrica (N:1).
#### **FÁBRICA – BODEGA**
Una fábrica puede tener varias bodegas (1:N). Cada bodega debe pertenecer a una fábrica (N:1).
#### **FÁBRICA – PROVEEDOR**
Una fábrica puede ser abastecida por varios proveedores (M:N). Un proveedor puede abastecer a varias fábricas (M:N).
#### **FÁBRICA – EMPLEADO**
Una fábrica puede emplear muchos empleados (1:N). Un empleado debe trabajar en una sola fábrica (N:1).
#### **BODEGA – PRODUCTO/LOTE**
Una bodega puede almacenar unidades de muchos lotes (M:N). Un lote puede ser distribuido en varias bodegas (M:N).
#### **PRODUCTO – LOTE**
Un producto puede originar múltiples lotes (1:N). Cada lote debe corresponder a un único producto (N:1).
#### **LOTE – MATERIA PRIMA**
Un lote puede estar compuesto de muchas materias primas (M:N). Una materia prima puede ser utilizada en muchos lotes (M:N).
#### **MATERIA PRIMA – PROVEEDOR**
Una materia prima puede ser provista por muchos proveedores (M:N). Un proveedor puede suministrar distintas materias primas (M:N).
#### **LOTE – FERMENTACIÓN**
Un lote puede requerir un proceso de fermentación (1:1 opcional). Una fermentación debe estar
asociada a un único lote (1:1).
#### **FERMENTACIÓN – TANQUE**
Un proceso de fermentación puede usar varios tanques en diferentes momentos (1:N). Un tanque solo puede ejecutar un proceso de fermentación a la vez (N:1 en un instante).
#### **LOTE – DESTILACIÓN**
Un lote puede pasar por varios ciclos de destilación (1:N). Cada ciclo debe corresponder a un único lote (N:1).
#### **CICLO DE DESTILACIÓN – ALAMBIQUE**
Un ciclo debe usar un alambique (N:1). Un alambique puede realizar muchos ciclos en el tiempo (1:N).
#### **LOTE – PRUEBA DE CALIDAD**
Un lote puede estar sujeto a muchas pruebas (M:N). Una prueba puede aplicarse a varios lotes (M:N).
#### **PRUEBA DE CALIDAD – EMPLEADO**
Un empleado puede realizar muchas pruebas (1:N). Una prueba puede ser ejecutada por varios
empleados (M:N).

