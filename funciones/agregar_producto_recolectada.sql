CREATE OR REPLACE FUNCTION contabilidad_cerdos.agregar_producto_recolectada(
    in_user TEXT,
    in_distribuidor_nombre TEXT,
    in_fecha_recoleccion TEXT,
    in_cantidad_producto TEXT,
    in_producto_id TEXT
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
    codigo_error          TEXT;
    mensaje_error         TEXT;
    local_distribuidor_id INT;
    success_code          TEXT DEFAULT 'M0001';
    success_message       TEXT;
    error_code_checked    VARCHAR(20) DEFAULT 'D0001';
BEGIN
    -- Validaciones de entrada
    IF in_user IS NULL OR in_user = '' THEN
        RAISE EXCEPTION 'El usuario no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_distribuidor_nombre IS NULL OR in_distribuidor_nombre = '' THEN
        RAISE EXCEPTION 'El nombre del distribuidor no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_fecha_recoleccion IS NULL THEN
        RAISE EXCEPTION 'La fecha no puede ir vacía' USING ERRCODE = error_code_checked;
    END IF;

    IF in_cantidad_producto IS NULL OR in_cantidad_producto = '' THEN
        RAISE EXCEPTION 'La cantidad de baldes no puede ir vacía' USING ERRCODE = error_code_checked;
    END IF;

    IF in_producto_id IS NULL OR in_producto_id = '' THEN
        RAISE EXCEPTION 'El ID del producto no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM contabilidad_cerdos.users WHERE user_id = in_user) THEN
        RAISE EXCEPTION 'El usuario "%" no se encuentra en la base de datos', in_user USING ERRCODE = error_code_checked;
    END IF;

    -- Obtener distribuidor_id
    SELECT distributor_id
    INTO local_distribuidor_id
    FROM contabilidad_cerdos.distributor
    WHERE distributor_name = in_distribuidor_nombre;

    -- Validación que el distribuidor exista
    IF local_distribuidor_id IS NULL THEN
        RAISE EXCEPTION 'El distribuidor con el nombre "%" no se encuentra en la base de datos', in_distribuidor_nombre USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el ID del producto exista
    IF NOT EXISTS (SELECT 1 FROM contabilidad_cerdos.products WHERE product_id = in_producto_id::INT) THEN
        RAISE EXCEPTION 'El producto con el ID "%" no se encuentra en la base de datos', in_producto_id USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el restaurante no tenga registros para el mismo día
    IF EXISTS (SELECT 1
               FROM contabilidad_cerdos.product_collected p
                        INNER JOIN contabilidad_cerdos.distributor_type td
                                   ON p.distributor_id = td.distributor_type_id
               WHERE p.distributor_id = local_distribuidor_id::INT
                 AND p.pickup_date = in_fecha_recoleccion::DATE
                 AND td.description = 'RESTAURANTE'
               LIMIT 1) THEN
        RAISE EXCEPTION 'El restaurante "%" ya tiene comida registrada para el día de hoy', in_distribuidor_nombre USING ERRCODE = error_code_checked;
    END IF;

    -- Insertar el nuevo registro
    INSERT INTO contabilidad_cerdos.product_collected (distributor_id, pickup_date, product_quantity,
                                                       product_id, registered_by)
    VALUES (local_distribuidor_id::INT, in_fecha_recoleccion::DATE, in_cantidad_producto::DOUBLE PRECISION,
            in_producto_id::INT, in_user);

    success_message := 'Su recolección en el restaurante fue agregado correctamente';

    RETURN QUERY SELECT success_code, success_message;

EXCEPTION
    WHEN OTHERS THEN
        codigo_error := SQLSTATE;
        mensaje_error := SQLERRM;
        RETURN QUERY SELECT codigo_error, mensaje_error;
END;
$$;
