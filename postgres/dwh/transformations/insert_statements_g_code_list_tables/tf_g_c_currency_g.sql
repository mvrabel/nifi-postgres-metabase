CREATE OR REPLACE FUNCTION core.tf_g_c_currency_g()
RETURNS INTEGER AS $$

    /*
    =============================================================================================================
    DESCRIPTION:        Populates currency table from with currancies from ISO 4217
    AUTHOR:             Martin Vrabel (https://github.com/mvrabel)
    CREATED ON:	        2018-05-26 (YYYY-MM-DD)
    NOTE:               https://www.xe.com/iso4217.php
    =============================================================================================================
    */

DECLARE

CURRENT_UTC_TIMESTAMP_AS_BIGINT BIGINT := (SELECT TO_CHAR(NOW() AT TIME ZONE 'UTC', 'YYYYMMddHH24MISS'))::BIGINT;
stack text;
FUNCTION_NAME text;

BEGIN

    -------------------------
    -- GET FUNCTION'S NAME --
    -------------------------

    GET DIAGNOSTICS stack = PG_CONTEXT;
    FUNCTION_NAME = substring(stack from 'function (.*?) line')::text;

    -----------------
    -- NULL RECORD --
    -----------------

    INSERT INTO core.c_currency_g (
        currency_id
        ,currency_name
        ,alphabetical_code
        ,numerical_code
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES (
        -1 -- currency_id
        ,'NULL_CURRENCY' -- currency_name
        ,'' -- alphabetical_code
        ,'' -- numerical_code
        ,FUNCTION_NAME -- tech_insert_function
        ,CURRENT_UTC_TIMESTAMP_AS_BIGINT -- tech_insert_utc_timestamp
        ,-1 -- tech_data_load_utc_timestamp
        ,'Manualy Generated Data' -- tech_data_load_uuid
    ) ON CONFLICT DO NOTHING;

    -----------------------------
    -- POPULATE CURRENCY TABLE --
    -----------------------------

    INSERT INTO core.c_currency_g (
        currency_name
        ,alphabetical_code
        ,numerical_code
        ,tech_insert_function
        ,tech_insert_utc_timestamp
        ,tech_data_load_utc_timestamp
        ,tech_data_load_uuid
        )
    VALUES
        ('UAE Dirham','AED','784', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Afghani','AFN','971', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Lek','ALL','008', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Armenian Dram','AMD','051', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Netherlands Antillean Guilder','ANG','532', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Kwanza','AOA','973', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Argentine Peso','ARS','032', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Australian Dollar','AUD','036', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Aruban Florin','AWG','533', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Azerbaijan Manat','AZN','944', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Convertible Mark','BAM','977', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Barbados Dollar','BBD','052', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Taka','BDT','050', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bulgarian Lev','BGN','975', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bahraini Dinar','BHD','048', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Burundi Franc','BIF','108', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bermudian Dollar','BMD','060', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Brunei Dollar','BND','096', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Boliviano','BOB','068', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Mvdol','BOV','984', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Brazilian Real','BRL','986', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bahamian Dollar','BSD','044', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Ngultrum','BTN','064', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Pula','BWP','072', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Belarusian Ruble','BYN','933', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Belize Dollar','BZD','084', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Canadian Dollar','CAD','124', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Congolese Franc','CDF','976', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Unidad de Fomento','CLF','990', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Chilean Peso','CLP','152', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Yuan Renminbi','CNY','156', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Colombian Peso','COP','170', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Unidad de Valor Real','COU','970', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Costa Rican Colon','CRC','188', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Peso Convertible','CUC','931', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Cuban Peso','CUP','192', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Cabo Verde Escudo','CVE','132', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Czech Koruna','CZK','203', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Djibouti Franc','DJF','262', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Danish Krone','DKK','208', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Dominican Peso','DOP','214', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Algerian Dinar','DZD','012', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Egyptian Pound','EGP','818', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Nakfa','ERN','232', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Ethiopian Birr','ETB','230', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Euro','EUR','978', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Fiji Dollar','FJD','242', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Falkland Islands Pound','FKP','238', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Pound Sterling','GBP','826', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Lari','GEL','981', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Ghana Cedi','GHS','936', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Gibraltar Pound','GIP','292', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Dalasi','GMD','270', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Guinean Franc','GNF','324', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Quetzal','GTQ','320', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Guyana Dollar','GYD','328', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Hong Kong Dollar','HKD','344', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Lempira','HNL','340', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Kuna','HRK','191', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Gourde','HTG','332', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Forint','HUF','348', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('WIR Euro','CHE','947', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Swiss Franc','CHF','756', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('WIR Franc','CHW','948', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Rupiah','IDR','360', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('New Israeli Sheqel','ILS','376', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Indian Rupee','INR','356', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Iraqi Dinar','IQD','368', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Iranian Rial','IRR','364', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Iceland Krona','ISK','352', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Jamaican Dollar','JMD','388', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Jordanian Dinar','JOD','400', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Yen','JPY','392', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Kenyan Shilling','KES','404', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Som','KGS','417', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Riel','KHR','116', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Comorian Franc ','KMF','174', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('North Korean Won','KPW','408', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Won','KRW','410', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Kuwaiti Dinar','KWD','414', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Cayman Islands Dollar','KYD','136', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Tenge','KZT','398', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Lao Kip','LAK','418', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Lebanese Pound','LBP','422', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Sri Lanka Rupee','LKR','144', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Liberian Dollar','LRD','430', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Loti','LSL','426', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Libyan Dinar','LYD','434', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Moroccan Dirham','MAD','504', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Moldovan Leu','MDL','498', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Malagasy Ariary','MGA','969', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Denar','MKD','807', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Kyat','MMK','104', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Tugrik','MNT','496', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Pataca','MOP','446', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Ouguiya','MRU','929', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Mauritius Rupee','MUR','480', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Rufiyaa','MVR','462', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Malawi Kwacha','MWK','454', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Mexican Peso','MXN','484', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Mexican Unidad de Inversion (UDI)','MXV','979', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Malaysian Ringgit','MYR','458', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Mozambique Metical','MZN','943', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Namibia Dollar','NAD','516', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Naira','NGN','566', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Cordoba Oro','NIO','558', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Norwegian Krone','NOK','578', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Nepalese Rupee','NPR','524', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('New Zealand Dollar','NZD','554', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Rial Omani','OMR','512', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Balboa','PAB','590', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Sol','PEN','604', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Kina','PGK','598', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Philippine Piso','PHP','608', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Pakistan Rupee','PKR','586', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Zloty','PLN','985', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Guarani','PYG','600', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Qatari Rial','QAR','634', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Romanian Leu','RON','946', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Serbian Dinar','RSD','941', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Russian Ruble','RUB','643', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Rwanda Franc','RWF','646', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Saudi Riyal','SAR','682', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Solomon Islands Dollar','SBD','090', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Seychelles Rupee','SCR','690', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Sudanese Pound','SDG','938', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Swedish Krona','SEK','752', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Singapore Dollar','SGD','702', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Saint Helena Pound','SHP','654', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Leone','SLL','694', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Somali Shilling','SOS','706', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Surinam Dollar','SRD','968', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('South Sudanese Pound','SSP','728', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Dobra','STN','930', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('El Salvador Colon','SVC','222', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Syrian Pound','SYP','760', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Lilangeni','SZL','748', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Baht','THB','764', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Somoni','TJS','972', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Turkmenistan New Manat','TMT','934', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Tunisian Dinar','TND','788', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Pa’anga','TOP','776', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Turkish Lira','TRY','949', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Trinidad and Tobago Dollar','TTD','780', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('New Taiwan Dollar','TWD','901', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Tanzanian Shilling','TZS','834', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Hryvnia','UAH','980', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Uganda Shilling','UGX','800', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('US Dollar','USD','840', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('US Dollar (Next day)','USN','997', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Uruguay Peso en Unidades Indexadas (URUIURUI)','UYI','940', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Peso Uruguayo','UYU','858', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Uzbekistan Sum','UZS','860', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bolívar','VEF','937', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Dong','VND','704', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Vatu','VUV','548', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Tala','WST','882', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('CFA Franc BEAC','XAF','950', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Silver','XAG','961', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Gold','XAU','959', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bond Markets Unit European Composite Unit (EURCO)','XBA','955', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bond Markets Unit European Monetary Unit (E.M.U.-6)','XBB','956', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bond Markets Unit European Unit of Account 9 (E.U.A.-9)','XBC','957', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Bond Markets Unit European Unit of Account 17 (E.U.A.-17)','XBD','958', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('East Caribbean Dollar','XCD','951', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('SDR (Special Drawing Right)','XDR','960', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('CFA Franc BCEAO','XOF','952', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Palladium','XPD','964', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('CFP Franc','XPF','953', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Platinum','XPT','962', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Sucre','XSU','994', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Codes specifically reserved for testing purposes','XTS','963', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('ADB Unit of Account','XUA','965', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('The codes assigned for transactions where no currency is involved','XXX','999', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Yemeni Rial','YER','886', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Rand','ZAR','710', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Zambian Kwacha','ZMW','967', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data'),
        ('Zimbabwe Dollar','ZWL','932', FUNCTION_NAME, CURRENT_UTC_TIMESTAMP_AS_BIGINT, -1, 'Manualy Generated Data');

    RETURN 0;

END;$$

LANGUAGE plpgsql
