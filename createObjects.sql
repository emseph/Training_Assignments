CREATE TABLE user_list(
user_no VARCHAR(6) NOT NULL,
user_type VARCHAR(6) NOT NULL,
PRIMARY KEY (user_no),
CONSTRAINT USER_LIST_TYPE CHECK (user_type IN ('admin','customer')),
CONSTRAINT USER_LIST_START CHECK (user_no LIKE 'A%' OR user_no LIKE 'C%'))

CREATE TABLE admin_list (
admin_id VARCHAR(6) NOT NULL,
email VARCHAR(20),
adminpw VARCHAR(20),
CONSTRAINT ADMIN_UNIQUE_KEY UNIQUE (email),
CONSTRAINT ADMIN_START CHECK (admin_id LIKE 'A%'),
FOREIGN KEY (admin_id) REFERENCES user_list(user_no))

CREATE TABLE customer_list (
customer_id VARCHAR(6) NOT NULL,
username VARCHAR(20) NOT NULL,
email VARCHAR(20) NOT NULL,
userpw VARCHAR(20) NOT NULL,
reg_date DATE,
address VARCHAR(255),
contact_no NUMBER(15),
CONSTRAINT CUSTOMER_UNIQUE_KEY UNIQUE(username, email, userpw, contact_no),
CONSTRAINT CUSTOMER_START CHECK (customer_id LIKE 'C%'),
PRIMARY KEY (username),
FOREIGN KEY (customer_id) REFERENCES user_list(user_no)
)

CREATE TABLE cart (
cart_id VARCHAR(20),
user_id VARCHAR(6),
PRIMARY KEY (cart_id),
FOREIGN KEY (user_id) REFERENCES user_list(user_no))

CREATE TABLE category(
category_id VARCHAR(20) NOT NULL,
category_name VARCHAR(100) NOT NULL,
PRIMARY KEY (category_id)
)

CREATE TABLE product (
product_id VARCHAR(20) NOT NULL,
product_name VARCHAR(100) NOT NULL,
category_id VARCHAR(20) NOT NULL,
product_price NUMBER(10) NOT NULL,
product_image VARCHAR2(255) NOT NULL,
avaiable_qty NUMBER(6),
PRIMARY KEY (product_id),
FOREIGN KEY (category_id) REFERENCES category(category_id)
)

CREATE TABLE coupon(
coupon_id VARCHAR(6) NOT NULL,
coupon_name VARCHAR(20) NOT NULL,
discount_val NUMBER(6) NOT NULL,
expiry_date DATE,
PRIMARY KEY (coupon_id)
)

CREATE TABLE cart_item(
cart_item_no VARCHAR(20) NOT NULL,
cart_id VARCHAR(20),
user_id VARCHAR(6),
product_id VARCHAR(20),
product_qty NUMBER(6),
PRIMARY KEY (cart_item_no),
FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
FOREIGN KEY (user_id) REFERENCES user_list(user_no),
FOREIGN KEY (product_id) REFERENCES product(product_id)
)

CREATE TABLE orders (
order_id VARCHAR(20) NOT NULL,
cart_id VARCHAR(20) NOT NULL,
user_id VARCHAR(6) NOT NULL,
order_date DATE DEFAULT SYSDATE,
delivery_date DATE NOT NULL,
coupon_id VARCHAR(20) NOT NULL,
bill_amount NUMBER(6) NOT NULL,
payment_method VARCHAR(6) NOT NULL,
CONSTRAINT ORDER_DELIVERY_DATE_ATT CHECK (delivery_date = order_date + 7),
CONSTRAINT ORDER_PAYMENT_METHOD_ATT CHECK (payment_method IN ('COD','CREDIT','DEBIT','WALLET')),
PRIMARY KEY (order_id),
FOREIGN KEY (cart_id) REFERENCES cart(cart_id),
FOREIGN KEY (user_id) REFERENCES user_list(user_no),
FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
)