-- FUNCTION: public.states_bi_trg()

-- DROP FUNCTION IF EXISTS public.states_bi_trg();

CREATE OR REPLACE FUNCTION public.states_bi_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  NEW.time_sec=date_trunc('second', NEW.last_updated);
  return NEW;
END;
$BODY$;

ALTER FUNCTION public.states_bi_trg()
    OWNER TO hass;
