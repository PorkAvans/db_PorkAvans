CREATE OR REPLACE FUNCTION contabilidad_cerdos.agregar_distribuidor(
    in_distribuidor_nombre TEXT,
    in_distribuidor_direccion TEXT,
    in_distribuidor_telefono TEXT,
    in_distribuidor_imagen TEXT,
    in_distribuidor_estado_recoleccion_id TEXT,
    in_distribuidor_recoleccion_id TEXT
)
    RETURNS TABLE
            (
                out_codigo_respuesta TEXT,
                out_mensaje_salida   TEXT
            )
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    codigo_error       TEXT;
    mensaje_error      TEXT;
    success_code       TEXT DEFAULT '0000';
    success_message    TEXT;
    error_code_checked VARCHAR(20) DEFAULT 'D0001'; -- Variable para asignar código de error controlado
BEGIN
    -- Validaciones de campos vacíos
    IF in_distribuidor_nombre IS NULL OR in_distribuidor_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_distribuidor_estado_recoleccion_id IS NULL OR in_distribuidor_estado_recoleccion_id = '' THEN
        RAISE EXCEPTION 'El ID de estado de recolección no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_distribuidor_telefono IS NULL OR in_distribuidor_telefono = '' THEN
        RAISE EXCEPTION 'El teléfono no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_distribuidor_recoleccion_id IS NULL OR in_distribuidor_recoleccion_id = '' THEN
        RAISE EXCEPTION 'El ID de recolección no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el nombre del distribuidor no se repita
    IF EXISTS (SELECT 1 FROM contabilidad_cerdos.distributor WHERE distributor_name = in_distribuidor_nombre) THEN
        RAISE EXCEPTION 'El nombre del restaurante "%s" ya existe', in_distribuidor_nombre USING ERRCODE = error_code_checked;
    END IF;

    -- Validar que el estado de recolección exista
    IF NOT EXISTS (SELECT 1
                   FROM contabilidad_cerdos.status_collection
                   WHERE status_collection_id = in_distribuidor_estado_recoleccion_id::INT) THEN
        RAISE EXCEPTION 'El estado de recolección del restaurante no existe' USING ERRCODE = error_code_checked;
    END IF;

    -- Validar que el ID de recolección exista
    IF NOT EXISTS (SELECT 1
                   FROM contabilidad_cerdos.collection
                   WHERE collection_id = in_distribuidor_recoleccion_id::INT) THEN
        RAISE EXCEPTION 'El campo in_distribuidor_recoleccion_id no existe en la base de datos' USING ERRCODE = error_code_checked;
    END IF;

    -- Insertar el nuevo distribuidor
    INSERT INTO contabilidad_cerdos.distributor (distributor_name, distributor_address, status_collection_id,
                                                 collection_id,
                                                 cell_phone, register_date, image)
    VALUES (in_distribuidor_nombre, in_distribuidor_direccion, in_distribuidor_estado_recoleccion_id::INT,
            in_distribuidor_recoleccion_id::INT, in_distribuidor_telefono, CURRENT_TIMESTAMP, in_distribuidor_imagen);

    success_message := 'El Restaurante "' || in_distribuidor_nombre || '" fue agregado correctamente';

    RETURN QUERY SELECT success_code, success_message;

EXCEPTION
    WHEN OTHERS THEN
        codigo_error := SQLSTATE;
        mensaje_error := SQLERRM;
        RETURN QUERY SELECT codigo_error, mensaje_error;
END;
$$;
