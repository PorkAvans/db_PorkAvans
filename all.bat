@echo off
set PGPASSWORD=12345
@REM script
psql -U postgres -d cerdos -f ./script.sql

SET PGCLIENTENCODING=utf8


@REM procedimientos almacenados sp
psql -U postgres -d cerdos -f ./TRIGGERS/encriptar_contrasena.sql
psql -U postgres -d cerdos -f ./TRIGGERS/generar_user_id.sql
psql -U postgres -d cerdos -f ./TRIGGERS/actualizar_deudas_con_pago.sql
psql -U postgres -d cerdos -f ./TRIGGERS/actualizar_monto_total_deuda_restaurante.sql
psql -U postgres -d cerdos -f ./TRIGGERS/registro_auditoria_comida_recolectada.sql
psql -U postgres -d cerdos -f ./TRIGGERS/registro_auditoria_pagos.sql
psql -U postgres -d cerdos -f ./TRIGGERS/actualizar_stok_comida_recolectada.sql
psql -U postgres -d cerdos -f ./TRIGGERS/actualizar_stok_comida_suministrada.sql
psql -U postgres -d cerdos -f ./TRIGGERS/fecha_actualizacion_contrasena.sql
psql -U postgres -d cerdos -f ./TRIGGERS/intentos_fallidos.sql
psql -U postgres -d cerdos -f ./TRIGGERS/inicio_sesion.sql
psql -U postgres -d cerdos -f ./TRIGGERS/registrar_venta.sql

@REM constraints
psql -U postgres -d cerdos -f ./constraints/fk.sql
psql -U postgres -d cerdos -f ./constraints/uk.sql




@REM checks
psql -U postgres -d cerdos -f ./constraints/chek.sql


@REM funciones
psql -U postgres -d cerdos -f ./funciones/agregar_users.sql
psql -U postgres -d cerdos -f ./funciones/editar_users.sql
psql -U postgres -d cerdos -f ./funciones/agregar_producto_recolectada.sql
psql -U postgres -d cerdos -f ./funciones/agregar_comida_suministrada.sql
psql -U postgres -d cerdos -f ./funciones/agregar_restaurante.sql
psql -U postgres -d cerdos -f ./funciones/agregar_pago.sql

@REM funcionales
psql -U postgres -d cerdos -f ./funciones/funcionales/is_valid_base64.sql

@REM procedimieto almacenado


@REM data
psql -U postgres -d cerdos -f ./Data/Recoleccion.sql
psql -U postgres -d cerdos -f ./Data/Estado_recoleccion.sql
psql -U postgres -d cerdos -f ./Data/tipo_distribuidores.sql
psql -U postgres -d cerdos -f ./Data/distribuidores.sql
psql -U postgres -d cerdos -f ./Data/precio_producto.sql
psql -U postgres -d cerdos -f ./Data/tipo_producto.sql
psql -U postgres -d cerdos -f ./Data/productos.sql
 psql -U postgres -d cerdos -f ./Data/comida_recolectada.sql
psql -U postgres -d cerdos -f ./Data/user_rol.sql
psql -U postgres -d cerdos -f ./Data/user_estado.sql
psql -U postgres -d cerdos -f ./Data/users.sql
psql -U postgres -d cerdos -f ./Data/pagos.sql
psql -U postgres -d cerdos -f ./Data/corral.sql
psql -U postgres -d cerdos -f ./Data/tipos_costos.sql
psql -U postgres -d cerdos -f ./Data/Categoria_Costo.sql
psql -U postgres -d cerdos -f ./Data/comida_suministrada.sql
psql -U postgres -d cerdos -f ./Data/commission_type.sql
psql -U postgres -d cerdos -f ./Data/product_category_sale.sql




