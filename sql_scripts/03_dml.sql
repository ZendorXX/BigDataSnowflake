INSERT INTO dim_country (country_name)
SELECT DISTINCT customer_country    FROM public.mock_data
UNION
SELECT DISTINCT seller_country      FROM public.mock_data
UNION
SELECT DISTINCT store_country       FROM public.mock_data
UNION
SELECT DISTINCT supplier_country    FROM public.mock_data;

INSERT INTO dim_city (city_name)
SELECT DISTINCT store_city          FROM public.mock_data
UNION
SELECT DISTINCT supplier_city       FROM public.mock_data;

INSERT INTO dim_product_name (product_name)
SELECT DISTINCT product_name        FROM public.mock_data;

INSERT INTO dim_product_category (category_name)
SELECT DISTINCT product_category    FROM public.mock_data;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT product_brand       FROM public.mock_data;

INSERT INTO dim_material (material_name)
SELECT DISTINCT product_material    FROM public.mock_data;

INSERT INTO dim_color (color_name)
SELECT DISTINCT product_color       FROM public.mock_data;

INSERT INTO dim_size (size_name)
SELECT DISTINCT product_size        FROM public.mock_data;

INSERT INTO dim_pet_type (pet_type_name)
SELECT DISTINCT customer_pet_type   FROM public.mock_data;

INSERT INTO dim_pet_breed (pet_breed_name)
SELECT DISTINCT customer_pet_breed  FROM public.mock_data;

INSERT INTO dim_pet_category (pet_category_name)
SELECT DISTINCT pet_category        FROM public.mock_data;

INSERT INTO dim_pet (name, pet_type_id, pet_breed_id, pet_category_id)
SELECT DISTINCT
    md.customer_pet_name,
    pt.pet_type_id,
    pb.pet_breed_id,
    pc.pet_category_id
FROM public.mock_data md
JOIN dim_pet_type pt ON md.customer_pet_type = pt.pet_type_name
JOIN dim_pet_breed pb ON md.customer_pet_breed = pb.pet_breed_name
JOIN dim_pet_category pc ON md.pet_category = pc.pet_category_name;

INSERT INTO dim_customer (first_name, last_name, age, email, country_id, postal_code, pet_id)
SELECT DISTINCT
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    c.country_id,
    customer_postal_code,
    pt.pet_id
FROM public.mock_data md
JOIN dim_country c ON md.customer_country = c.country_name
JOIN dim_pet_category AS dpc ON dpc.pet_category_name = md.pet_category
JOIN dim_pet_breed as dpb on dpb.pet_breed_name = md.customer_pet_breed
JOIN dim_pet_type as dpt on dpt.pet_type_name = md.customer_pet_type 
JOIN dim_pet       AS pt ON md.customer_pet_name = pt.name AND pt.pet_category_id = dpc.pet_category_id and pt.pet_breed_id  = dpb.pet_breed_id and pt.pet_type_id = dpt.pet_type_id;

INSERT INTO dim_seller (first_name, last_name, email, country_id, postal_code)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    c.country_id,
    seller_postal_code
FROM public.mock_data md
JOIN dim_country c ON md.seller_country = c.country_name;

INSERT INTO dim_supplier (name, contact, email, phone, address, city_id, country_id)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    ct.city_id,
    c.country_id
FROM public.mock_data md
JOIN dim_country c ON md.supplier_country = c.country_name
JOIN dim_city ct ON md.supplier_city = ct.city_name;

INSERT INTO dim_store (name, location, city_id, state, country_id, phone, email)
SELECT DISTINCT
    store_name,
    store_location,
    ct.city_id,
    store_state,
    c.country_id,
    store_phone,
    store_email
FROM public.mock_data md
JOIN dim_country c ON md.store_country = c.country_name
JOIN dim_city ct ON md.store_city = ct.city_name;

INSERT INTO dim_product (
    product_name_id, category_id, price, quantity, weight, color_id, size_id, brand_id, material_id,
    description, rating, reviews, release_date, expiry_date, supplier_id
)
SELECT DISTINCT
    dpn.product_name_id,
    dpc.category_id,
    product_price,
    product_quantity,
    product_weight,
    dc.color_id,
    ds.size_id,
    db.brand_id,
    dm.material_id,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date,
    ppp.supplier_id
FROM public.mock_data m
JOIN dim_product_name dpn ON dpn.product_name = m.product_name
JOIN dim_product_category dpc ON dpc.category_name = m.product_category
JOIN dim_brand db ON db.brand_name = m.product_brand
JOIN dim_material dm ON dm.material_name = m.product_material
JOIN dim_color dc ON dc.color_name = m.product_color
JOIN dim_size ds ON ds.size_name = m.product_size
JOIN dim_supplier  AS ppp ON m.supplier_email = ppp.email;

INSERT INTO fact_sales (
    sale_date, sale_quantity, sale_total_price, customer_id, seller_id, store_id, product_id
)
select
    m.sale_date,
    m.sale_quantity,
    m.sale_total_price,
    c.customer_id,
    s.seller_id,
    st.store_id,
    pr.product_id
FROM public.mock_data AS m
JOIN dim_customer  AS c  ON m.customer_email = c.email
JOIN dim_seller    AS s  ON m.seller_email   = s.email
JOIN dim_store     AS st ON m.store_name = st.name and m.store_location = st.location and m.store_phone = st.phone
JOIN dim_product_name dpn ON dpn.product_name = m.product_name
JOIN dim_product pr ON pr.product_name_id = dpn.product_name_id AND pr.price = m.product_price AND pr.quantity = m.product_quantity AND pr.weight = m.product_weight; 