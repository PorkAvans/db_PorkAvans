CREATE OR REPLACE FUNCTION contabilidad_cerdos.editar_users(
    in_user_id TEXT, -- identificador único del usuario
    in_user_imagen TEXT, -- imagen del usuario
    in_user_nombre TEXT, -- nombre y apellido del usuario
    in_celular TEXT, -- celular
    in_user_rol TEXT, -- rol (ADMINISTRADOR, EMPLEADO, CLIENTE)
    in_user_estado TEXT -- estado (ACTIVO, INACTIVO)
)
    RETURNS TABLE (
                      out_respon_code TEXT,
                      out_respon_message TEXT
                  )
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    codigo_error          TEXT;
    mensaje_error         TEXT;
    local_user_rol        INT;
    local_user_estado     INT;
    local_message         TEXT;
    local_img_b64         BOOLEAN DEFAULT FALSE;
    success_code          TEXT DEFAULT '200';
    success_message       TEXT;
    error_code_checked    VARCHAR(20) DEFAULT 'D0001'; -- Variable para asignar código de error controlado
BEGIN
    -- Validaciones de campos vacíos
    IF in_user_id IS NULL OR in_user_id = '' THEN
        RAISE EXCEPTION 'El user_id no puede ir vacio' USING ERRCODE = error_code_checked;
    END IF;

    IF in_user_imagen IS NULL OR in_user_imagen = '' THEN
        RAISE EXCEPTION 'La imagen no puede ir vacio' USING ERRCODE = error_code_checked;
    END IF;

    IF in_user_nombre IS NULL OR in_user_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ir vacio' USING ERRCODE = error_code_checked;
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

    -- Validar que la imagen venga en base64
    SELECT contabilidad_cerdos.is_valid_base64(in_user_imagen)
    INTO local_img_b64;



    IF local_img_b64 IS FALSE THEN
        RAISE EXCEPTION 'La imagen debe estar en formato base64' USING ERRCODE = error_code_checked;
    END IF;

    -- Validar que el usuario existe
    IF NOT EXISTS(SELECT 1 FROM contabilidad_cerdos.users WHERE user_id = in_user_id) THEN
        RAISE EXCEPTION 'El usuario no existe en la base de datos' USING ERRCODE = error_code_checked;
    END IF;

    -- Validar el rol
    SELECT user_rol_id
    INTO local_user_rol
    FROM contabilidad_cerdos.users_rol
    WHERE rol = in_user_rol;

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

    -- Realizar la actualización
    UPDATE contabilidad_cerdos.users
    SET user_imagen = decode(in_user_imagen,'base64'),
        user_nombre = in_user_nombre,
        celular     = in_celular,
        user_rol    = local_user_rol,
        user_estado = local_user_estado
    WHERE user_id = in_user_id;

    success_message := 'El usuario "' || in_user_nombre || '" fue editado correctamente';

    RETURN QUERY SELECT success_code, success_message;

EXCEPTION
    WHEN OTHERS THEN
        codigo_error := SQLSTATE;
        mensaje_error := SQLERRM;
        RETURN QUERY SELECT codigo_error, mensaje_error;
END;
$$;
