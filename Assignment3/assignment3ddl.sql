--Angel Baez Assignment 3

--Drops all tables if they already exists in the database
DROP TABLE IF EXISTS buyer CASCADE;

DROP TABLE IF EXISTS boat CASCADE;

DROP TABLE IF EXISTS "transaction";

--Creates tables for the schema, buyer, boat and transaction table
CREATE TABLE buyer(
    cust_id INTEGER NOT NULL,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL, 
    city TEXT NOT NULL,
    "state" character(3) NOT NULL,
	referrer TEXT NOT NULL
);

CREATE TABLE boat(
	prod_id INTEGER NOT NULL,
	brand TEXT NOT NULL,
	category TEXT,
	cost INTEGER NOT NULL, 
	price INTEGER NOT NULL
);

CREATE TABLE "transaction"(
	trans_id INTEGER NOT NULL,
	cust_id INTEGER NOT NULL,
	prod_id INTEGER NOT NULL,
	qty INTEGER NOT NULL,
	price INTEGER NOT NULL
);

--copies the data from the stdin into the respective tables
COPY buyer (cust_id, fname, lname, city, "state", referrer) FROM stdin;
1121	Jane	Doe	Boston	MA	craigslist
1221	Fred	Smith	Hartford	CT	facebook
1321	John	Jones	New Haven	CT	google
1421	Alan	Weston	Stony Brook	NY	craigslist
1521	James	Smith	Darien	CT	boatjournal
1621	Adam	East	Fort Lee	NJ	mariner
1721	Mary	Jones	New Haven	CT	facebook
1821	Tonya	James	Stamford	CT	boatbuyer
1921	Elaine	Edwards	New Rochelle	NY	boatbuyer
2021	Alan	Easton	White Plains	NY	craigslist
2121	James	John	Ringwood	NJ	google
2221	Ronald	Jones	Hackensack	NJ	craigslist
2321	Freida	Alan	Stratford	CT	boatbuyer
2421	Thelma	James	Paterson	NJ	facebook
2521	Louise	John	Paramus	NJ	boatbuyer
2621	Brad	Johnson	Fort Lee	NJ	google
2721	Thomas	Jameson	Fairfield	CT	craigslist
2821	Robert	Newbury	Astoria	NY	boatjournal
2921	Edward	Oldbury	Brooklyn	NY	mariner
3021	Juan	Reyes	Brooklyn	NY	facebook
3121	Alberto	Delacruz	New York	NY	google
3221	Margarita	Jones	White Plains	NY	boatbuyer
3321	Penelope	Smith	Maspeth	NY	facebook
\.

COPY boat (prod_id, brand, category, cost, price) FROM stdin;
1217	Criss Craft	sporty	20000	25000
1117	Bayliner	runabout	41000	45100
1317	Mastercraft	ski	67000	83750
1417	Boston Whaler	fishing	48000	55200
1517	Carver	cabin cruser	50000	62500
1617	Bayliner	runabout	33000	69300
1717	Kawasaki	sporty	51000	61200
1817	Kawasaki	runabout	33000	40260
1917	Zodiac	inflatable	17000	22100
3017	Egg Harbor		60000	126000
\.

COPY "transaction" (trans_id, cust_id, prod_id, qty, price) FROM stdin;
1124	3121	3017	1	126000
1127	1221	1617	1	69300
1130	1821	1317	1	83750
1133	1321	1117	1	45100
1136	2521	1717	1	61200
1139	2721	1317	1	83750
1142	2621	1417	1	55200
1145	1121	1917	1	22100
1148	1821	1817	1	40260
1151	2821	3017	1	126000
1154	1621	1917	1	22100
1157	3121	1717	1	61200
1160	2321	1517	1	62500
1163	3321	1317	1	83750
1166	1721	1917	1	22100
1169	2421	1817	1	40260
1172	2921	1417	1	55200
1175	2321	3017	1	126000
1178	1221	1317	1	83750
1181	1121	1817	1	40260
1184	1321	3017	1	126000
1187	1421	1517	1	62500
1190	3321	1517	1	62500
\.

--Adds primary key constraints for each table
ALTER TABLE ONLY buyer
	ADD CONSTRAINT buyer_pkey
	PRIMARY KEY (cust_id);
	
ALTER TABLE ONLY boat
	ADD CONSTRAINT boat_pkey
	PRIMARY KEY (prod_id);

ALTER TABLE ONLY "transaction"
	ADD CONSTRAINT transaction_pkey
	PRIMARY KEY (trans_id);

--Adds two foreign key constraints to the transaction table
--One for customer id and the other for product id
ALTER TABLE ONLY "transaction"	
	ADD CONSTRAINT transaction_cust_id_fkey 
	FOREIGN KEY (cust_id)
	REFERENCES buyer(cust_id);
	
ALTER TABLE ONLY "transaction"	
	ADD CONSTRAINT transaction_prod_id_fkey 
	FOREIGN KEY (prod_id)
	REFERENCES boat(prod_id);