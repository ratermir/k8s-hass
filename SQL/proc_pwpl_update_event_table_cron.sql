-- PROCEDURE: public.pwpl_update_event_table_cron()

-- DROP PROCEDURE IF EXISTS public.pwpl_update_event_table_cron();

CREATE OR REPLACE PROCEDURE public.pwpl_update_event_table_cron(
    )
LANGUAGE 'sql'
AS $BODY$
call pwpl_update_event_table();
--insert into rt_test (dscr) values('from-cron-procedure');
$BODY$;
ALTER PROCEDURE public.pwpl_update_event_table_cron()
    OWNER TO hass;

