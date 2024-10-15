CREATE OR REPLACE FUNCTION contabilidad_cerdos.actualizar_deudas_con_pago()
    RETURNS TRIGGER AS

$$
    -- Obtener el monto total y la cantidad de baldes pagados del nuevo registro de Pagos
DECLARE
    monto_pago NUMERIC(10, 2);
BEGIN

    -- Obtener el monto total del nuevo registro de Pagos
    monto_pago := NEW.Monto_total;

    -- Verificar si el monto pagado es mayor que el monto total de la deuda
    IF monto_pago > (SELECT total_debt
                     FROM contabilidad_cerdos.distributor_debt
                     WHERE distributor_id = NEW.distribuidor_id) THEN
        RAISE EXCEPTION 'El monto pagado es mayor que el monto total de la deuda';
    END IF;

    SELECT NEW.Monto_total
    INTO monto_pago;

-- Actualizar la tabla Deudas_restaurante restando el monto total y la cantidad de baldes pagados
    UPDATE contabilidad_cerdos.distributor_debt AS dr
    SET total_debt = total_debt - monto_pago
    WHERE distributor_id = NEW.distribuidor_id;

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER actualizacion_deudas_con_pago
    AFTER INSERT OR DELETE
    ON contabilidad_cerdos.Pagos
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.actualizar_deudas_con_pago();


