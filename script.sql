DROP SCHEMA IF EXISTS contabilidad_cerdos CASCADE;
CREATE SCHEMA contabilidad_cerdos;

-- Establece la zona horaria para la sesión actual
SET TIME ZONE 'America/Bogota';

--se crea tabla audit
CREATE TABLE contabilidad_cerdos.audit
(
    Audit_id            SERIAL PRIMARY KEY,
    affected_table      VARCHAR(100),
    exchange_rate       VARCHAR(20),
    affected_record_id  INT,
    previous_parameters TEXT,
    new_parameters      TEXT,
    user_modification   VARCHAR(100),
    registration_date   TIMESTAMP
);

--se crea tabla collection
CREATE TABLE contabilidad_cerdos.collection
(
    collection_id       SERIAL PRIMARY KEY,
    collection_in_hours INTEGER
);

--se crea tabla status_collection
CREATE TABLE contabilidad_cerdos.status_collection
(
    status_collection_id SERIAL PRIMARY KEY,
    description          varchar(50)
);

--se crea la tabla tipo distributor_type
CREATE TABLE contabilidad_cerdos.distributor_type
(
    distributor_type_id SERIAL PRIMARY KEY,
    description         VARCHAR(255)
);

--se crea tabla distributor
CREATE TABLE contabilidad_cerdos.distributor
(
    distributor_id       SERIAL PRIMARY KEY,
    image                BYTEA,
    distributor_name     VARCHAR(100),
    distributor_address  VARCHAR(200),
    distributor_quarter  VARCHAR(200),
    status_collection_id INT,
    collection_id        INT,
    cell_phone           VARCHAR(15),
    register_date        TIMESTAMP,
    type_distributor     INT,
    status_distributor   varchar(50) DEFAULT 'INACTIVO'
);

--se crea tabla product_price
CREATE TABLE contabilidad_cerdos.product_price
(
    product_price_id SERIAL PRIMARY KEY,
    Price            NUMERIC
);

--se crea tabla product_type
CREATE TABLE contabilidad_cerdos.product_type
(
    product_type_id SERIAL PRIMARY KEY,
    description     VARCHAR(100)
);

--se crea la tabla products
CREATE TABLE contabilidad_cerdos.products
(
    product_id            SERIAL PRIMARY KEY,
    product_type_id       INT,
    product_imagen        BYTEA,
    product_name          VARCHAR(60),
    product_content       NUMERIC,
    product_unidad_medida VARCHAR(15),
    product_description   VARCHAR(255),
    product_price_id      INT,
    register_date         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--se crea tabla distributor_debt
CREATE TABLE contabilidad_cerdos.distributor_debt
(
    distributor_debt_id SERIAL PRIMARY KEY,
    distributor_id      INT,
    total_debt          NUMERIC
);
-- todo aca voy
--se crea tabla product_collected
CREATE TABLE contabilidad_cerdos.product_collected
(
    product_collected_id SERIAL PRIMARY KEY,
    distributor_id       INT,
    pickup_date          DATE,
    product_quantity     NUMERIC,
    product_id           INT,
    registered_by        VARCHAR(255)
);

--se crea tabla Pagos
CREATE TABLE contabilidad_cerdos.Pagos
(
    Pago_id         SERIAL PRIMARY KEY,
    distribuidor_id INT,
    empleado_id     TEXT,
    Fecha_pago      DATE,
    Monto_total     NUMERIC,
    Registrado_por  VARCHAR(255)
);

--se crea la tabla rol
CREATE TABLE contabilidad_cerdos.users_rol
(
    user_rol_id SERIAL PRIMARY KEY,
    rol         VARCHAR(50)
);

--se crea la tabla estado
CREATE TABLE contabilidad_cerdos.users_estado
(
    user_estado_id SERIAL PRIMARY KEY,
    estado         VARCHAR(50)
);

--se crea la tabla de usuarios
CREATE TABLE contabilidad_cerdos.users
(
    user_id              TEXT PRIMARY KEY,
    user_imagen          BYTEA,
    user_nombre          TEXT NOT NULL,
    user_password        TEXT NOT NULL,
    celular              VARCHAR(20),
    user_email           VARCHAR(55),
    user_rol             INT,
    user_estado          INT DEFAULT 2,
    logued               BOOLEAN,
    inicio_sesion        TIMESTAMP,
    password_update_date TIMESTAMP,    -- campo nuevo para auditoría
    failed_attempts      INT DEFAULT 0 -- campo nuevo para registrar intentos fallidos
);

--se crea la tabla de corral
CREATE TABLE contabilidad_cerdos.corral
(
    corral_id              SERIAL PRIMARY KEY,
    corral_fase_crianza_id INT,
    corral_capacidad       INT,
    corral_descripcion     TEXT,
    corral_medidas         TEXT,
    tipo_piso              VARCHAR(100),
    tipo_bebedero          VARCHAR(100),
    tipo_comedero          VARCHAR(100),
    sistema_ventilacion    VARCHAR(100),
    corral_estado          VARCHAR(100)
);

--se crea la tabla de productos_corral
CREATE TABLE contabilidad_cerdos.productos_corral
(
    productos_corral_id SERIAL PRIMARY KEY,
    corral_id           INT,
    producto_id         INT,
    cantidad            NUMERIC
);

--se crea la tabla de animal
CREATE TABLE contabilidad_cerdos.animal
(
    animal_id            SERIAL PRIMARY KEY,
    animal_numero        SERIAL,
    animal_fecha_llegada TIMESTAMP,
    animal_fecha_salida  TIMESTAMP,
    animal_peso_llegada  NUMERIC,
    animal_peso_salida   NUMERIC,
    animal_edad          INT,
    animal_genero        VARCHAR(10),
    animal_raza          VARCHAR(255),
    animal_estado_salud  VARCHAR(100),
    corral_id            INT NOT NULL, -- FK a la tabla Corral
    animal_proveedor     INT NOT NULL,
    animal_motivo_salida VARCHAR(255),
    animal_nota          TEXT
);

--se crea la tabla de corral
CREATE TABLE contabilidad_cerdos.medicamento_animal
(
    medicamento_animal_id SERIAL PRIMARY KEY,
    animal_id             INT,
    medicamento_id        INT,
    dosis                 NUMERIC,
    fecha_aplicacion      DATE NOT NULL,
    frecuencia_aplicacion VARCHAR(50),  -- Ej: 'Diaria', 'Semanal', etc.
    via_aplicacion        VARCHAR(50),  -- Ej: 'Oral', 'Inyectable', etc.
    motivo_tratamiento    VARCHAR(255), -- Ej: 'Prevención', 'Tratamiento de enfermedad específica'
    notas                 TEXT
);


--se crea la tabla de comida_suministrada
CREATE TABLE contabilidad_cerdos.comida_suministrada
(
    comida_suministrada_id          SERIAL PRIMARY KEY,
    comida_suministrada_corral_id   INT,
    comida_suministrada_producto_id INT,
    comida_suministrada_cantidad    NUMERIC,
    comida_suministrada_fecha       TIMESTAMP,
    comida_suministrada_por         VARCHAR(50)
);

--se crea la tabla de stock de productos
CREATE TABLE contabilidad_cerdos.stock_productos
(
    stock_id                   SERIAL PRIMARY KEY,
    producto_id                INT       NOT NULL,
    cantidad_producto          NUMERIC   NOT NULL,
    contenido_neto             NUMERIC,
    fecha_ultima_actualizacion TIMESTAMP NOT NULL
);

--crear la tabla Tipos_Costos
CREATE TABLE contabilidad_cerdos.tipos_costos
(
    tipo_costo_id SERIAL PRIMARY KEY,
    descripcion   VARCHAR(20) NOT NULL,
    detalle       TEXT
);

--se crea la tabla de Categoria_Costo
CREATE TABLE contabilidad_cerdos.categoria_costo
(
    categoria_costo_id SERIAL PRIMARY KEY,
    descripcion        VARCHAR(100) NOT NULL,
    tipo_costo_id      INT          NOT NULL
);

--se crea la tabla de Costos_Produccion
CREATE TABLE contabilidad_cerdos.costos_produccion
(
    costo_id                SERIAL PRIMARY KEY,
    descripcion_costo       VARCHAR(255),
    monto                   NUMERIC NOT NULL,
    fecha                   DATE    NOT NULL,
    cantidad                NUMERIC,     -- Si aplica (ej: cantidad de comida, horas trabajadas)
    unidad_medida           VARCHAR(50), -- Ej: kg, litros, horas, etc.
    categoria_costo_id      INT,         -- Ej: Mano de obra, comida, mantenimiento
    producto_recolectado_id INT,         -- FK a productos recolectados
    animal_id               INT,         -- Si el costo está asociado a un animal específico
    corral_id               INT,         -- Si el costo está asociado a un corral específico
    empleado_id             TEXT         -- FK a la tabla de usuarios
);

--se crera la tabla tipo_comision
CREATE TABLE contabilidad_cerdos.commission_type
(
    commission_type_id          SERIAL PRIMARY KEY,
    commission_type_description VARCHAR(255)
);

--se crea la tabla de comision
CREATE TABLE contabilidad_cerdos.commissions
(
    commission_id   SERIAL PRIMARY KEY,
    commission_type INT            NOT NULL, -- Ej.: 'Porcentaje', 'Fijo'
    value           NUMERIC(10, 2) NOT NULL, -- Ej.: 5.00 para 5% o monto fijo
    description     VARCHAR(255)
);

--se crea la tabla product_category_sale
CREATE TABLE contabilidad_cerdos.product_category_sale
(
    product_category_sale_id SERIAL PRIMARY KEY,
    description              VARCHAR(255)
);

--se crea tabla de products_sale
CREATE TABLE contabilidad_cerdos.products_sale
(
    product_sale_id     SERIAL PRIMARY KEY,
    product_sale_imagen BYTEA,
    name                VARCHAR(100)   NOT NULL,
    description         TEXT,
    price               NUMERIC(10, 2) NOT NULL,
    category            INT,
    quantity            INT,
    commission_id       INT
);

--se crea la tabla
CREATE TABLE contabilidad_cerdos.associate_commissions
(
    associate_commissions_id SERIAL PRIMARY KEY,
    associate_id             TEXT NOT NULL,
    product_id               INT  NOT NULL,
    start_date               TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date                 TIMESTAMP,
    access_number            INT       DEFAULT 0
);

--se crea la tabla de ventas
CREATE TABLE contabilidad_cerdos.ventas
(
    venta_id          SERIAL PRIMARY KEY,
    asociado_id       TEXT           NOT NULL,
    producto_id       INT            NOT NULL,
    cantidad          INT            NOT NULL,
    fecha_venta       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_venta       NUMERIC(10, 2) NOT NULL,
    comision_generada NUMERIC(10, 2),
    imagen_de_venta   BYTEA,
    estado_venta      VARCHAR(50),
    correo_venta      VARCHAR(50),
    observacion_venta TEXT
);

--se crea la tabla de pre_venta
CREATE TABLE contabilidad_cerdos.pre_ventas
(
    pre_venta_id          SERIAL PRIMARY KEY,
    pre_venta_asociado_id TEXT           NOT NULL,
    pre_venta_producto_id INT            NOT NULL,
    pre_venta_cantidad    INT            NOT NULL,
    fecha_pre_venta       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_pre_venta       NUMERIC(10, 2) NOT NULL,
    imagen_pre_venta      BYTEA,
    estado_pre_venta      VARCHAR(50),
    correo_pre_venta      VARCHAR(50),
    observacion_pre_venta TEXT
);

--se crea la tabla de distribuidor de animales
CREATE TABLE contabilidad_cerdos.distribuidor_animal
(
    distribuidor_animal_id        SERIAL PRIMARY KEY,
    distribuidor_animal_nombre    TEXT         NOT NULL,
    distribuidor_animal_celular   VARCHAR      NOT NULL,
    distribuidor_animal_direccion VARCHAR(245) NOT NULL
);

--se crea la tabla de faces de crianza
CREATE TABLE contabilidad_cerdos.fase_crianza
(
    fase_crianza_id         SERIAL PRIMARY KEY,
    nombre_fase             VARCHAR(100) NOT NULL, -- Lactancia, Engorde, Gestación
    descripcion_fase        TEXT,
    edad_min_semanas        INT,                   -- Ej.: 3 semanas
    edad_max_semanas        INT,                   -- Ej.: 8 semanas
    peso_min_kg             NUMERIC,
    peso_max_kg             NUMERIC,
    consumo_alimento_dia_kg NUMERIC,               -- Promedio o estimado por animal
    consumo_agua_dia_litros NUMERIC,
    ganancia_diaria_gr      NUMERIC,
    tipo_alimento           VARCHAR(100),          -- Ej: Preiniciador, Engorde
    duracion_dias_estimada  INT,
    fecha_creacion          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creado_por              TEXT
);

--se crea la tabla del hsitorial de las fases

CREATE TABLE contabilidad_cerdos.historial_fase_crianza
(
    historial_id    SERIAL PRIMARY KEY,
    corral_id       INT  NOT NULL,
    fase_crianza_id INT  NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE,
    user_id         TEXT
);



