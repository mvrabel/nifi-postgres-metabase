--
-- Name: contact_ih; Type: TABLE; Schema: core;
--

CREATE TABLE core.contact_ih (
    contact_id integer NOT NULL,
    contact_key text NOT NULL,
    fk_organization_id integer,
    fk_party_id integer,
    created_timestamp timestamp with time zone NOT NULL,
    phone_number text,
    email_address text,
    location_full text,
    location_street_number text,
    location_street text,
    location_city text,
    location_country text,
    location_postal_code text,
    pipedrive_label text,
    fk_employee_id_owner integer NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    pipedrive_id text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_begin_effective_utc_timestamp bigint NOT NULL,
    tech_end_effective_utc_timestamp bigint NOT NULL,
    tech_is_current boolean NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_deleted_in_source_system boolean NOT NULL
);




--
-- Name: deal_ih; Type: TABLE; Schema: core;
--

CREATE TABLE core.deal_ih (
    deal_id integer NOT NULL,
    deal_key text NOT NULL,
    title text NOT NULL,
    stage text NOT NULL,
    fk_issue_id integer NOT NULL,
    fk_contact_id integer NOT NULL,
    fk_organization_id integer NOT NULL,
    fk_employee_id_owner integer NOT NULL,
    usd_value integer,
    fk_currency_id_deal_currency integer NOT NULL,
    local_currency_value integer,
    created_timestamp timestamp with time zone NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    closed_timestamp timestamp with time zone,
    pipedrive_id text NOT NULL,
    status text NOT NULL,
    pipeline text NOT NULL,
    won_timestamp timestamp with time zone,
    lost_timestamp timestamp with time zone,
    fk_date_id_expected_close_date integer NOT NULL,
    industry text,
    deal_source text,
    deal_source_detail text,
    region text,
    reason_lost text,
    resulting_state text,
    category text,
    country text,
    vtiger_key text,
    partner_identified_by text,
    partner_qualified_by text,
    partner_poc_done_by text,
    partner_closed_by text,
    partner_resold_by text,
    partner_supported_by text,
    partner_owned_by text,
    tech_insert_function text NOT NULL,
    tech_begin_effective_utc_timestamp bigint NOT NULL,
    tech_end_effective_utc_timestamp bigint NOT NULL,
    tech_is_current boolean NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_deleted_in_source_system boolean NOT NULL,
    previous_stage text
);




--
-- Name: employee_ih; Type: TABLE; Schema: core;
--

CREATE TABLE core.employee_ih (
    employee_id integer NOT NULL,
    employee_key text NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    secondary_email text,
    phone text,
    mobile_phone text,
    created_timestamp timestamp with time zone NOT NULL,
    tech_insert_function text NOT NULL,
    tech_begin_effective_utc_timestamp bigint NOT NULL,
    tech_end_effective_utc_timestamp bigint NOT NULL,
    tech_is_current boolean NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_deleted_in_source_system boolean NOT NULL
);




--
-- Name: issue_ih; Type: TABLE; Schema: core;
--

CREATE TABLE core.issue_ih (
    issue_id integer NOT NULL,
    jira_key text NOT NULL,
    jira_id integer NOT NULL,
    issue_key text NOT NULL,
    account text,
    status text,
    summary text,
    priority text,
    sla_priority text,
    description text,
    issue_type text,
    resolution text,
    deployment text,
    epic_name text,
    epic_jira_key text,
    original_estimate interval,
    remaining_estimate interval,
    aggregate_original_estimate interval,
    aggregate_remaining_estimate interval,
    labels text[],
    components text[],
    fix_versions text[],
    affected_versions text[],
    first_response_timestamp timestamp with time zone,
    resolution_timestamp timestamp with time zone,
    created_timestamp timestamp with time zone NOT NULL,
    fk_date_id_pilot_date integer NOT NULL,
    fk_date_id_sales_date integer NOT NULL,
    fk_project_id integer NOT NULL,
    fk_party_id_created_by integer NOT NULL,
    fk_party_id_reported_by integer NOT NULL,
    fk_employee_id_assigned_to integer NOT NULL,
    fk_date_id_inception_date integer NOT NULL,
    tech_insert_function text NOT NULL,
    tech_begin_effective_utc_timestamp bigint NOT NULL,
    tech_end_effective_utc_timestamp bigint NOT NULL,
    tech_is_current boolean NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    fk_date_id_deployment_date integer NOT NULL,
    customer text,
    tech_deleted_in_source_system boolean NOT NULL
);




--
-- Name: organization_ih; Type: TABLE; Schema: core;
--

CREATE TABLE core.organization_ih (
    organization_id integer NOT NULL,
    organization_key text NOT NULL,
    fk_party_id integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    address_full text,
    address_street_number text,
    address_street text,
    address_city text,
    address_country text,
    address_postal_code text,
    pipedrive_label text,
    fk_employee_id_owner integer NOT NULL,
    last_updated_timestamp timestamp with time zone NOT NULL,
    pipedrive_id text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_begin_effective_utc_timestamp bigint NOT NULL,
    tech_end_effective_utc_timestamp bigint NOT NULL,
    tech_is_current boolean NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_deleted_in_source_system boolean NOT NULL
);




--
-- Name: party_ih; Type: TABLE; Schema: core;
--

CREATE TABLE core.party_ih (
    party_id integer NOT NULL,
    party_key text NOT NULL,
    full_name text NOT NULL,
    short_name text NOT NULL,
    fk_employee_id_last_modified_by integer NOT NULL,
    fk_employee_id_created_by integer NOT NULL,
    created_timestamp timestamp with time zone NOT NULL,
    last_modified_timestamp timestamp with time zone NOT NULL,
    tech_insert_function text NOT NULL,
    tech_begin_effective_utc_timestamp bigint NOT NULL,
    tech_end_effective_utc_timestamp bigint NOT NULL,
    tech_is_current boolean NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_deleted_in_source_system boolean NOT NULL
);




--
-- Name: COLUMN party_ih.full_name; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.party_ih.full_name IS 'lead - vtiger_crm_entity.label ( or leaddetail.first_name + leaddetail.last_name) | 
organization - vtiger_account.accountname';


--
-- Name: COLUMN party_ih.created_timestamp; Type: COMMENT; Schema: core;
--

COMMENT ON COLUMN core.party_ih.created_timestamp IS 'CRM users - vtiger_users.date_entered | 
CRM entity - vtiger_crmentity.createdtime';


--
-- Name: project_ih; Type: TABLE; Schema: core;
--

CREATE TABLE core.project_ih (
    project_id integer NOT NULL,
    project_key text NOT NULL,
    jira_id integer NOT NULL,
    jira_key text NOT NULL,
    project_name text NOT NULL,
    tech_insert_function text NOT NULL,
    tech_begin_effective_utc_timestamp bigint NOT NULL,
    tech_end_effective_utc_timestamp bigint NOT NULL,
    tech_is_current boolean NOT NULL,
    tech_row_hash text NOT NULL,
    tech_data_load_utc_timestamp bigint NOT NULL,
    tech_data_load_uuid text NOT NULL,
    tech_deleted_in_source_system boolean NOT NULL
);




--
-- Name: seq_contact_ih_contact_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_contact_ih_contact_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_contact_ih_contact_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_contact_ih_contact_id OWNED BY core.contact_ih.contact_id;


--
-- Name: seq_deal_ih_deal_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_deal_ih_deal_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_deal_ih_deal_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_deal_ih_deal_id OWNED BY core.deal_ih.deal_id;


--
-- Name: seq_employee_ih_employee_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_employee_ih_employee_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_employee_ih_employee_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_employee_ih_employee_id OWNED BY core.employee_ih.employee_id;


--
-- Name: seq_issue_ih_issue_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_issue_ih_issue_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_issue_ih_issue_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_issue_ih_issue_id OWNED BY core.issue_ih.issue_id;


--
-- Name: seq_organization_ih_organization_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_organization_ih_organization_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_organization_ih_organization_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_organization_ih_organization_id OWNED BY core.organization_ih.organization_id;


--
-- Name: seq_party_ih_party_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_party_ih_party_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_party_ih_party_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_party_ih_party_id OWNED BY core.party_ih.party_id;


--
-- Name: seq_project_ih_project_id; Type: SEQUENCE; Schema: core;
--

CREATE SEQUENCE core.seq_project_ih_project_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: seq_project_ih_project_id; Type: SEQUENCE OWNED BY; Schema: core;
--

ALTER SEQUENCE core.seq_project_ih_project_id OWNED BY core.project_ih.project_id;


--
-- Name: contact_ih contact_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.contact_ih ALTER COLUMN contact_id SET DEFAULT nextval('core.seq_contact_ih_contact_id'::regclass);


--
-- Name: deal_ih deal_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.deal_ih ALTER COLUMN deal_id SET DEFAULT nextval('core.seq_deal_ih_deal_id'::regclass);


--
-- Name: employee_ih employee_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.employee_ih ALTER COLUMN employee_id SET DEFAULT nextval('core.seq_employee_ih_employee_id'::regclass);


--
-- Name: issue_ih issue_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih ALTER COLUMN issue_id SET DEFAULT nextval('core.seq_issue_ih_issue_id'::regclass);


--
-- Name: organization_ih organization_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.organization_ih ALTER COLUMN organization_id SET DEFAULT nextval('core.seq_organization_ih_organization_id'::regclass);


--
-- Name: party_ih party_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.party_ih ALTER COLUMN party_id SET DEFAULT nextval('core.seq_party_ih_party_id'::regclass);


--
-- Name: project_ih project_id; Type: DEFAULT; Schema: core;
--

ALTER TABLE ONLY core.project_ih ALTER COLUMN project_id SET DEFAULT nextval('core.seq_project_ih_project_id'::regclass);


--
-- Name: contact_ih pk_contact_ih_contact_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_ih
    ADD CONSTRAINT pk_contact_ih_contact_id PRIMARY KEY (contact_id);


--
-- Name: deal_ih pk_deal_ih_deal_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_ih
    ADD CONSTRAINT pk_deal_ih_deal_id PRIMARY KEY (deal_id);


--
-- Name: employee_ih pk_employee_ih; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.employee_ih
    ADD CONSTRAINT pk_employee_ih PRIMARY KEY (employee_id);


--
-- Name: issue_ih pk_issue_ih; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT pk_issue_ih PRIMARY KEY (issue_id);


--
-- Name: organization_ih pk_organization_ih_organization_id; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_ih
    ADD CONSTRAINT pk_organization_ih_organization_id PRIMARY KEY (organization_id);


--
-- Name: party_ih pk_party_ih; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_ih
    ADD CONSTRAINT pk_party_ih PRIMARY KEY (party_id);


--
-- Name: project_ih pk_project_ih; Type: CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.project_ih
    ADD CONSTRAINT pk_project_ih PRIMARY KEY (project_id);


--
-- Name: ix_contact_ih_fk_employee_id_owner; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_ih_fk_employee_id_owner ON core.contact_ih USING btree (fk_employee_id_owner);


--
-- Name: ix_contact_ih_fk_organization_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_ih_fk_organization_id ON core.contact_ih USING btree (fk_organization_id);


--
-- Name: ix_contact_ih_fk_party_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_contact_ih_fk_party_id ON core.contact_ih USING btree (fk_party_id);


--
-- Name: ix_deal_ih_fk_contact_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_ih_fk_contact_id ON core.deal_ih USING btree (fk_contact_id);


--
-- Name: ix_deal_ih_fk_currency_id_deal_currency; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_ih_fk_currency_id_deal_currency ON core.deal_ih USING btree (fk_currency_id_deal_currency);


--
-- Name: ix_deal_ih_fk_date_id_expected_close_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_ih_fk_date_id_expected_close_date ON core.deal_ih USING btree (fk_date_id_expected_close_date);


--
-- Name: ix_deal_ih_fk_employee_id_owner; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_ih_fk_employee_id_owner ON core.deal_ih USING btree (fk_employee_id_owner);


--
-- Name: ix_deal_ih_fk_issue_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_ih_fk_issue_id ON core.deal_ih USING btree (fk_issue_id);


--
-- Name: ix_deal_ih_fk_organization_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_deal_ih_fk_organization_id ON core.deal_ih USING btree (fk_organization_id);


--
-- Name: ix_employee_ih_email; Type: INDEX; Schema: core;
--

CREATE INDEX ix_employee_ih_email ON core.employee_ih USING btree (email);


--
-- Name: ix_issue_ih_account; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_account ON core.issue_ih USING btree (account);


--
-- Name: ix_issue_ih_deployment; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_deployment ON core.issue_ih USING btree (deployment);


--
-- Name: ix_issue_ih_fk_date_id_deployment_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_date_id_deployment_date ON core.issue_ih USING btree (fk_date_id_deployment_date);


--
-- Name: ix_issue_ih_fk_date_id_inception_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_date_id_inception_date ON core.issue_ih USING btree (fk_date_id_inception_date);


--
-- Name: ix_issue_ih_fk_date_id_pilot_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_date_id_pilot_date ON core.issue_ih USING btree (fk_date_id_pilot_date);


--
-- Name: ix_issue_ih_fk_date_id_sales_date; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_date_id_sales_date ON core.issue_ih USING btree (fk_date_id_sales_date);


--
-- Name: ix_issue_ih_fk_employee_id_assigned_to; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_employee_id_assigned_to ON core.issue_ih USING btree (fk_employee_id_assigned_to);


--
-- Name: ix_issue_ih_fk_party_id_created_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_party_id_created_by ON core.issue_ih USING btree (fk_party_id_created_by);


--
-- Name: ix_issue_ih_fk_party_id_reported_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_party_id_reported_by ON core.issue_ih USING btree (fk_party_id_reported_by);


--
-- Name: ix_issue_ih_fk_project_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_fk_project_id ON core.issue_ih USING btree (fk_project_id);


--
-- Name: ix_issue_ih_status; Type: INDEX; Schema: core;
--

CREATE INDEX ix_issue_ih_status ON core.issue_ih USING btree (status);


--
-- Name: ix_organization_ih_fk_employee_id_owner; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_ih_fk_employee_id_owner ON core.organization_ih USING btree (fk_employee_id_owner);


--
-- Name: ix_organization_ih_fk_party_id; Type: INDEX; Schema: core;
--

CREATE INDEX ix_organization_ih_fk_party_id ON core.organization_ih USING btree (fk_party_id);


--
-- Name: ix_party_ih_fk_employee_id_created_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_ih_fk_employee_id_created_by ON core.party_ih USING btree (fk_employee_id_created_by);


--
-- Name: ix_party_ih_fk_employee_id_last_modified_by; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_ih_fk_employee_id_last_modified_by ON core.party_ih USING btree (fk_employee_id_last_modified_by);


--
-- Name: ix_party_ih_full_name; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_ih_full_name ON core.party_ih USING btree (full_name);


--
-- Name: ix_party_ih_short_name; Type: INDEX; Schema: core;
--

CREATE INDEX ix_party_ih_short_name ON core.party_ih USING btree (short_name);


--
-- Name: ix_project_ih_project_name; Type: INDEX; Schema: core;
--

CREATE INDEX ix_project_ih_project_name ON core.project_ih USING btree (project_name);


--
-- Name: ux_contact_ih_contact_key; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_contact_ih_contact_key ON core.contact_ih USING btree (contact_key) WHERE (tech_is_current = true);


--
-- Name: ux_deal_ih_deal_key; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_deal_ih_deal_key ON core.deal_ih USING btree (deal_key) WHERE (tech_is_current = true);


--
-- Name: ux_employee_ih_employee_key; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_employee_ih_employee_key ON core.employee_ih USING btree (employee_key) WHERE (tech_is_current = true);


--
-- Name: ux_issue_ih_issue_key; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_issue_ih_issue_key ON core.issue_ih USING btree (issue_key) WHERE (tech_is_current = true);


--
-- Name: ux_organization_ih_organization_key; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_organization_ih_organization_key ON core.organization_ih USING btree (organization_key) WHERE (tech_is_current = true);


--
-- Name: ux_party_ih_party_key; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_party_ih_party_key ON core.party_ih USING btree (party_key) WHERE (tech_is_current = true);


--
-- Name: ux_project_ih_project_key; Type: INDEX; Schema: core;
--

CREATE UNIQUE INDEX ux_project_ih_project_key ON core.project_ih USING btree (project_key) WHERE (tech_is_current = true);


--
-- Name: contact_ih fk_contact_ih_fk_employee_id_owner; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_ih
    ADD CONSTRAINT fk_contact_ih_fk_employee_id_owner FOREIGN KEY (fk_employee_id_owner) REFERENCES core.employee_ih(employee_id);


--
-- Name: contact_ih fk_contact_ih_fk_organization_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_ih
    ADD CONSTRAINT fk_contact_ih_fk_organization_id FOREIGN KEY (fk_organization_id) REFERENCES core.organization_ih(organization_id);


--
-- Name: contact_ih fk_contact_ih_fk_party_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.contact_ih
    ADD CONSTRAINT fk_contact_ih_fk_party_id FOREIGN KEY (fk_party_id) REFERENCES core.party_ih(party_id);


--
-- Name: deal_ih fk_deal_ih_fk_currency_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_ih
    ADD CONSTRAINT fk_deal_ih_fk_currency_id FOREIGN KEY (fk_currency_id_deal_currency) REFERENCES core.c_currency_g(currency_id);


--
-- Name: deal_ih fk_deal_ih_fk_date_id_expected_close_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_ih
    ADD CONSTRAINT fk_deal_ih_fk_date_id_expected_close_date FOREIGN KEY (fk_date_id_expected_close_date) REFERENCES core.c_date_g(date_id);


--
-- Name: deal_ih fk_deal_ih_fk_employee_id_owner; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_ih
    ADD CONSTRAINT fk_deal_ih_fk_employee_id_owner FOREIGN KEY (fk_employee_id_owner) REFERENCES core.employee_ih(employee_id);


--
-- Name: deal_ih fk_deal_ih_fk_issue_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.deal_ih
    ADD CONSTRAINT fk_deal_ih_fk_issue_id FOREIGN KEY (fk_issue_id) REFERENCES core.issue_ih(issue_id);


--
-- Name: issue_ih fk_issue_ih_fk_date_id_deployment_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_date_id_deployment_date FOREIGN KEY (fk_date_id_deployment_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_ih fk_issue_ih_fk_date_id_inception_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_date_id_inception_date FOREIGN KEY (fk_date_id_inception_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_ih fk_issue_ih_fk_date_id_pilot_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_date_id_pilot_date FOREIGN KEY (fk_date_id_pilot_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_ih fk_issue_ih_fk_date_id_sales_date; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_date_id_sales_date FOREIGN KEY (fk_date_id_sales_date) REFERENCES core.c_date_g(date_id);


--
-- Name: issue_ih fk_issue_ih_fk_employee_id_assigned_to; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_employee_id_assigned_to FOREIGN KEY (fk_employee_id_assigned_to) REFERENCES core.employee_ih(employee_id);


--
-- Name: issue_ih fk_issue_ih_fk_party_id_created_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_party_id_created_by FOREIGN KEY (fk_party_id_created_by) REFERENCES core.party_ih(party_id);


--
-- Name: issue_ih fk_issue_ih_fk_party_id_reported_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_party_id_reported_by FOREIGN KEY (fk_party_id_reported_by) REFERENCES core.party_ih(party_id);


--
-- Name: issue_ih fk_issue_ih_fk_project_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.issue_ih
    ADD CONSTRAINT fk_issue_ih_fk_project_id FOREIGN KEY (fk_project_id) REFERENCES core.project_ih(project_id);


--
-- Name: organization_ih fk_organization_ih_fk_employee_id_owner; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_ih
    ADD CONSTRAINT fk_organization_ih_fk_employee_id_owner FOREIGN KEY (fk_employee_id_owner) REFERENCES core.employee_ih(employee_id);


--
-- Name: organization_ih fk_organization_ih_fk_party_id; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.organization_ih
    ADD CONSTRAINT fk_organization_ih_fk_party_id FOREIGN KEY (fk_party_id) REFERENCES core.party_ih(party_id);


--
-- Name: party_ih fk_party_ih_fk_employee_id_created_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_ih
    ADD CONSTRAINT fk_party_ih_fk_employee_id_created_by FOREIGN KEY (fk_employee_id_created_by) REFERENCES core.employee_ih(employee_id);


--
-- Name: party_ih fk_party_ih_fk_employee_id_last_modified_by; Type: FK CONSTRAINT; Schema: core;
--

ALTER TABLE ONLY core.party_ih
    ADD CONSTRAINT fk_party_ih_fk_employee_id_last_modified_by FOREIGN KEY (fk_employee_id_last_modified_by) REFERENCES core.employee_ih(employee_id);
