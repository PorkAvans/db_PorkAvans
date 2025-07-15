CREATE
OR REPLACE FUNCTION contabilidad_cerdos.verificar_capacidad_corral()
RETURNS TRIGGER AS $$
DECLARE
cantidad_actual INT;
    capacidad_maxima
INT;
BEGIN
    -- Contar cuántos animales hay actualmente en ese corral
SELECT COUNT(*)
INTO cantidad_actual
FROM contabilidad_cerdos.animal
WHERE corral_id = NEW.corral_id;

-- Obtener la capacidad máxima del corral
SELECT corral_capacidad
INTO capacidad_maxima
FROM contabilidad_cerdos.corral
WHERE corral_id = NEW.corral_id;

-- Verificar si ya se alcanzó o superó la capacidad
IF
cantidad_actual >= capacidad_maxima THEN
        RAISE EXCEPTION 'El corral % ya alcanzó su capacidad máxima de % animales.',
            NEW.corral_id, capacidad_maxima;
END IF;

RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_capacidad
    BEFORE INSERT OR
UPDATE ON contabilidad_cerdos.animal
    FOR EACH ROW
    EXECUTE FUNCTION contabilidad_cerdos.verificar_capacidad_corral();
