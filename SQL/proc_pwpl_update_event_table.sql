-- PROCEDURE: public.pwpl_update_event_table()

-- DROP PROCEDURE IF EXISTS public.pwpl_update_event_table();

CREATE OR REPLACE PROCEDURE public.pwpl_update_event_table(
    )
LANGUAGE 'sql'
AS $BODY$

    UPDATE pwpl_setup SET value = (select max(last_updated) from states) where key = 'last_updated_to';

    insert into pwpl_events (
      event_time, installation_id, system_id, inv_out_volt, inv_out_watt_act, inv_out_watt_app,
      inv_out_load_perc, inv_out_src, batt_volt, batt_ctrl_volt, 
      --batt_charge_amp, batt_discharge_amp,
      batt_amp, plnt_amp, plnt_volt, plnt_watt
    )
    select 
      a.time_sec as event_time, 
      1 as installation_id,
      1 as system_id,
      (c.attrs->'volt')::float as inv_out_volt,
      (c.attrs->'act_watt')::float as inv_out_watt_act,
      (c.attrs->'app_watt')::float as inv_out_watt_app,
      (c.attrs->'load_perc')::float as inv_out_load_perc,
      (b.attrs->>'out_sourcce')::char(1) as inv_out_src,
      (d.attrs->'volt')::float as batt_volt,
      (d.attrs->'SCC_volt')::float as batt_ctrl_volt,
--	  (d.attrs->'charge_amp')::float as batt_charge_amp,
--	  (d.attrs->'disch_amp')::float as batt_discharge_amp,
      (d.attrs->'amp')::float as batt_amp,
      (e.attrs->'amp')::float as plnt_amp,
      (e.attrs->'volt')::float as plnt_volt,
      (e.attrs->'watt')::float as plnt_watt
    from (
	select distinct date_trunc('seconds', last_updated) as time_sec from states
	where last_updated between (select "value"::timestamp from pwpl_setup where key = 'last_updated_from') and (select value::timestamp from pwpl_setup where key = 'last_updated_to')
    ) as a
    left outer join pwpl_timerange_attrs_vw b on (b.time=a.time_sec and b.entity='sensor.pwpl_power')
    left outer join pwpl_timerange_attrs_vw c on (c.time=a.time_sec and c.entity='sensor.pwpl_out')
    left outer join pwpl_timerange_attrs_vw d on (d.time=a.time_sec and d.entity='sensor.pwpl_batt')
    left outer join pwpl_timerange_attrs_vw e on (e.time=a.time_sec and e.entity='sensor.pwpl_pv') 
    where (c.attrs is not null or d.attrs is not null or d.attrs is not null)
    ;
    UPDATE pwpl_setup SET value = (select value from pwpl_setup where key = 'last_updated_to') where key = 'last_updated_from';
$BODY$;
ALTER PROCEDURE public.pwpl_update_event_table()
    OWNER TO hass;
