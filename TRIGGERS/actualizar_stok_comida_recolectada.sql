CREATE OR REPLACE FUNCTION contabilidad_cerdos.actualizar_stock_producto_recolectado()
    RETURNS TRIGGER AS
$$
DECLARE
    cantidad_producto_recolectado DOUBLE PRECISION;
    cantidad_neta                 DOUBLE PRECISION;
BEGIN


    SELECT (SUM(pr.product_quantity) -
            COALESCE((SELECT SUM(cs.comida_suministrada_cantidad)
                      FROM contabilidad_cerdos.comida_suministrada cs
                      WHERE cs.comida_suministrada_producto_id = pr.product_id), 0)) AS cantidad_neta
    INTO cantidad_neta
    FROM contabilidad_cerdos.product_collected pr
    WHERE pr.product_id = NEW.product_id
    GROUP BY pr.product_id;


    SELECT product_content
    INTO cantidad_producto_recolectado
    FROM contabilidad_cerdos.products
    WHERE product_id = NEW.product_id;
    -- Actualizar la tabla stock_productos
    IF NOT EXISTS(SELECT 1 FROM contabilidad_cerdos.stock_productos WHERE producto_id = NEW.product_id) THEN
        INSERT INTO contabilidad_cerdos.stock_productos(producto_id, cantidad_producto, contenido_neto,
                                                        fecha_ultima_actualizacion)
        VALUES (NEW.product_id, NEW.product_quantity, (NEW.product_quantity * cantidad_producto_recolectado),
                CURRENT_TIMESTAMP);
        RETURN NEW;
    ELSE

        UPDATE contabilidad_cerdos.stock_productos
        SET cantidad_producto          = CASE
                                             WHEN cantidad_producto IS NULL THEN NEW.product_quantity
                                             ELSE cantidad_producto + NEW.product_quantity
            END,
            fecha_ultima_actualizacion = CURRENT_TIMESTAMP,
            contenido_neto             = (cantidad_neta * cantidad_producto_recolectado)
        WHERE producto_id = NEW.product_id;

        RETURN NEW;

    END IF;
END;
$$ LANGUAGE plpgsql;


-- Asociar el trigger a la tabla comida_recolectada
CREATE TRIGGER actualizar_comida_trigger
    AFTER INSERT OR UPDATE
    ON contabilidad_cerdos.product_collected
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.actualizar_stock_producto_recolectado();
