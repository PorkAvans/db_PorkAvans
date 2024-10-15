--se crear constraint para la tabla user
ALTER TABLE contabilidad_cerdos.users
    ADD CONSTRAINT unique_user_id UNIQUE (user_id),
    ADD CONSTRAINT unique_user_email UNIQUE (user_email);

--se crear constraint para la tabla restaurantes
ALTER TABLE contabilidad_cerdos.distributor
    ADD CONSTRAINT unique_nombre_id UNIQUE (distributor_name);