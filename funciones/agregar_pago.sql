CREATE OR REPLACE FUNCTION contabilidad_cerdos.agregar_pago(
    in_user TEXT,
    in_distribuidor_id TEXT, -- identificador único del restaurante
    in_fecha_pago TEXT, -- fecha del pago
    in_monto_total TEXT -- monto total del pago
)
    RETURNS TABLE
            (
                out_codigo_distribuidor TEXT,
                out_mensaje_salida   TEXT
            )
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    codigo_error       TEXT;
    mensaje_error      TEXT;
    success_code       TEXT DEFAULT 'M0001';
    success_message    TEXT;
    error_code_checked VARCHAR(20) DEFAULT 'D0001'; -- Variable para asignar código de error controlado
BEGIN
    -- Validaciones de campos vacíos
    IF in_user IS NULL OR in_user = '' THEN
        RAISE EXCEPTION 'El usuario no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_distribuidor_id IS NULL OR in_distribuidor_id = '' THEN
        RAISE EXCEPTION 'El ID del distribuidor no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_fecha_pago IS NULL OR in_fecha_pago = '' THEN
        RAISE EXCEPTION 'La fecha no puede ir vacía' USING ERRCODE = error_code_checked;
    END IF;

    IF in_monto_total IS NULL OR in_monto_total = '' THEN
        RAISE EXCEPTION 'El monto no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM contabilidad_cerdos.users WHERE user_nombre = in_user) THEN
        RAISE EXCEPTION 'El usuario "%s" no se encuentra en la base de datos', in_user USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el distribuidor exista
    IF NOT EXISTS (SELECT 1
                   FROM contabilidad_cerdos.distributor
                   WHERE distributor_id = in_distribuidor_id::INT) THEN
        RAISE EXCEPTION 'El distribuidor con el ID "%" no se encuentra en la base de datos', in_distribuidor_id USING ERRCODE = error_code_checked;
    END IF;

    -- Insertar el nuevo pago
    INSERT INTO contabilidad_cerdos.pagos (distribuidor_id, fecha_pago, monto_total, registrado_por)
    VALUES (in_distribuidor_id::INT, in_fecha_pago::DATE, in_monto_total::DOUBLE PRECISION, in_user);

    success_message := 'El pago se registró correctamente';

    RETURN QUERY SELECT success_code, success_message;

EXCEPTION
    WHEN OTHERS THEN
        codigo_error := SQLSTATE;
        mensaje_error := SQLERRM;
        RETURN QUERY SELECT codigo_error, mensaje_error;
END;
$$;
