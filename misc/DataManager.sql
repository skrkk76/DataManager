--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DataManager; Type: DATABASE; Schema: -; Owner: RDM_ADMIN
--

CREATE DATABASE "DataManager" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252' TABLESPACE = "DataManager";


ALTER DATABASE "DataManager" OWNER TO "RDM_ADMIN";

\connect "DataManager"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: acct_settings; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.acct_settings (
    acct_key_name character varying NOT NULL,
    acct_key_val character varying NOT NULL
);


ALTER TABLE rdm_admin.acct_settings OWNER TO "RDM_ADMIN";

--
-- Name: alarm_history; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.alarm_history (
    oid bigint NOT NULL,
    rm_id character varying(20) NOT NULL,
    serial_id character varying(6) NOT NULL,
    text character varying NOT NULL,
    occured_on timestamp(6) without time zone NOT NULL,
    accepted timestamp(6) without time zone,
    accepted_by character varying(30),
    cleared_on timestamp(6) without time zone,
    stage_number numeric,
    batch_no character varying,
    notify_alarm boolean,
    notify_level1 integer,
    notify_level2 integer,
    muted_on timestamp without time zone,
    muted_by character varying(30),
    last_notified timestamp without time zone
);


ALTER TABLE rdm_admin.alarm_history OWNER TO "RDM_ADMIN";

--
-- Name: alarm_history_oid_seq; Type: SEQUENCE; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE rdm_admin.alarm_history ALTER COLUMN oid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME rdm_admin.alarm_history_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: batch_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.batch_info (
    rm_id character varying(20) NOT NULL,
    batch_no character varying NOT NULL,
    start_dt timestamp(6) without time zone NOT NULL,
    end_dt timestamp(6) without time zone,
    cntrl_type character varying(10) NOT NULL,
    def_val_type character varying
);


ALTER TABLE rdm_admin.batch_info OWNER TO "RDM_ADMIN";

--
-- Name: bunker_def_param_val; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.bunker_def_param_val (
    param_name character varying(50) NOT NULL,
    default_product character varying(10)
);


ALTER TABLE rdm_admin.bunker_def_param_val OWNER TO "RDM_ADMIN";

--
-- Name: cntrl_groups; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.cntrl_groups (
    group_name character varying(20) NOT NULL,
    group_desc character varying(50)
);


ALTER TABLE rdm_admin.cntrl_groups OWNER TO "RDM_ADMIN";

--
-- Name: controller_def_types; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.controller_def_types (
    cntrl_type character varying(15) NOT NULL,
    cntrl_def_type character varying(25) NOT NULL,
    description character varying
);


ALTER TABLE rdm_admin.controller_def_types OWNER TO "RDM_ADMIN";

--
-- Name: controller_params_admin; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.controller_params_admin (
    param_name character varying(50) NOT NULL,
    scale_on_graph numeric(3,0),
    stage_name character varying(15) NOT NULL,
    rooms_overview character varying(1) NOT NULL,
    multirooms_view character varying(1) NOT NULL,
    singleroom_view character varying(1) NOT NULL,
    graph_view character varying(1) NOT NULL,
    helper_read character varying(1) NOT NULL,
    helper_write character varying(1) NOT NULL,
    supervisor_read character varying(1) NOT NULL,
    supervisor_write character varying(1) NOT NULL,
    manager_read character varying(1) NOT NULL,
    manager_write character varying(1) NOT NULL,
    admin_read character varying(1) NOT NULL,
    admin_write character varying(1) NOT NULL,
    param_group character varying(50),
    display_order numeric(3,0),
    param_unit character varying(15),
    cntrl_type character varying(15) NOT NULL,
    on_off_value character varying(1) NOT NULL,
    reset_value character varying(1) NOT NULL
);


ALTER TABLE rdm_admin.controller_params_admin OWNER TO "RDM_ADMIN";

--
-- Name: daily_yield; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.daily_yield (
    rm_id character varying(20) NOT NULL,
    batch_no character varying,
    on_date date NOT NULL,
    daily_yield real,
    logged_by character varying(30),
    est_yield real,
    comments character varying,
    stage_number numeric,
    running_day integer
);


ALTER TABLE rdm_admin.daily_yield OWNER TO "RDM_ADMIN";

--
-- Name: department_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.department_info (
    department_name character varying(15) NOT NULL,
    description character varying(50),
    isactive character(1) NOT NULL,
    edit_params character(1) NOT NULL
);


ALTER TABLE rdm_admin.department_info OWNER TO "RDM_ADMIN";

--
-- Name: employee_in_out; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.employee_in_out (
    oid bigint NOT NULL,
    user_id character varying(20),
    log_in timestamp without time zone,
    log_out timestamp without time zone,
    shift_code character(1) NOT NULL,
    dept_in timestamp without time zone,
    dept_out timestamp without time zone,
    log_date date NOT NULL,
    t_del_qty real,
    productivity real,
    productive_hrs real
);


ALTER TABLE rdm_admin.employee_in_out OWNER TO "RDM_ADMIN";

--
-- Name: employee_in_out_oid_seq; Type: SEQUENCE; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE rdm_admin.employee_in_out ALTER COLUMN oid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME rdm_admin.employee_in_out_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: general_params_admin; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.general_params_admin (
    param_name character varying(50) NOT NULL,
    helper_read character varying(1) NOT NULL,
    helper_write character varying(1) NOT NULL,
    supervisor_read character varying(1) NOT NULL,
    supervisor_write character varying(1) NOT NULL,
    manager_read character varying(1) NOT NULL,
    manager_write character varying(1) NOT NULL,
    admin_read character varying(1) NOT NULL,
    admin_write character varying(1) NOT NULL,
    display_order numeric(3,0),
    param_unit character varying(10),
    cntrl_type character varying(15) NOT NULL,
    graph_view character varying(1) NOT NULL,
    scale_on_graph numeric(3,0) NOT NULL,
    on_off_value character varying(1) NOT NULL
);


ALTER TABLE rdm_admin.general_params_admin OWNER TO "RDM_ADMIN";

--
-- Name: grower_def_param_val; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.grower_def_param_val (
    param_name character varying(50) NOT NULL,
    default_product character varying(10),
    agaricus_bisporus character varying,
    fresh_mushroom character varying
);


ALTER TABLE rdm_admin.grower_def_param_val OWNER TO "RDM_ADMIN";

--
-- Name: list_of_tasks; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.list_of_tasks (
    task_id character(3) NOT NULL,
    task_name character varying(25) NOT NULL,
    task_attributes character varying,
    department_name character varying,
    duration_alert integer,
    productivity_task boolean
);


ALTER TABLE rdm_admin.list_of_tasks OWNER TO "RDM_ADMIN";

--
-- Name: log_history; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.log_history (
    oid bigint NOT NULL,
    rm_id character varying(20) NOT NULL,
    logged_by character varying(30) NOT NULL,
    logged_on timestamp without time zone NOT NULL,
    param_name character varying(50),
    log_text character varying NOT NULL,
    stage_number numeric,
    batch_no character varying
);


ALTER TABLE rdm_admin.log_history OWNER TO "RDM_ADMIN";

--
-- Name: log_history_oid_seq; Type: SEQUENCE; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE rdm_admin.log_history ALTER COLUMN oid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME rdm_admin.log_history_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notify_alarms; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.notify_alarms (
    alarm character varying NOT NULL,
    notify_by character varying NOT NULL,
    notify_first character varying NOT NULL,
    notify_second character varying,
    level1_duration integer NOT NULL,
    level2_duration integer NOT NULL,
    notify_duration integer NOT NULL,
    cntrl_type character varying NOT NULL
);


ALTER TABLE rdm_admin.notify_alarms OWNER TO "RDM_ADMIN";

--
-- Name: param_headers; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.param_headers (
    header_name character varying(25) NOT NULL,
    header_loc numeric(3,0) NOT NULL,
    cntrl_type character varying(15) NOT NULL
);


ALTER TABLE rdm_admin.param_headers OWNER TO "RDM_ADMIN";

--
-- Name: room_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.room_info (
    rm_id character varying(20) NOT NULL,
    rm_ip character varying(15) NOT NULL,
    cntrl_type character varying(15) NOT NULL,
    rm_status character varying(10) NOT NULL,
    group_name character varying(20)
);


ALTER TABLE rdm_admin.room_info OWNER TO "RDM_ADMIN";

--
-- Name: saved_graphs; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.saved_graphs (
    user_id character varying(15) NOT NULL,
    graph_name character varying(20) NOT NULL,
    rm_id character varying(20) NOT NULL,
    parameters character varying NOT NULL,
    global_access boolean NOT NULL
);


ALTER TABLE rdm_admin.saved_graphs OWNER TO "RDM_ADMIN";

--
-- Name: scale_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.scale_info (
    scale_id character varying(15) NOT NULL,
    scale_ip character varying(15) NOT NULL,
    scale_port numeric(4,0) NOT NULL,
    status character varying(10) NOT NULL
);


ALTER TABLE rdm_admin.scale_info OWNER TO "RDM_ADMIN";

--
-- Name: stage_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.stage_info (
    stage_name character varying(25) NOT NULL,
    stage_desc character varying(50),
    cntrl_type character varying(15) NOT NULL,
    stage_number character varying NOT NULL
);


ALTER TABLE rdm_admin.stage_info OWNER TO "RDM_ADMIN";

--
-- Name: task_attributes_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.task_attributes_info (
    attribute_name character varying(20) NOT NULL,
    attribute_unit character varying(3),
    read_weights boolean NOT NULL,
    tare_weight real,
    max_weight real,
    calculate character varying
);


ALTER TABLE rdm_admin.task_attributes_info OWNER TO "RDM_ADMIN";

--
-- Name: task_deliverable_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.task_deliverable_info (
    deliverable_id character varying(11) NOT NULL,
    attribute_name character varying(20) NOT NULL,
    task_id character varying(10) NOT NULL,
    attribute_value character varying(10),
    created_on timestamp without time zone,
    download_flag boolean DEFAULT false NOT NULL,
    download_by character varying(15),
    download_on timestamp with time zone,
    modified_tw character varying(5)
);


ALTER TABLE rdm_admin.task_deliverable_info OWNER TO "RDM_ADMIN";

--
-- Name: tunnel_def_param_val; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.tunnel_def_param_val (
    param_name character varying(50) NOT NULL,
    default_product character varying(10)
);


ALTER TABLE rdm_admin.tunnel_def_param_val OWNER TO "RDM_ADMIN";

--
-- Name: user_access_views; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.user_access_views (
    view_name character varying(30) NOT NULL,
    role_name character varying(50),
    dept_name character varying(50),
    hide_view boolean DEFAULT false
);


ALTER TABLE rdm_admin.user_access_views OWNER TO "RDM_ADMIN";

--
-- Name: user_activity; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.user_activity (
    oid bigint NOT NULL,
    user_id character varying(30) NOT NULL,
    log_in timestamp without time zone,
    log_out timestamp without time zone,
    user_ip character varying NOT NULL,
    log_text character varying
);


ALTER TABLE rdm_admin.user_activity OWNER TO "RDM_ADMIN";

--
-- Name: user_activity_oid_seq; Type: SEQUENCE; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE rdm_admin.user_activity ALTER COLUMN oid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME rdm_admin.user_activity_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_comments; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.user_comments (
    rm_id character varying(20),
    logged_by character varying(20) NOT NULL,
    logged_on timestamp without time zone NOT NULL,
    global character varying(1) NOT NULL,
    review_comments character varying,
    closed character varying(1),
    cmt_id character varying(15) NOT NULL,
    stage_number numeric,
    batch_no character varying,
    category character varying(8),
    department_name character varying,
    running_day integer,
    attachments character varying
);


ALTER TABLE rdm_admin.user_comments OWNER TO "RDM_ADMIN";

--
-- Name: user_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.user_info (
    user_id character varying(15) NOT NULL,
    password character varying(15) NOT NULL,
    first_name character varying(25) NOT NULL,
    last_name character varying(25) NOT NULL,
    email character varying(50),
    role_name character varying(15) NOT NULL,
    department_name character varying,
    gender character(1),
    address character varying(200),
    date_of_join date,
    date_of_birth date,
    contact_no character varying(12),
    blocked character(1),
    home_page character varying(30),
    locale character varying NOT NULL,
    training character(1),
    sec_department character varying,
    group_name character varying,
    qualification character varying(15),
    designation character varying(20)
);


ALTER TABLE rdm_admin.user_info OWNER TO "RDM_ADMIN";

--
-- Name: user_rules; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.user_rules (
    rule_expression character varying NOT NULL,
    rule_execute integer DEFAULT 1 NOT NULL,
    rule_oid character(6) NOT NULL,
    rule_desc character varying NOT NULL,
    cntrl_type character varying(15) NOT NULL
);


ALTER TABLE rdm_admin.user_rules OWNER TO "RDM_ADMIN";

--
-- Name: wbs_task_info; Type: TABLE; Schema: rdm_admin; Owner: RDM_ADMIN
--

CREATE TABLE rdm_admin.wbs_task_info (
    oid bigint NOT NULL,
    task_autoname character varying(10) NOT NULL,
    task_id character varying(3) NOT NULL,
    notes character varying,
    rm_id character varying(20),
    status character varying(15) NOT NULL,
    owner character varying(15) NOT NULL,
    assignee character varying(15),
    estimated_start timestamp(6) without time zone,
    estimated_end timestamp(6) without time zone,
    actual_start timestamp(6) without time zone,
    actual_end timestamp(6) without time zone,
    parent_task character varying(10),
    system_log character varying,
    co_owners character varying,
    stage_number numeric,
    batch_no character varying,
    attachments character varying
);


ALTER TABLE rdm_admin.wbs_task_info OWNER TO "RDM_ADMIN";

--
-- Name: wbs_task_info_oid_seq; Type: SEQUENCE; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE rdm_admin.wbs_task_info ALTER COLUMN oid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME rdm_admin.wbs_task_info_oid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: batch_info batch_info_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.batch_info
    ADD CONSTRAINT batch_info_uk UNIQUE (rm_id, batch_no);


--
-- Name: bunker_def_param_val bunker_def_param_val_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.bunker_def_param_val
    ADD CONSTRAINT bunker_def_param_val_uk UNIQUE (param_name);


--
-- Name: cntrl_groups cntrl_groups_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.cntrl_groups
    ADD CONSTRAINT cntrl_groups_uk UNIQUE (group_name);


--
-- Name: controller_def_types controller_def_types_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.controller_def_types
    ADD CONSTRAINT controller_def_types_uk UNIQUE (cntrl_type, cntrl_def_type);


--
-- Name: controller_params_admin controller_params_admin_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.controller_params_admin
    ADD CONSTRAINT controller_params_admin_uk UNIQUE (param_name, cntrl_type);


--
-- Name: department_info department_info_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.department_info
    ADD CONSTRAINT department_info_uk UNIQUE (department_name);


--
-- Name: employee_in_out emp_in_out_UK; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.employee_in_out
    ADD CONSTRAINT "emp_in_out_UK" UNIQUE (user_id, log_date, shift_code);


--
-- Name: general_params_admin general_params_admin_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.general_params_admin
    ADD CONSTRAINT general_params_admin_uk UNIQUE (param_name, cntrl_type);


--
-- Name: grower_def_param_val grower_def_param_val_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.grower_def_param_val
    ADD CONSTRAINT grower_def_param_val_uk UNIQUE (param_name);


--
-- Name: list_of_tasks list_of_tasks_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.list_of_tasks
    ADD CONSTRAINT list_of_tasks_uk UNIQUE (task_id);


--
-- Name: notify_alarms notify_alarms_unq_idx; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.notify_alarms
    ADD CONSTRAINT notify_alarms_unq_idx UNIQUE (cntrl_type, alarm);


--
-- Name: param_headers param_headers_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.param_headers
    ADD CONSTRAINT param_headers_uk UNIQUE (header_loc, cntrl_type);


--
-- Name: room_info room_info_pk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.room_info
    ADD CONSTRAINT room_info_pk PRIMARY KEY (rm_id);


--
-- Name: room_info room_info_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.room_info
    ADD CONSTRAINT room_info_uk UNIQUE (rm_ip);


--
-- Name: scale_info scale_info_pk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.scale_info
    ADD CONSTRAINT scale_info_pk PRIMARY KEY (scale_id);


--
-- Name: scale_info scale_info_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.scale_info
    ADD CONSTRAINT scale_info_uk UNIQUE (scale_ip);


--
-- Name: task_attributes_info task_attributes_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.task_attributes_info
    ADD CONSTRAINT task_attributes_uk UNIQUE (attribute_name);


--
-- Name: task_deliverable_info task_deliverable_pk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.task_deliverable_info
    ADD CONSTRAINT task_deliverable_pk PRIMARY KEY (task_id, deliverable_id, attribute_name);


--
-- Name: tunnel_def_param_val tunnel_def_param_val_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.tunnel_def_param_val
    ADD CONSTRAINT tunnel_def_param_val_uk UNIQUE (param_name);


--
-- Name: user_comments user_comments_cmt_id_pk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.user_comments
    ADD CONSTRAINT user_comments_cmt_id_pk UNIQUE (cmt_id);


--
-- Name: user_info user_info_pk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.user_info
    ADD CONSTRAINT user_info_pk PRIMARY KEY (user_id);


--
-- Name: user_rules user_rules_uk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.user_rules
    ADD CONSTRAINT user_rules_uk UNIQUE (rule_desc, cntrl_type);


--
-- Name: wbs_task_info wbs_task_info_pk; Type: CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.wbs_task_info
    ADD CONSTRAINT wbs_task_info_pk PRIMARY KEY (task_autoname);


--
-- Name: alarm_history alarm_history_acceptedby_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.alarm_history
    ADD CONSTRAINT alarm_history_acceptedby_fk FOREIGN KEY (accepted_by) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: alarm_history alarm_history_mutedby_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.alarm_history
    ADD CONSTRAINT alarm_history_mutedby_fk FOREIGN KEY (muted_by) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: alarm_history alarm_history_rm_id_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.alarm_history
    ADD CONSTRAINT alarm_history_rm_id_fk FOREIGN KEY (rm_id) REFERENCES rdm_admin.room_info(rm_id) ON UPDATE CASCADE;


--
-- Name: batch_info batch_info_rm_id_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.batch_info
    ADD CONSTRAINT batch_info_rm_id_fk FOREIGN KEY (rm_id) REFERENCES rdm_admin.room_info(rm_id) MATCH FULL ON UPDATE CASCADE;


--
-- Name: daily_yield daily_yield_loggedby_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.daily_yield
    ADD CONSTRAINT daily_yield_loggedby_fk FOREIGN KEY (logged_by) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: daily_yield daily_yield_rm_id_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.daily_yield
    ADD CONSTRAINT daily_yield_rm_id_fk FOREIGN KEY (rm_id) REFERENCES rdm_admin.room_info(rm_id) ON UPDATE CASCADE;


--
-- Name: employee_in_out emp_in_out_FK; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.employee_in_out
    ADD CONSTRAINT "emp_in_out_FK" FOREIGN KEY (user_id) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: log_history log_history_loggedby_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.log_history
    ADD CONSTRAINT log_history_loggedby_fk FOREIGN KEY (logged_by) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: log_history log_history_rm_id_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.log_history
    ADD CONSTRAINT log_history_rm_id_fk FOREIGN KEY (rm_id) REFERENCES rdm_admin.room_info(rm_id) ON UPDATE CASCADE;


--
-- Name: notify_alarms notify_alarms_first_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.notify_alarms
    ADD CONSTRAINT notify_alarms_first_fk FOREIGN KEY (notify_first) REFERENCES rdm_admin.user_info(user_id) MATCH FULL ON UPDATE CASCADE;


--
-- Name: notify_alarms notify_alarms_second_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.notify_alarms
    ADD CONSTRAINT notify_alarms_second_fk FOREIGN KEY (notify_second) REFERENCES rdm_admin.user_info(user_id) MATCH FULL ON UPDATE CASCADE;


--
-- Name: room_info room_info_groupname_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.room_info
    ADD CONSTRAINT room_info_groupname_fk FOREIGN KEY (group_name) REFERENCES rdm_admin.cntrl_groups(group_name) ON UPDATE CASCADE NOT VALID;


--
-- Name: saved_graphs saved_graphs_rm_id_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.saved_graphs
    ADD CONSTRAINT saved_graphs_rm_id_fk FOREIGN KEY (rm_id) REFERENCES rdm_admin.room_info(rm_id) MATCH FULL ON UPDATE CASCADE;


--
-- Name: saved_graphs saved_graphs_user_id_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.saved_graphs
    ADD CONSTRAINT saved_graphs_user_id_fk FOREIGN KEY (user_id) REFERENCES rdm_admin.user_info(user_id) MATCH FULL ON UPDATE CASCADE;


--
-- Name: task_deliverable_info task_deliverable_downloadby_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.task_deliverable_info
    ADD CONSTRAINT task_deliverable_downloadby_fk FOREIGN KEY (download_by) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: task_deliverable_info task_deliverable_task_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.task_deliverable_info
    ADD CONSTRAINT task_deliverable_task_fk FOREIGN KEY (task_id) REFERENCES rdm_admin.wbs_task_info(task_autoname) ON UPDATE CASCADE;


--
-- Name: user_comments user_comments_loggedby_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.user_comments
    ADD CONSTRAINT user_comments_loggedby_fk FOREIGN KEY (logged_by) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: user_comments user_comments_rm_id_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.user_comments
    ADD CONSTRAINT user_comments_rm_id_fk FOREIGN KEY (rm_id) REFERENCES rdm_admin.room_info(rm_id) ON UPDATE CASCADE;


--
-- Name: wbs_task_info wbs_task_assignee_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.wbs_task_info
    ADD CONSTRAINT wbs_task_assignee_fk FOREIGN KEY (assignee) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- Name: wbs_task_info wbs_task_owner_fk; Type: FK CONSTRAINT; Schema: rdm_admin; Owner: RDM_ADMIN
--

ALTER TABLE ONLY rdm_admin.wbs_task_info
    ADD CONSTRAINT wbs_task_owner_fk FOREIGN KEY (owner) REFERENCES rdm_admin.user_info(user_id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

