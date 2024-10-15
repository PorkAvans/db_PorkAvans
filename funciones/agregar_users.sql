CREATE OR REPLACE FUNCTION contabilidad_cerdos.agregar_users(
    in_user_nombre TEXT,
    in_user_password TEXT,
    in_celular TEXT,
    in_user_rol TEXT,
    in_user_estado TEXT
)
    RETURNS TABLE (
                      out_codigo_respuesta TEXT,
                      out_mensaje_salida   TEXT
                  )
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    codigo_error         TEXT;
    mensaje_error        TEXT;
    local_user_rol       INT;
    local_user_estado    INT;
    success_code         TEXT DEFAULT 'D0000';
    success_message      TEXT;
    error_code_checked   VARCHAR(20) DEFAULT 'D0001'; -- Variable para asignar código de error controlado
BEGIN
    -- Validación de entrada
    IF in_user_nombre IS NULL OR in_user_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ir vacio' USING ERRCODE = error_code_checked;
    END IF;

    IF in_user_password IS NULL OR in_user_password = '' THEN
        RAISE EXCEPTION 'La contraseña no puede ir vacio' USING ERRCODE = error_code_checked;
    END IF;

    IF in_celular IS NULL OR in_celular = '' THEN
        RAISE EXCEPTION 'El celular no puede ir vacio' USING ERRCODE = error_code_checked;
    END IF;

    IF in_user_rol IS NULL OR in_user_rol = '' THEN
        RAISE EXCEPTION 'El rol no puede ir vacio' USING ERRCODE = error_code_checked;
    END IF;

    IF in_user_estado IS NULL OR in_user_estado = '' THEN
        RAISE EXCEPTION 'El estado no puede ir vacio' USING ERRCODE = error_code_checked;
    END IF;

    -- Validación de contraseña
    IF NOT in_user_password ~ '^[A-Z][a-z]+[0-9]$' THEN
        RAISE EXCEPTION 'La contraseña debe comenzar con una letra mayúscula, seguida de letras minúsculas y finalizar con un número.' USING ERRCODE = error_code_checked;
    END IF;

    -- Validar el rol
    SELECT user_rol_id
    INTO local_user_rol
    FROM contabilidad_cerdos.users_rol
    WHERE user_rol_id = in_user_rol::INT;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El rol no existe en la base de datos' USING ERRCODE = error_code_checked;
    END IF;

    -- Validar el estado
    SELECT user_estado_id
    INTO local_user_estado
    FROM contabilidad_cerdos.users_estado
    WHERE estado = in_user_estado;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El estado no existe en la base de datos' USING ERRCODE = error_code_checked;
    END IF;

    -- Insertar el usuario
    INSERT INTO contabilidad_cerdos.users (user_nombre, user_password, celular, user_rol, user_estado)
    VALUES (in_user_nombre, in_user_password, in_celular, local_user_rol, local_user_estado);

    success_message := 'El usuario "' || in_user_nombre || '" fue agregado correctamente';

    RETURN QUERY SELECT success_code, success_message;

EXCEPTION
    WHEN OTHERS THEN
        codigo_error := SQLSTATE;
        mensaje_error := SQLERRM;
        RETURN QUERY SELECT codigo_error, mensaje_error;
END;
$$;
