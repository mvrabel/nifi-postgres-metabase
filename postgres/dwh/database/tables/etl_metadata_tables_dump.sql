--
-- Name: uber_transformation_call; Type: TABLE; Schema: etl_metadata;
--

CREATE TABLE etl_metadata.uber_transformation_call (
    transformation_name text NOT NULL,
    transformation_call_timestamp timestamp with time zone NOT NULL
);
