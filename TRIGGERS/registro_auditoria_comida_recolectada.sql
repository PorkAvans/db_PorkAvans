CREATE OR REPLACE FUNCTION contabilidad_cerdos.registro_auditoria_comida_recolectada()
    RETURNS TRIGGER AS
$$
DECLARE
    previous_parameters JSON;
    new_parameters      JSON;
BEGIN
    SET TIME ZONE 'America/Bogota';

    IF TG_OP = 'INSERT' THEN
        INSERT INTO contabilidad_cerdos.audit (affected_table, exchange_rate, affected_record_id,
                                               previous_parameters, new_parameters, user_modification,
                                               registration_date)
        VALUES (TG_TABLE_NAME, 'INSERT', NEW.product_collected_id, NULL, to_json(NEW), NEW.registered_by,
                CURRENT_TIMESTAMP);
    ELSIF TG_OP = 'UPDATE' THEN
        previous_parameters := to_json(OLD);
        new_parameters := to_json(NEW);

        INSERT INTO contabilidad_cerdos.audit (affected_table, exchange_rate, affected_record_id,
                                               previous_parameters, new_parameters, user_modification,
                                               registration_date)
        VALUES (TG_TABLE_NAME, 'UPDATE', NEW.affected_record_id, previous_parameters, new_parameters,
                NEW.user_modification,
                CURRENT_TIMESTAMP);

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO contabilidad_cerdos.audit (affected_table, exchange_rate, affected_record_id,
                                               previous_parameters, new_parameters, user_modification,
                                               registration_date)
        VALUES (TG_TABLE_NAME, 'DELETE', OLD.affected_record_id, to_json(OLD), NULL, NEW.user_modification,
                CURRENT_TIMESTAMP);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER auditar_comida_recolectada
    AFTER INSERT OR UPDATE OR DELETE
    ON contabilidad_cerdos.product_collected
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.registro_auditoria_comida_recolectada();