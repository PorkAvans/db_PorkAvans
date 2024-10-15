CREATE OR REPLACE FUNCTION contabilidad_cerdos.generar_user_id()
    RETURNS TRIGGER AS
$$
DECLARE
    user_id_prefix               TEXT := 'USR';
    iniciales_nombre             TEXT;
    ultimos_tres_digitos_celular TEXT;
    numeros_aleatorios           INT[];
BEGIN
    -- Obtener las iniciales del nombre
    iniciales_nombre := INITCAP(SUBSTRING(NEW.user_nombre, 1, 1)) ||
                        INITCAP(SUBSTRING(SUBSTRING(NEW.user_nombre, strpos(NEW.user_nombre, ' ') + 1), 1, 1)) ||
                        INITCAP(SUBSTRING(SUBSTRING(SUBSTRING(NEW.user_nombre, strpos(NEW.user_nombre, ' ') + 1),
                                                    strpos(SUBSTRING(NEW.user_nombre, strpos(NEW.user_nombre, ' ') + 1),
                                                           ' ') + 1), 1, 1));

    -- Obtener números aleatorios que no se repitan
    SELECT ARRAY(SELECT DISTINCT trunc(random() * 10)::INT
                 FROM generate_series(1, 9))
    INTO numeros_aleatorios;

-- Tomar los primeros tres números de la lista aleatoria
    ultimos_tres_digitos_celular := array_to_string(numeros_aleatorios[1:3], '');

    -- Concatenar las partes para formar el user_id
    NEW.user_id := user_id_prefix || iniciales_nombre || ultimos_tres_digitos_celular;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para ejecutar el procedimiento almacenado
CREATE TRIGGER generar_user_id_trigger
    BEFORE INSERT
    ON contabilidad_cerdos.users
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.generar_user_id();
