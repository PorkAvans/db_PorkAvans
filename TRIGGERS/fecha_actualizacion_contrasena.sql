CREATE OR REPLACE FUNCTION contabilidad_cerdos.actualizar_password_update_date()
    RETURNS TRIGGER AS
$$
BEGIN
    SET TIME ZONE 'America/Bogota';

    -- Verifica si la contraseña ha sido cambiada
    IF NEW.user_password IS DISTINCT FROM OLD.user_password THEN
        -- Actualiza el campo de la fecha de cambio de contraseña
        NEW.password_update_date := NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para ejecutar el procedimiento almacenado
CREATE TRIGGER actualizar_password_update_date_trigger
    BEFORE UPDATE
    ON contabilidad_cerdos.users
    FOR EACH ROW
    WHEN (OLD.user_password IS DISTINCT FROM NEW.user_password)
EXECUTE FUNCTION contabilidad_cerdos.actualizar_password_update_date();
