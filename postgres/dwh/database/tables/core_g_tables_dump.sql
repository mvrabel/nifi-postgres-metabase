--
-- Name: c_contry_name_map_g; Type: TABLE; Schema: core;
--

CREATE TABLE core.c_contry_name_map_g (
    contry_name_map_id integer NOT NULL,
    google_country_name text NOT NULL,
    iso_3166_country_name text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: c_currency_g; Type: TABLE; Schema: core;
--

CREATE TABLE core.c_currency_g (
    currency_id integer NOT NULL,
    currency_name text NOT NULL,
    alphabetical_code text NOT NULL,
    numerical_code text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: c_date_g; Type: TABLE; Schema: core;
--

CREATE TABLE core.c_date_g (
    date_id integer NOT NULL,
    date_actual date NOT NULL,
    epoch bigint NOT NULL,
    day_suffix character varying(4) NOT NULL,
    day_name character varying(9) NOT NULL,
    day_of_week integer NOT NULL,
    day_of_month integer NOT NULL,
    day_of_quarter integer NOT NULL,
    day_of_year integer NOT NULL,
    week_of_month integer NOT NULL,
    week_of_year integer NOT NULL,
    week_of_year_iso character(10) NOT NULL,
    month_actual integer NOT NULL,
    month_name character varying(9) NOT NULL,
    month_name_abbreviated character(3) NOT NULL,
    quarter_actual integer NOT NULL,
    quarter_name character varying(9) NOT NULL,
    year_actual integer NOT NULL,
    first_day_of_week date NOT NULL,
    last_day_of_week date NOT NULL,
    first_day_of_month date NOT NULL,
    last_day_of_month date NOT NULL,
    first_day_of_quarter date NOT NULL,
    last_day_of_quarter date NOT NULL,
    first_day_of_year date NOT NULL,
    last_day_of_year date NOT NULL,
    mmyyyy character(6) NOT NULL,
    mmddyyyy character(10) NOT NULL,
    weekend_indr boolean NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: COLUMN c_date_g.epoch; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.c_date_g.epoch IS 'epoch\nFor timestamp with time zone values, the number of seconds since 1970-01-01 00:00:00 UTC (can be negative); for date and timestamp values, the number of seconds since 1970-01-01 00:00:00 local time; for interval values, the total number of seconds in the interval';


--
-- Name: c_exchange_rate_g; Type: TABLE; Schema: core;
--

CREATE TABLE core.c_exchange_rate_g (
    exchange_rate_id integer NOT NULL,
    fk_currency_id_counter_currency integer NOT NULL,
    fk_currency_id_base_currency integer NOT NULL,
    exchange_rate double precision NOT NULL,
    fk_date_id integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: c_null_replacement_g; Type: TABLE; Schema: core;
--

CREATE TABLE core.c_null_replacement_g (
    text_null text NOT NULL,
    date_never date NOT NULL,
    date_infinity date NOT NULL,
    timestamp_never timestamp with time zone NOT NULL,
    timestamp_infinity timestamp with time zone NOT NULL,
    interval_never interval NOT NULL,
    interval_infinity interval NOT NULL,
    text_array_null text NOT NULL,
    timestamp_array_null timestamp with time zone[] NOT NULL,
    tech_insert_function text NOT NULL,
    tech_insert_utc_timestamp bigint NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL
);




--
-- Name: seq_c_contry_name_map_g_contry_name_map_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_c_contry_name_map_g_contry_name_map_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_c_contry_name_map_g_contry_name_map_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_c_contry_name_map_g_contry_name_map_id OWNED BY core.c_contry_name_map_g.contry_name_map_id;


--
-- Name: seq_c_currency_g_currency_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_c_currency_g_currency_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_c_currency_g_currency_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_c_currency_g_currency_id OWNED BY core.c_currency_g.currency_id;


--
-- Name: seq_c_exchange_rate_g_exchange_rate_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_c_exchange_rate_g_exchange_rate_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_c_exchange_rate_g_exchange_rate_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_c_exchange_rate_g_exchange_rate_id OWNED BY core.c_exchange_rate_g.exchange_rate_id;


--
-- Name: c_contry_name_map_g contry_name_map_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.c_contry_name_map_g ALTER COLUMN contry_name_map_id SET DEFAULT nextval('core.seq_c_contry_name_map_g_contry_name_map_id'::regclass);


--
-- Name: c_currency_g currency_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.c_currency_g ALTER COLUMN currency_id SET DEFAULT nextval('core.seq_c_currency_g_currency_id'::regclass);


--
-- Name: c_exchange_rate_g exchange_rate_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.c_exchange_rate_g ALTER COLUMN exchange_rate_id SET DEFAULT nextval('core.seq_c_exchange_rate_g_exchange_rate_id'::regclass);


--
-- Name: c_contry_name_map_g pk_c_contry_name_map_g_contry_name_map_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_contry_name_map_g
    ADD CONSTRAINT pk_c_contry_name_map_g_contry_name_map_id PRIMARY KEY (contry_name_map_id);


--
-- Name: c_currency_g pk_c_currency_g_currency_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_currency_g
    ADD CONSTRAINT pk_c_currency_g_currency_id PRIMARY KEY (currency_id);


--
-- Name: c_date_g pk_c_date_g; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_date_g
    ADD CONSTRAINT pk_c_date_g PRIMARY KEY (date_id);


--
-- Name: c_exchange_rate_g pk_exchange_rate_g_exchange_rate_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_exchange_rate_g
    ADD CONSTRAINT pk_exchange_rate_g_exchange_rate_id PRIMARY KEY (exchange_rate_id);


--
-- Name: c_contry_name_map_g ux_c_contry_name_map_g_google_name_iso_name; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_contry_name_map_g
    ADD CONSTRAINT ux_c_contry_name_map_g_google_name_iso_name UNIQUE (google_country_name, iso_3166_country_name);


--
-- Name: c_exchange_rate_g ux_exchange_rate_g_counter_currency_base_currency_date; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_exchange_rate_g
    ADD CONSTRAINT ux_exchange_rate_g_counter_currency_base_currency_date UNIQUE (fk_currency_id_counter_currency, fk_currency_id_base_currency, fk_date_id);


--
-- Name: ix_c_currency_g_alphabetical_code; Type: INDEX; Schema: core;
--

CREATE INDEX ix_c_currency_g_alphabetical_code ON core.c_currency_g USING btree (alphabetical_code);


--
-- Name: ix_c_currency_g_numerical_code; Type: INDEX; Schema: core;
--

CREATE INDEX ix_c_currency_g_numerical_code ON core.c_currency_g USING btree (numerical_code);


--
-- Name: c_exchange_rate_g fk_c_exchange_rate_g_fk_currency_id_base_currency; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_exchange_rate_g
    ADD CONSTRAINT fk_c_exchange_rate_g_fk_currency_id_base_currency FOREIGN KEY (fk_currency_id_base_currency) REFERENCES core.c_currency_g(currency_id);


--
-- Name: c_exchange_rate_g fk_c_exchange_rate_g_fk_currency_id_counter_currency; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_exchange_rate_g
    ADD CONSTRAINT fk_c_exchange_rate_g_fk_currency_id_counter_currency FOREIGN KEY (fk_currency_id_counter_currency) REFERENCES core.c_currency_g(currency_id);


--
-- Name: c_exchange_rate_g fk_c_exchange_rate_g_fk_date_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.c_exchange_rate_g
    ADD CONSTRAINT fk_c_exchange_rate_g_fk_date_id FOREIGN KEY (fk_date_id) REFERENCES core.c_date_g(date_id);
