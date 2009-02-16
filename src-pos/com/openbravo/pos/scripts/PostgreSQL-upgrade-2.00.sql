--    Openbravo POS is a point of sales application designed for touch screens.
--    Copyright (C) 2007-2008 Openbravo, S.L.
--    http://sourceforge.net/projects/openbravopos
--
--    This file is part of Openbravo POS.
--
--    Openbravo POS is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    Openbravo POS is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Openbravo POS.  If not, see <http://www.gnu.org/licenses/>.

-- Database upgrade script for POSTGRESQL
-- v2.00 - v2.10

ALTER TABLE PEOPLE ADD COLUMN CARD VARCHAR;  
CREATE INDEX PEOPLE_CARD_INX ON PEOPLE(CARD);

ALTER TABLE CUSTOMERS ADD COLUMN TAXID VARCHAR;  
ALTER TABLE CUSTOMERS ADD COLUMN CARD VARCHAR;  
ALTER TABLE CUSTOMERS ADD COLUMN MAXDEBT DOUBLE PRECISION DEFAULT 0 NOT NULL;
ALTER TABLE CUSTOMERS ADD COLUMN CURDATE TIMESTAMP;
ALTER TABLE CUSTOMERS ADD COLUMN CURDEBT DOUBLE PRECISION;
CREATE INDEX CUSTOMERS_TAXID_INX ON CUSTOMERS(TAXID);
CREATE INDEX CUSTOMERS_CARD_INX ON CUSTOMERS(CARD);

ALTER TABLE PRODUCTS ADD COLUMN ATTRIBUTES BYTEA;

ALTER TABLE TICKETS ADD COLUMN CUSTOMER VARCHAR;
ALTER TABLE TICKETS ADD CONSTRAINT TICKETS_CUSTOMERS_FK FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID);
CREATE INDEX TICKETS_TICKETID ON TICKETS(TICKETID);

ALTER TABLE TICKETLINES ADD COLUMN ATTRIBUTES BYTEA;

ALTER TABLE RECEIPTS ADD COLUMN DATENEW TIMESTAMP;
CREATE INDEX RECEIPTS_INX_1 ON RECEIPTS(DATENEW);
UPDATE RECEIPTS SET DATENEW = (SELECT DATENEW FROM TICKETS WHERE TICKETS.ID = RECEIPTS.ID);
ALTER TABLE RECEIPTS ALTER COLUMN DATENEW SET NOT NULL;

DROP INDEX TICKETS_INX_1;
ALTER TABLE TICKETS DROP COLUMN DATENEW;

INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('14', 'Menu.Root', 0, $FILE{/com/openbravo/pos/templates/Menu.Root.txt});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('15', 'Printer.CustomerPaid', 0, $FILE{/com/openbravo/pos/templates/Printer.CustomerPaid.xml});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('16', 'Printer.CustomerPaid2', 0, $FILE{/com/openbravo/pos/templates/Printer.CustomerPaid2.xml});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('17', 'payment.cash', 0, $FILE{/com/openbravo/pos/templates/payment.cash.txt});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('18', 'banknote.50euro', 1, $FILE{/com/openbravo/pos/templates/banknote.50euro.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('19', 'banknote.20euro', 1, $FILE{/com/openbravo/pos/templates/banknote.20euro.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('20', 'banknote.10euro', 1, $FILE{/com/openbravo/pos/templates/banknote.10euro.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('21', 'banknote.5euro', 1, $FILE{/com/openbravo/pos/templates/banknote.5euro.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('22', 'coin.2euro', 1, $FILE{/com/openbravo/pos/templates/coin.2euro.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('23', 'coin.1euro', 1, $FILE{/com/openbravo/pos/templates/coin.1euro.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('24', 'coin.50cent', 1, $FILE{/com/openbravo/pos/templates/coin.50cent.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('25', 'coin.20cent', 1, $FILE{/com/openbravo/pos/templates/coin.20cent.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('26', 'coin.10cent', 1, $FILE{/com/openbravo/pos/templates/coin.10cent.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('27', 'coin.5cent', 1, $FILE{/com/openbravo/pos/templates/coin.5cent.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('28', 'coin.2cent', 1, $FILE{/com/openbravo/pos/templates/coin.2cent.png});
INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('29', 'coin.1cent', 1, $FILE{/com/openbravo/pos/templates/coin.1cent.png});

-- v2.10 - v2.20

CREATE TABLE TAXCUSTCATEGORIES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX TAXCUSTCAT_NAME_INX ON TAXCUSTCATEGORIES(NAME);

CREATE TABLE TAXCATEGORIES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX TAXCAT_NAME_INX ON TAXCATEGORIES(NAME);
INSERT INTO TAXCATEGORIES(ID, NAME) VALUES ('000', 'Tax Exempt');
INSERT INTO TAXCATEGORIES(ID, NAME) VALUES ('001', 'Tax Standard');
INSERT INTO TAXCATEGORIES (ID, NAME) SELECT ID, NAME FROM TAXES;

ALTER TABLE TAXES ADD COLUMN CATEGORY VARCHAR;
ALTER TABLE TAXES ADD COLUMN CUSTCATEGORY VARCHAR;
ALTER TABLE TAXES ADD COLUMN PARENTID VARCHAR;
ALTER TABLE TAXES ADD COLUMN RATECASCADE BOOLEAN;
ALTER TABLE TAXES ADD COLUMN RATEORDER INTEGER;
ALTER TABLE TAXES ADD CONSTRAINT TAXES_CAT_FK FOREIGN KEY (CATEGORY) REFERENCES TAXCATEGORIES(ID);
ALTER TABLE TAXES ADD CONSTRAINT TAXES_CUSTCAT_FK FOREIGN KEY (CUSTCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID);
ALTER TABLE TAXES ADD CONSTRAINT TAXES_TAXES_FK FOREIGN KEY (PARENTID) REFERENCES TAXES(ID);
UPDATE TAXES SET CATEGORY = ID, RATECASCADE = FALSE;
ALTER TABLE TAXES ALTER COLUMN CATEGORY SET NOT NULL;
ALTER TABLE TAXES ALTER COLUMN RATECASCADE SET NOT NULL;

ALTER TABLE PRODUCTS ADD COLUMN TAXCAT VARCHAR;
ALTER TABLE PRODUCTS ADD CONSTRAINT PRODUCTS_TAXCAT_FK FOREIGN KEY (TAXCAT) REFERENCES TAXCATEGORIES(ID);
UPDATE PRODUCTS SET TAXCAT = TAX;
ALTER TABLE PRODUCTS ALTER COLUMN TAXCAT SET NOT NULL;
ALTER TABLE PRODUCTS DROP CONSTRAINT PRODUCTS_FK_2;
ALTER TABLE PRODUCTS DROP COLUMN TAX;

ALTER TABLE CUSTOMERS ADD COLUMN SEARCHKEY VARCHAR;
UPDATE CUSTOMERS SET SEARCHKEY = ID;
ALTER TABLE CUSTOMERS ALTER COLUMN SEARCHKEY SET NOT NULL;
CREATE UNIQUE INDEX CUSTOMERS_SKEY_INX ON CUSTOMERS(SEARCHKEY);

ALTER TABLE CUSTOMERS ADD COLUMN ADDRESS2 VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN POSTAL VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN CITY VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN REGION VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN COUNTRY VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN FIRSTNAME VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN LASTNAME VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN EMAIL VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN PHONE VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN PHONE2 VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN FAX VARCHAR;
ALTER TABLE CUSTOMERS ADD COLUMN TAXCATEGORY VARCHAR;
ALTER TABLE CUSTOMERS ADD CONSTRAINT CUSTOMERS_TAXCAT FOREIGN KEY (TAXCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID);

ALTER TABLE CLOSEDCASH ADD COLUMN HOSTSEQUENCE INTEGER;  
UPDATE CLOSEDCASH SET HOSTSEQUENCE = 0;
ALTER TABLE CLOSEDCASH ALTER COLUMN HOSTSEQUENCE SET NOT NULL;
CREATE INDEX CLOSEDCASH_SEQINX ON CLOSEDCASH(HOST, HOSTSEQUENCE);

ALTER TABLE RECEIPTS ADD COLUMN ATTRIBUTES BYTEA;

ALTER TABLE TICKETLINES DROP COLUMN NAME;
ALTER TABLE TICKETLINES DROP COLUMN ISCOM;

CREATE TABLE TAXLINES (
    ID VARCHAR NOT NULL,
    RECEIPT VARCHAR NOT NULL,
    TAXID VARCHAR NOT NULL, 
    BASE DOUBLE PRECISION NOT NULL, 
    AMOUNT DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT TAXLINES_TAX FOREIGN KEY (TAXID) REFERENCES TAXES(ID)
);

UPDATE PEOPLE SET CARD = NULL WHERE CARD = '';

-- v2.20 - v2.30

INSERT INTO RESOURCES(ID, NAME, RESTYPE, CONTENT) VALUES('30', 'Printer.PartialCash', 0, $FILE{/com/openbravo/pos/templates/Printer.PartialCash.xml});

CREATE TABLE _PRODUCTS_COM (
    ID VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    PRODUCT2 VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

INSERT INTO _PRODUCTS_COM(ID, PRODUCT, PRODUCT2) SELECT CONCAT(PRODUCT, PRODUCT2), PRODUCT, PRODUCT2 FROM PRODUCTS_COM;

ALTER TABLE PRODUCTS_COM DROP CONSTRAINT PRODUCTS_COM_FK_1;
ALTER TABLE PRODUCTS_COM DROP CONSTRAINT PRODUCTS_COM_FK_2;
DROP TABLE PRODUCTS_COM;

CREATE TABLE PRODUCTS_COM (
    ID VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    PRODUCT2 VARCHAR NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PRODUCTS_COM_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT PRODUCTS_COM_FK_2 FOREIGN KEY (PRODUCT2) REFERENCES PRODUCTS(ID)
);
CREATE UNIQUE INDEX PCOM_INX_PROD ON PRODUCTS_COM(PRODUCT, PRODUCT2);

INSERT INTO PRODUCTS_COM(ID, PRODUCT, PRODUCT2) SELECT ID, PRODUCT, PRODUCT2 FROM _PRODUCTS_COM;

DROP TABLE _PRODUCTS_COM;

ALTER TABLE TICKETS ADD COLUMN TICKETTYPE INTEGER DEFAULT 0 NOT NULL;
DROP INDEX TICKETS_TICKETID;
CREATE INDEX TICKETS_TICKETID ON TICKETS(TICKETTYPE, TICKETID);

CREATE SEQUENCE TICKETSNUM_REFUND START WITH 1;
CREATE SEQUENCE TICKETSNUM_PAYMENT START WITH 1;

ALTER TABLE PAYMENTS ADD COLUMN TRANSID VARCHAR;
ALTER TABLE PAYMENTS ADD COLUMN RETURNMSG BYTEA;

CREATE TABLE ATTRIBUTE (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE ATTRIBUTEVALUE (
    ID VARCHAR NOT NULL,
    ATTRIBUTE_ID VARCHAR NOT NULL,
    VALUE VARCHAR,
    PRIMARY KEY (ID),
    CONSTRAINT ATTVAL_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
);

CREATE TABLE ATTRIBUTESET (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE ATTRIBUTEUSE (
    ID VARCHAR NOT NULL,
    ATTRIBUTESET_ID VARCHAR NOT NULL,
    ATTRIBUTE_ID VARCHAR NOT NULL,
    LINENO INTEGER,
    PRIMARY KEY (ID),
    CONSTRAINT ATTUSE_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID),
    CONSTRAINT ATTUSE_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
);
CREATE UNIQUE INDEX ATTUSE_LINE ON ATTRIBUTEUSE(ATTRIBUTESET_ID, LINENO);

CREATE TABLE ATTRIBUTESETINSTANCE (
    ID VARCHAR NOT NULL,
    ATTRIBUTESET_ID VARCHAR NOT NULL,
    DESCRIPTION VARCHAR,
    PRIMARY KEY (ID),
    CONSTRAINT ATTSETINST_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID)
);

CREATE TABLE ATTRIBUTEINSTANCE (
    ID VARCHAR NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR NOT NULL,
    ATTRIBUTE_ID VARCHAR NOT NULL,
    VALUE VARCHAR,
    PRIMARY KEY (ID),
    CONSTRAINT ATTINST_SET FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT ATTINST_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
);

ALTER TABLE PRODUCTS ADD COLUMN ATTRIBUTESET_ID VARCHAR;
ALTER TABLE PRODUCTS ADD CONSTRAINT PRODUCTS_ATTRSET_FK FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID);

ALTER TABLE STOCKDIARY ADD COLUMN ATTRIBUTESETINSTANCE_ID VARCHAR;
ALTER TABLE STOCKDIARY ADD CONSTRAINT STOCKDIARY_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID);

CREATE TABLE STOCKLEVEL (
    ID VARCHAR NOT NULL,
    LOCATION VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    STOCKSECURITY DOUBLE PRECISION,
    STOCKMAXIMUM DOUBLE PRECISION,
    PRIMARY KEY (ID),
    CONSTRAINT STOCKLEVEL_PRODUCT FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKLEVEL_LOCATION FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);

INSERT INTO STOCKLEVEL(ID, LOCATION, PRODUCT, STOCKSECURITY, STOCKMAXIMUM) SELECT CONCAT(LOCATION, PRODUCT), LOCATION, PRODUCT, STOCKSECURITY, STOCKMAXIMUM FROM STOCKCURRENT;

CREATE TABLE _STOCKCURRENT (
    LOCATION VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR,
    UNITS DOUBLE PRECISION NOT NULL
);

INSERT INTO _STOCKCURRENT(LOCATION, PRODUCT, UNITS) SELECT LOCATION, PRODUCT, UNITS FROM STOCKCURRENT;

ALTER TABLE STOCKCURRENT DROP CONSTRAINT STOCKCURRENT_FK_1;
ALTER TABLE STOCKCURRENT DROP CONSTRAINT STOCKCURRENT_FK_2;
DROP TABLE STOCKCURRENT;

CREATE TABLE STOCKCURRENT (
    LOCATION VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR,
    UNITS DOUBLE PRECISION NOT NULL,
    CONSTRAINT STOCKCURRENT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKCURRENT_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT STOCKCURRENT_FK_2 FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);
CREATE UNIQUE INDEX STOCKCURRENT_INX ON STOCKCURRENT(LOCATION, PRODUCT, ATTRIBUTESETINSTANCE_ID);

INSERT INTO STOCKCURRENT(LOCATION, PRODUCT, UNITS) SELECT LOCATION, PRODUCT, UNITS FROM _STOCKCURRENT;

DROP TABLE _STOCKCURRENT;

ALTER TABLE TICKETLINES ADD COLUMN ATTRIBUTESETINSTANCE_ID VARCHAR;
ALTER TABLE TICKETLINES ADD CONSTRAINT TICKETLINES_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID);

-- final script

DELETE FROM SHAREDTICKETS;

UPDATE APPLICATIONS SET NAME = $APP_NAME{}, VERSION = $APP_VERSION{} WHERE ID = $APP_ID{};
