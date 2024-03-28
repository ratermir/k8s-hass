-- Table: public.pwpl_events

-- DROP TABLE IF EXISTS public.pwpl_events;

CREATE TABLE IF NOT EXISTS public.pwpl_events
(
    event_time timestamp without time zone NOT NULL,
    installation_id smallint,
    system_id smallint,
    inv_out_volt double precision,
    inv_out_watt_act double precision,
    inv_out_watt_app double precision,
    inv_out_load_perc double precision,
    inv_out_hz double precision,
    inv_in_volt double precision,
    inv_in_amp double precision,
    inv_in_hz double precision,
    inv_out_src character(1) COLLATE pg_catalog."default",
    batt_volt double precision,
    batt_ctrl_volt double precision,
    batt_amp double precision,
    plnt_amp double precision,
    plnt_volt double precision,
    plnt_watt double precision,
    CONSTRAINT pwpl_events_installation_id_fkey FOREIGN KEY (installation_id)
        REFERENCES public.pwpl_installations (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT pwpl_events_system_id_fkey FOREIGN KEY (system_id)
        REFERENCES public.pwpl_systems (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.pwpl_events
    OWNER to hass;
-- Index: pwpl_events_event_time_idx

-- DROP INDEX IF EXISTS public.pwpl_events_event_time_idx;

CREATE INDEX IF NOT EXISTS pwpl_events_event_time_idx
    ON public.pwpl_events USING btree
    (event_time DESC NULLS FIRST)
    TABLESPACE pg_default;

-- Trigger: ts_insert_blocker

-- DROP TRIGGER IF EXISTS ts_insert_blocker ON public.pwpl_events;

CREATE OR REPLACE TRIGGER ts_insert_blocker
    BEFORE INSERT
    ON public.pwpl_events
    FOR EACH ROW
    EXECUTE FUNCTION _timescaledb_internal.insert_blocker();
