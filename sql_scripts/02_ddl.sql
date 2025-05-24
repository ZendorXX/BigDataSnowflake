CREATE TABLE dim_country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100)
);

CREATE TABLE dim_city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE dim_pet_type (
    pet_type_id SERIAL PRIMARY KEY,
    pet_type_name VARCHAR(100)
);

CREATE TABLE dim_pet_breed (
    pet_breed_id SERIAL PRIMARY KEY,
    pet_breed_name VARCHAR(100)
);

CREATE TABLE dim_pet_category (
    pet_category_id SERIAL PRIMARY KEY,
    pet_category_name VARCHAR(100)
);

CREATE TABLE dim_pet (
    pet_id             SERIAL PRIMARY KEY,
    name               VARCHAR(50),
    pet_type_id        INT REFERENCES dim_pet_type(pet_type_id),
    pet_breed_id       INT REFERENCES dim_pet_breed(pet_breed_id),
    pet_category_id    INT REFERENCES dim_pet_category(pet_category_id)
);  

CREATE TABLE dim_customer (
    customer_id        SERIAL PRIMARY KEY,
    first_name         VARCHAR(100),
    last_name          VARCHAR(100),
    age                INT,
    email              VARCHAR(255) UNIQUE,
    country_id         INT REFERENCES dim_country(country_id),
    postal_code        VARCHAR(20),
    pet_id             INT REFERENCES dim_pet(pet_id)
);

CREATE TABLE dim_seller (
    seller_id          SERIAL PRIMARY KEY,
    first_name         VARCHAR(100),
    last_name          VARCHAR(100),
    email              VARCHAR(255) UNIQUE,
    country_id         INT REFERENCES dim_country(country_id),
    postal_code        VARCHAR(20)
);

CREATE TABLE dim_supplier (
    supplier_id        SERIAL PRIMARY KEY,
    name               VARCHAR(200),
    contact            VARCHAR(200),
    email              VARCHAR(255) UNIQUE,
    phone              VARCHAR(50),
    address            TEXT,
    city_id            INT REFERENCES dim_city(city_id),
    country_id         INT REFERENCES dim_country(country_id)
); 

CREATE TABLE dim_store (
    store_id           SERIAL PRIMARY KEY,
    name               VARCHAR(200),
    location           VARCHAR(200),
    city_id            INT REFERENCES dim_city(city_id),
    state              VARCHAR(100),
    country_id         INT REFERENCES dim_country(country_id),
    phone              VARCHAR(50),
    email              VARCHAR(255)
);

CREATE TABLE dim_product_name (
    product_name_id  SERIAL    PRIMARY KEY,
    product_name     VARCHAR(50) UNIQUE
);

CREATE TABLE dim_product_category (
    category_id   SERIAL    PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE
);

CREATE TABLE dim_brand (
    brand_id      SERIAL    PRIMARY KEY,
    brand_name    VARCHAR(100) UNIQUE
);

CREATE TABLE dim_material (
    material_id   SERIAL    PRIMARY KEY,
    material_name VARCHAR(100) UNIQUE
);

CREATE TABLE dim_color (
    color_id      SERIAL    PRIMARY KEY,
    color_name    VARCHAR(50) UNIQUE
);

CREATE TABLE dim_size (
    size_id       SERIAL    PRIMARY KEY,
    size_name     VARCHAR(50) UNIQUE
);

CREATE TABLE dim_product (
    product_id         SERIAL PRIMARY KEY,
    product_name_id    INT REFERENCES dim_product_name(product_name_id),
    category_id        INT REFERENCES dim_product_category(category_id),
    price              NUMERIC(12,2),
    quantity           INT,
    weight             NUMERIC(12,2),
    color_id           INT REFERENCES dim_color(color_id),
    size_id            INT REFERENCES dim_size(size_id),
    brand_id           INT REFERENCES dim_brand(brand_id),
    material_id        INT REFERENCES dim_material(material_id),
    description        TEXT,
    rating             NUMERIC(3,2),
    reviews            INT,
    release_date       DATE,
    expiry_date        DATE,
    supplier_id        INT REFERENCES dim_supplier(supplier_id)
);

CREATE TABLE fact_sales (
    sale_id            SERIAL PRIMARY KEY,
    sale_date          DATE,
    customer_id        INT REFERENCES dim_customer(customer_id),
    seller_id          INT REFERENCES dim_seller(seller_id),
    store_id           INT REFERENCES dim_store(store_id),
    product_id         INT REFERENCES dim_product(product_id),
    sale_quantity      INT,
    sale_total_price   NUMERIC(14,2)
);