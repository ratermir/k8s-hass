-- Table: public.pwpl_setup

-- DROP TABLE IF EXISTS public.pwpl_setup;

CREATE TABLE IF NOT EXISTS public.pwpl_setup
(
    key character(32) COLLATE pg_catalog."default" NOT NULL,
    value character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT pwpl_setup_pkey PRIMARY KEY (key)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.pwpl_setup
    OWNER to hass;
