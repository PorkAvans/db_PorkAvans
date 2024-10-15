--se crear constraint para la tabla users
ALTER TABLE contabilidad_cerdos.users
    ADD CONSTRAINT user_nombre_length_check CHECK (LENGTH(user_nombre) >= 5);

--se crea constraint para la tabla comida_recolectada
ALTER TABLE contabilidad_cerdos.product_collected
    ADD CONSTRAINT check_contidad_baldes CHECK (product_quantity > 0);

--se crear constraint para la tabla distribuidor
ALTER TABLE contabilidad_cerdos.distributor
    ADD CONSTRAINT user_restaurante_nombre_length_check CHECK (LENGTH(distributor_name) >= 5),
    ADD CONSTRAINT check_distribuidor_estado
        CHECK (status_distributor IN ('ACTIVO', 'INACTIVO'));


--se crear constraint para la tabla pagos
ALTER TABLE contabilidad_cerdos.Pagos
    ADD CONSTRAINT check_distribuidor_empleado
        CHECK (distribuidor_id IS NOT NULL OR empleado_id IS NOT NULL);
