CREATE OR REPLACE VIEW vw_experiment AS
 SELECT e.protocol_id,
    e.id,
    e.code_name,
    e.ls_type,
    e.ls_kind,
    el.label_text AS experiment_name
   FROM experiment e
     JOIN experiment_label el ON e.id = el.experiment_id AND el.ls_type::text = 'name'::text AND el.ls_kind::text = 'experiment name'::text AND el.preferred = '1'
  WHERE e.ignored = false AND el.ignored = false;
 
 
CREATE OR REPLACE VIEW vw_expt_tested_lots AS
 SELECT ag.id AS ag_id,
    p.id AS protocol_id,
    p.code_name AS protocol_code,
    e.id AS experiment_id,
    e.code_name AS experiment_code,
    el.label_text AS experiment_name,
    el2.label_text AS experiment_corp_name,
    agv2.code_value AS tested_lot
   FROM experiment e
     JOIN experiment_label el ON e.id = el.experiment_id AND el.ls_type::text = 'name'::text AND el.ls_kind::text = 'experiment name'::text AND el.ignored = false
     LEFT JOIN experiment_label el2 ON e.id = el2.experiment_id AND el2.ls_type::text = 'name'::text AND el2.ls_kind::text = 'experiment corp name'::text AND el2.ignored = false
     JOIN protocol p ON e.protocol_id = p.id
     JOIN experiment_analysisgroup eag ON e.id = eag.experiment_id
     JOIN analysis_group ag ON eag.analysis_group_id = ag.id
     JOIN analysis_group_state ags ON ags.analysis_group_id = ag.id
     JOIN analysis_group_value agv2 ON agv2.analysis_state_id = ags.id AND agv2.ls_kind::text = 'batch code'::text
  WHERE p.ignored = false AND e.ignored = false AND ag.ignored = false AND ags.ignored = false AND agv2.ignored = false
  GROUP BY ag.id, p.id, p.code_name, e.id, e.code_name, el.label_text, el2.label_text, agv2.code_value;

CREATE OR REPLACE VIEW vw_expt_columns AS
 SELECT DISTINCT e.id AS experiment_id,
    e.protocol_id,
    e.code_name AS experiment_code_name,
    ev1.numeric_value AS column_order,
    ev5.string_value AS column_type,
    ev2.string_value AS column_name,
    ev10.string_value AS column_units,
    ev3.string_value AS column_condition,
    ev4.string_value AS column_hide,
    ev6.numeric_value AS column_concentration,
    ev7.string_value AS column_conc_units,
    ev8.numeric_value AS column_time,
    ev9.string_value AS column_time_units
   FROM experiment e
     LEFT JOIN experiment_state es ON e.id = es.experiment_id AND es.ls_type::text = 'metadata'::text AND es.ls_kind::text = 'data column order'::text
     LEFT JOIN experiment_value ev1 ON es.id = ev1.experiment_state_id AND ev1.ls_type::text = 'numericValue'::text AND ev1.ls_kind::text = 'column order'::text AND ev1.ignored <> true
     LEFT JOIN experiment_value ev5 ON es.id = ev5.experiment_state_id AND ev5.ls_type::text = 'stringValue'::text AND ev5.ls_kind::text = 'column type'::text AND ev5.ignored <> true
     LEFT JOIN experiment_value ev2 ON es.id = ev2.experiment_state_id AND ev2.ls_type::text = 'stringValue'::text AND ev2.ls_kind::text = 'column name'::text AND ev2.ignored <> true
     LEFT JOIN experiment_value ev3 ON es.id = ev3.experiment_state_id AND ev3.ls_type::text = 'stringValue'::text AND ev3.ls_kind::text = 'condition column'::text AND ev3.ignored <> true
     LEFT JOIN experiment_value ev4 ON es.id = ev4.experiment_state_id AND ev4.ls_type::text = 'stringValue'::text AND ev4.ls_kind::text = 'hide column'::text AND ev4.ignored <> true
     LEFT JOIN experiment_value ev6 ON es.id = ev6.experiment_state_id AND ev6.ls_type::text = 'numericValue'::text AND ev6.ls_kind::text = 'column concentration'::text AND ev6.ignored <> true
     LEFT JOIN experiment_value ev7 ON es.id = ev7.experiment_state_id AND ev7.ls_type::text = 'stringValue'::text AND ev7.ls_kind::text = 'column conc units'::text AND ev7.ignored <> true
     LEFT JOIN experiment_value ev8 ON es.id = ev8.experiment_state_id AND ev8.ls_type::text = 'numericValue'::text AND ev8.ls_kind::text = 'column time'::text AND ev8.ignored <> true
     LEFT JOIN experiment_value ev9 ON es.id = ev9.experiment_state_id AND ev9.ls_type::text = 'stringValue'::text AND ev9.ls_kind::text = 'column time units'::text AND ev9.ignored <> true
     LEFT JOIN experiment_value ev10 ON es.id = ev10.experiment_state_id AND ev10.ls_type::text = 'stringValue'::text AND ev10.ls_kind::text = 'column units'::text AND ev10.ignored <> true
  WHERE es.ignored = false
  ORDER BY e.id, ev1.numeric_value;





  