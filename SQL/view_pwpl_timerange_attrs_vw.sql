-- View: public.pwpl_timerange_attrs_vw

-- DROP VIEW public.pwpl_timerange_attrs_vw;

CREATE OR REPLACE VIEW public.pwpl_timerange_attrs_vw
 AS
 SELECT a.entity_id AS entity,
    date_trunc('second'::text, a.last_updated) AS "time",
    a.state,
    a.last_updated AS time_millis,
    b.shared_attrs::jsonb AS attrs,
    1 AS jedna
   FROM states a
     JOIN state_attributes b ON a.attributes_id = b.attributes_id
  WHERE a.last_updated >= (( SELECT pwpl_setup.value::timestamp without time zone AS value
           FROM pwpl_setup
          WHERE pwpl_setup.key = 'last_updated_from'::bpchar)) AND a.last_updated <= (( SELECT pwpl_setup.value::timestamp without time zone AS value
           FROM pwpl_setup
          WHERE pwpl_setup.key = 'last_updated_to'::bpchar));

ALTER TABLE public.pwpl_timerange_attrs_vw
    OWNER TO hass;

