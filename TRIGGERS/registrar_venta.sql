CREATE OR REPLACE FUNCTION contabilidad_cerdos.registrar_venta()
    RETURNS TRIGGER AS
$$
DECLARE

    local_commission_type  TEXT;
    local_commission_value NUMERIC DEFAULT 0;
    local_percentage       NUMERIC DEFAULT 0;

BEGIN

    SELECT ct.commission_type_description, c.value
    INTO local_commission_type, local_commission_value
    FROM contabilidad_cerdos.commissions c
             INNER JOIN contabilidad_cerdos.commission_type ct ON c.commission_type = ct.commission_type_id
             INNER JOIN contabilidad_cerdos.products_sale ps on c.commission_id = ps.commission_id
    WHERE ps.product_sale_id = NEW.pre_venta_producto_id;

    local_percentage := local_commission_value / 100;

    IF NEW.estado_pre_venta = 'APROBADA' OR NEW.estado_pre_venta = 'RECHAZADA' THEN
        INSERT INTO contabilidad_cerdos.ventas(asociado_id,
                                               producto_id,
                                               cantidad,
                                               total_venta,
                                               comision_generada,
                                               imagen_de_venta,
                                               estado_venta,
                                               observacion_venta)
        VALUES (NEW.pre_venta_asociado_id, NEW.pre_venta_producto_id, NEW.pre_venta_cantidad, NEW.total_pre_venta,
                CASE
                    WHEN local_commission_type = 'FIJO' THEN
                        local_commission_value * NEW.pre_venta_cantidad::INT
                    ELSE
                        NEW.total_pre_venta * local_percentage::INT END, NEW.imagen_pre_venta, NEW.estado_pre_venta,
                NEW.observacion_pre_venta);
        IF NEW.estado_pre_venta = 'RECHAZADA' THEN
            UPDATE contabilidad_cerdos.products_sale
            SET quantity = quantity + NEW.pre_venta_cantidad
            WHERE product_sale_id = NEW.pre_venta_producto_id;
        END IF;

        DELETE
        FROM contabilidad_cerdos.pre_ventas
        WHERE pre_venta_id = NEW.pre_venta_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Asociar el trigger a la tabla comida_recolectada
CREATE OR REPLACE TRIGGER registrar_venta
    AFTER UPDATE
    ON contabilidad_cerdos.pre_ventas
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.registrar_venta();
