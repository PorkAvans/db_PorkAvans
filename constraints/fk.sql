--se crea contraint para comida_recolectada
ALTER TABLE contabilidad_cerdos.product_collected
    ADD CONSTRAINT fk_restaurante_id
        FOREIGN KEY (distributor_id) REFERENCES contabilidad_cerdos.distributor (distributor_id);

--se crea constraint para tipo distribuidor
ALTER TABLE contabilidad_cerdos.distributor
    ADD CONSTRAINT fk_tipe_distribuidor
        FOREIGN KEY (type_distributor) REFERENCES contabilidad_cerdos.distributor_type (distributor_type_id);

--se crea constraint para comida_recolectada
ALTER TABLE contabilidad_cerdos.product_collected
    ADD CONSTRAINT fk_producto_id
        FOREIGN KEY (product_id) REFERENCES contabilidad_cerdos.products (product_id);

--se crea constraint para Pagos
ALTER TABLE contabilidad_cerdos.Pagos
    ADD CONSTRAINT fk_restaurante_id_pago
        FOREIGN KEY (distribuidor_id) REFERENCES contabilidad_cerdos.distributor (distributor_id);

--se crea constraint para usuarios
ALTER TABLE contabilidad_cerdos.users
    ADD CONSTRAINT fk_user_id_rol
        FOREIGN KEY (user_rol) REFERENCES contabilidad_cerdos.users_rol (user_rol_id);

--se crea constraint para usuarios
ALTER TABLE contabilidad_cerdos.users
    ADD CONSTRAINT fk_user_estado_id
        FOREIGN KEY (user_estado) REFERENCES contabilidad_cerdos.users_estado (user_estado_id);

--se crea constraint para restaurantes
ALTER TABLE contabilidad_cerdos.distributor
    ADD CONSTRAINT fk_distribuidor_estado_id
        FOREIGN KEY (status_collection_id) REFERENCES contabilidad_cerdos.status_collection (status_collection_id);

--se crea constraint para restaurantes
ALTER TABLE contabilidad_cerdos.distributor
    ADD CONSTRAINT fk_Restaurantes_recoleccion_id
        FOREIGN KEY (collection_id) REFERENCES contabilidad_cerdos.collection (collection_id);

--se crea constraint para Deudas_restaurante
ALTER TABLE contabilidad_cerdos.distributor_debt
    ADD CONSTRAINT fk_Deudas_distribuidor_id
        FOREIGN KEY (distributor_id) REFERENCES contabilidad_cerdos.distributor (distributor_id);

--se crea constraint para comida_suministrada
ALTER TABLE contabilidad_cerdos.comida_suministrada
    ADD CONSTRAINT fk_comida_suministrada_corral_id
        FOREIGN KEY (comida_suministrada_corral_id) REFERENCES contabilidad_cerdos.corral (corral_id);

--se crea constraint para comida_suministrada
ALTER TABLE contabilidad_cerdos.comida_suministrada
    ADD CONSTRAINT fk_comida_suministrada_balde_id
        FOREIGN KEY (comida_suministrada_producto_id) REFERENCES contabilidad_cerdos.products (product_id);

--se crea constraint para precio
ALTER TABLE contabilidad_cerdos.products
    ADD CONSTRAINT fk_precio_id
        FOREIGN KEY (product_price_id) REFERENCES contabilidad_cerdos.product_price (product_price_id);

--se crea constraint para tipo_producto
ALTER TABLE contabilidad_cerdos.products
    ADD CONSTRAINT fk_tipo_producto_id
        FOREIGN KEY (product_type_id) REFERENCES contabilidad_cerdos.product_type (product_type_id);

--se crea constraint para pagos
ALTER TABLE contabilidad_cerdos.pagos
    ADD CONSTRAINT fk_empleado_id
        FOREIGN KEY (empleado_id) REFERENCES contabilidad_cerdos.users (user_id);

--se crea contrains de llave foranea para la tabla stock_productos
ALTER TABLE contabilidad_cerdos.stock_productos
    ADD CONSTRAINT fk_producto
        FOREIGN KEY (producto_id) REFERENCES contabilidad_cerdos.products (product_id);

-- establecer la relación entre Categoria_Costo y Tipos_Costos
ALTER TABLE contabilidad_cerdos.categoria_costo
    ADD CONSTRAINT fk_tipo_costo
        FOREIGN KEY (tipo_costo_id) REFERENCES contabilidad_cerdos.tipos_costos (tipo_costo_id);


--se crea contrains de llave foranea para la tabla Costos_Produccion
ALTER TABLE contabilidad_cerdos.costos_produccion
    ADD CONSTRAINT fk_producto_recolectado_id FOREIGN KEY (producto_recolectado_id) REFERENCES contabilidad_cerdos.product_collected (product_collected_id),
    ADD CONSTRAINT fk_corral_id FOREIGN KEY (corral_id) REFERENCES contabilidad_cerdos.corral (corral_id),
    ADD CONSTRAINT fk_empleado_id FOREIGN KEY (empleado_id) REFERENCES contabilidad_cerdos.users (user_id),
    ADD CONSTRAINT fk_categoria_costo
        FOREIGN KEY (categoria_costo_id) REFERENCES contabilidad_cerdos.categoria_costo (categoria_costo_id);

-- establecer la relación entre PRODUCTOS_CORRAL y PRODUCTOS
ALTER TABLE contabilidad_cerdos.productos_corral
    ADD CONSTRAINT fk_productos_corral
        FOREIGN KEY (producto_id) REFERENCES contabilidad_cerdos.products (product_id),
    ADD CONSTRAINT fk_productos_corral_corral
        FOREIGN KEY (corral_id) REFERENCES contabilidad_cerdos.corral (corral_id);

-- establecer la relación entre medicamento_animal y PRODUCTOS
ALTER TABLE contabilidad_cerdos.medicamento_animal
    ADD CONSTRAINT fk_medicamento_animal
        FOREIGN KEY (medicamento_animal_id) REFERENCES contabilidad_cerdos.products (product_id),
    ADD CONSTRAINT fk_medicamento_animal_animal
        FOREIGN KEY (animal_id) REFERENCES contabilidad_cerdos.animal (animal_id);

-- establecer la relación entre animal y corral
ALTER TABLE contabilidad_cerdos.animal
    ADD CONSTRAINT fk_animal_corral
        FOREIGN KEY (corral_id) REFERENCES contabilidad_cerdos.corral (corral_id);

-- establecer la relación entre categpria de producto y productos de venta
ALTER TABLE contabilidad_cerdos.products_sale
    ADD CONSTRAINT fk_product_category
        FOREIGN KEY (category) REFERENCES contabilidad_cerdos.product_category_sale (product_category_sale_id);

-- establecer la relación entre tipo de comision y comision
ALTER TABLE contabilidad_cerdos.commissions
    ADD CONSTRAINT fk_commissions_type
        FOREIGN KEY (commission_type) REFERENCES contabilidad_cerdos.commission_type (commission_type_id);

-- establecer la relación entre associate_commissions y asociado
ALTER TABLE contabilidad_cerdos.associate_commissions
    ADD CONSTRAINT fk_associate_commissions_associate
        FOREIGN KEY (associate_id) REFERENCES contabilidad_cerdos.users (user_id);

-- establecer la relación entre associate_commissions Y product_sale
ALTER TABLE contabilidad_cerdos.associate_commissions
    ADD CONSTRAINT fk_associate_commissions_product_sale
        FOREIGN KEY (product_id) REFERENCES contabilidad_cerdos.products_sale (product_sale_id);

--establecer la relacion entre la tabal de ventas y asociados y productos
ALTER TABLE contabilidad_cerdos.ventas
    ADD CONSTRAINT fk_asociado
        FOREIGN KEY (asociado_id) REFERENCES contabilidad_cerdos.users (user_id);

ALTER TABLE contabilidad_cerdos.ventas
    ADD CONSTRAINT fk_producto
        FOREIGN KEY (producto_id) REFERENCES contabilidad_cerdos.products_sale (product_sale_id);

--establecer la relacion entre la tabla de product_sale y commission
ALTER TABLE contabilidad_cerdos.products_sale
    ADD CONSTRAINT fk_commission
        FOREIGN KEY (commission_id) REFERENCES contabilidad_cerdos.commissions (commission_id);


--establecer la relacion entre la tabal de pre_ventas y asociados y productos
ALTER TABLE contabilidad_cerdos.pre_ventas
    ADD CONSTRAINT fk_asociado_pre_vente
        FOREIGN KEY (pre_venta_asociado_id) REFERENCES contabilidad_cerdos.users (user_id);

ALTER TABLE contabilidad_cerdos.pre_ventas
    ADD CONSTRAINT fk_producto_pre_venta
        FOREIGN KEY (pre_venta_producto_id) REFERENCES contabilidad_cerdos.products_sale (product_sale_id);
