CREATE TABLE user_list(
user_type VARCHAR(8) NOT NULL,
user_no VARCHAR(6),
PRIMARY KEY (user_no),
CONSTRAINT USER_LIST_TYPE CHECK (user_type IN ('admin', 'customer')),
CONSTRAINT USER_LIST_START CHECK (user_no LIKE 'A%' OR user_no LIKE 'C%'));

CREATE SEQUENCE admin_id_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE customer_id_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER user_list_admin
BEFORE INSERT ON user_list
FOR EACH ROW
WHEN(new.user_type='admin')
BEGIN
  SELECT 'A'||TRIM(TO_CHAR(admin_id_increment.NEXTVAL,'00099'))
  INTO   :new.user_no
  FROM   dual;
END;

CREATE OR REPLACE TRIGGER user_list_customer
BEFORE INSERT ON user_list
FOR EACH ROW
WHEN(new.user_type='customer')
BEGIN
  SELECT 'C'||TRIM(TO_CHAR(customer_id_increment.NEXTVAL,'00099'))
  INTO   :new.user_no
  FROM   dual;
END;

CREATE TABLE admin_list (
admin_id VARCHAR(6) NOT NULL PRIMARY KEY,
email VARCHAR(20),
username VARCHAR(30),
pw VARCHAR(30) NOT NULL,
CONSTRAINT ADMIN_UNIQUE_KEY UNIQUE (email, username, pw),
CONSTRAINT ADMIN_START CHECK (admin_id LIKE 'A%'),
FOREIGN KEY (admin_id) REFERENCES user_list(user_no))

CREATE SEQUENCE admin_list_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER admin_list_id
BEFORE INSERT ON admin_list
FOR EACH ROW
WHEN(new.user_type='admin')
BEGIN
  SELECT 'A'||TRIM(TO_CHAR(admin_list_increment.NEXTVAL,'00099'))
  INTO   :new.admin_id
  FROM   dual;
END;

CREATE TABLE customer_list (
customer_id VARCHAR(6) NOT NULL,
first_name VARCHAR(20),
last_name VARCHAR(20),
username VARCHAR(20) NOT NULL,
email VARCHAR(20) NOT NULL,
userpw VARCHAR(20) NOT NULL,
reg_date DATE,
address VARCHAR(255),
contact_no NUMBER(15),
CONSTRAINT CUSTOMER_KEY_UNIQUE UNIQUE(email, userpw, contact_no),
CONSTRAINT CUSTOMER_START CHECK (customer_id LIKE 'C%'),
PRIMARY KEY (customer_id, username),
FOREIGN KEY (customer_id) REFERENCES user_list(user_no)
)

CREATE SEQUENCE customer_list_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER customer_list
BEFORE INSERT ON user_list
FOR EACH ROW
BEGIN
  SELECT 'C'||TRIM(TO_CHAR(customer_list_increment.NEXTVAL,'00099'))
  INTO   :new.customer_id
  FROM   dual;
END;

CREATE TABLE cart (
cart_id VARCHAR(7),
user_id VARCHAR(6),
PRIMARY KEY (cart_id),
FOREIGN KEY (user_id) REFERENCES user_list(user_no))

CREATE SEQUENCE cart_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER cart
BEFORE INSERT ON cart
FOR EACH ROW
BEGIN
  SELECT 'CART-'||TRIM(TO_CHAR(cart_increment.NEXTVAL,'000099'))
  INTO   :new.cart_id
  FROM   dual;
END;

CREATE TABLE category(
category_id VARCHAR(7) NOT NULL,
category_name VARCHAR(100) NOT NULL,
CONSTRAINT CATEGORY_KEY_UNIQUE (category_name),
PRIMARY KEY (category_id)
)

CREATE SEQUENCE category_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER category
BEFORE INSERT ON category
FOR EACH ROW
BEGIN
  SELECT 'CAT'||TRIM(TO_CHAR(category_increment.NEXTVAL,'099'))
  INTO   :new.category_id
  FROM   dual;
END;

CREATE TABLE product (
product_id VARCHAR(7) NOT NULL,
product_name VARCHAR(255) NOT NULL,
category_id VARCHAR(20) NOT NULL,
product_price NUMBER(10) NOT NULL,
product_image VARCHAR2(255) NOT NULL,
avaiable_qty NUMBER(6),
CONSTRAINT PRODUCT_KEY_UNIQUE (product_name, product_image),
PRIMARY KEY (product_id),
FOREIGN KEY (category_id) REFERENCES category(category_id)
)

CREATE SEQUENCE product_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER product
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
  SELECT 'P'||TRIM(TO_CHAR(product_increment.NEXTVAL,'000099'))
  INTO   :new.product_id
  FROM   dual;
END;

CREATE TABLE coupon(
coupon_id VARCHAR(10) NOT NULL,
coupon_name VARCHAR(20) NOT NULL,
discount_val NUMBER(6) NOT NULL,
expiry_date DATE,
PRIMARY KEY (coupon_id)
)

CREATE SEQUENCE coupon_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER coupon
BEFORE INSERT ON coupon
FOR EACH ROW
BEGIN
  SELECT 'COUP'||TRIM(TO_CHAR(coupon_increment.NEXTVAL,'000099'))
  INTO   :new.coupon_id
  FROM   dual;
END;

CREATE TABLE cart_item(
cart_item_no VARCHAR(8) NOT NULL,
cart_id VARCHAR(20),
user_id VARCHAR(6),
product_id VARCHAR(20),
product_qty NUMBER(6),
PRIMARY KEY (cart_item_no),
FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
FOREIGN KEY (user_id) REFERENCES user_list(user_no),
FOREIGN KEY (product_id) REFERENCES product(product_id)
)

CREATE SEQUENCE cart_item_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER cart_item
BEFORE INSERT ON cart_item
FOR EACH ROW
BEGIN
  SELECT 'CI-'||TRIM(TO_CHAR(coupon_increment.NEXTVAL,'00099'))
  INTO   :new.cart_item_no
  FROM   dual;
END;

CREATE TABLE orders (
order_id VARCHAR(20) NOT NULL,
cart_id VARCHAR(20) NOT NULL,
user_id VARCHAR(6) NOT NULL,
order_date DATE DEFAULT SYSDATE,
delivery_date DATE NOT NULL,
coupon_id VARCHAR(20) NOT NULL,
bill_amount NUMBER(6) NOT NULL,
payment_method VARCHAR(6) NOT NULL,
CONSTRAINT ORDER_PAYMENT_METHOD_ATT CHECK (payment_method IN ('COD','CREDIT','DEBIT','WALLET')),
PRIMARY KEY (order_id),
FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
FOREIGN KEY (user_id) REFERENCES user_list(user_no),
FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
)

CREATE SEQUENCE orders_increment
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER orders
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  SELECT 'O-'||TRIM(TO_CHAR(orders_increment.NEXTVAL,'0000000000000099'))
  INTO   :new.coupon_id
  FROM   dual;
END;

CREATE OR REPLACE TRIGGER order_creation_date 
BEFORE INSERT ON orders
FOR EACH ROW

BEGIN
  SELECT SYSDATE
  INTO   :new.order_date
  FROM   dual;
END;

CREATE OR REPLACE TRIGGER order_delivery_date 
BEFORE INSERT ON orders
FOR EACH ROW

BEGIN
  SELECT SYSDATE+7
  INTO   :new.delivery_date
  FROM   dual;
END;
