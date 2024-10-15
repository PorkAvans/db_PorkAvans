CREATE OR REPLACE FUNCTION contabilidad_cerdos.actualizar_inicio_sesion()
    RETURNS TRIGGER AS
$$
BEGIN
    SET TIME ZONE 'America/Bogota';

    -- Si el usuario inicia sesión, actualiza la fecha de inicio de sesión
    IF NEW.logued = TRUE THEN
        NEW.inicio_sesion := NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para ejecutar el procedimiento almacenado
CREATE TRIGGER actualizar_inicio_sesion_trigger
    BEFORE UPDATE
    ON contabilidad_cerdos.users
    FOR EACH ROW
    WHEN (NEW.logued = TRUE)
EXECUTE FUNCTION contabilidad_cerdos.actualizar_inicio_sesion();
