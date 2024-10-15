CREATE OR REPLACE FUNCTION contabilidad_cerdos.is_valid_base64(input_imagen TEXT)
    RETURNS BOOLEAN AS
$$
DECLARE
    encoded_text BYTEA;
BEGIN
    -- Intenta decodificar la cadena base64
    encoded_text := decode(input_imagen, 'base64');
    -- Si la decodificación es exitosa, la cadena está en formato base64 válido
    RETURN TRUE;
EXCEPTION
    -- Si la decodificación falla, la cadena no está en formato base64 válido
    WHEN others THEN
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;
