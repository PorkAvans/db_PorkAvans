CREATE
    OR REPLACE FUNCTION contabilidad_cerdos.actualizar_monto_total_deuda_restaurante()
    RETURNS TRIGGER AS
$$

    -------------------------------------------------------------
        --objetivo: actualizar el monto de la deuda de distribuidores
    -------------------------------------------------------------
DECLARE
    local_precio_producto  numeric;
    local_deuda_a_sumar DOUBLE PRECISION;
BEGIN

    SELECT pb.Price
    INTO local_precio_producto
    FROM contabilidad_cerdos.products b
             INNER JOIN contabilidad_cerdos.product_price pb ON b.product_price_id = pb.product_price_id
    WHERE b.product_id = NEW.product_id;

    local_deuda_a_sumar := (NEW.product_quantity * local_precio_producto);

    IF EXISTS (SELECT 1 FROM contabilidad_cerdos.distributor_debt WHERE distributor_id = NEW.distributor_id) THEN

        UPDATE contabilidad_cerdos.distributor_debt AS dr
        SET total_debt = total_debt + local_deuda_a_sumar
        WHERE distributor_id = NEW.distributor_id;
    ELSE
        INSERT INTO contabilidad_cerdos.distributor_debt (distributor_id, total_debt)
        VALUES (NEW.distributor_id, local_deuda_a_sumar);

    END IF;
    RETURN NEW;

END;
$$
    LANGUAGE plpgsql;

-- Crear el trigger para el procedimiento actualizar_monto_total_deuda_restaurante
CREATE  TRIGGER actualizacion_monto_total_deuda
    BEFORE INSERT
    ON contabilidad_cerdos.product_collected
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.actualizar_monto_total_deuda_restaurante();