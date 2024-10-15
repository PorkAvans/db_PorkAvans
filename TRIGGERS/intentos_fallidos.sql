CREATE OR REPLACE FUNCTION contabilidad_cerdos.bloquear_usuario_por_intentos_fallidos()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Si el número de intentos fallidos excede un límite (por ejemplo, 3)
    IF NEW.failed_attempts >= 3 THEN
        -- Cambia el estado del usuario a "bloqueado" (0 = inactivo)
        NEW.user_estado := 2;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para ejecutar el procedimiento almacenado
CREATE TRIGGER bloquear_usuario_trigger
    BEFORE UPDATE
    ON contabilidad_cerdos.users
    FOR EACH ROW
    WHEN (NEW.failed_attempts >= 3)
EXECUTE FUNCTION contabilidad_cerdos.bloquear_usuario_por_intentos_fallidos();
