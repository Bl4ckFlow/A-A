-- =============================================
-- E-COMMERCE DATABASE SCHEMA
-- Complete database structure for e-commerce platform
-- =============================================

-- Create database
DROP DATABASE ecommerce_db;
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- =============================================
-- USERS AND AUTHENTICATION TABLES
-- =============================================

-- Users table (customers and admins)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(255) NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_active (is_active)
);

-- User addresses
CREATE TABLE user_addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_type ENUM('billing', 'shipping', 'both') DEFAULT 'both',
    is_default BOOLEAN DEFAULT FALSE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    company VARCHAR(100),
    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- Password reset tokens
CREATE TABLE password_reset_tokens (
    token_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_user_id (user_id)
);

-- =============================================
-- PRODUCT CATALOG TABLES
-- =============================================

-- Product categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    parent_id INT NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    INDEX idx_parent_id (parent_id),
    INDEX idx_slug (slug),
    INDEX idx_active (is_active)
);

-- Brands/Manufacturers
CREATE TABLE brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    logo_url VARCHAR(500),
    website_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (slug),
    INDEX idx_active (is_active)
);

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    brand_id INT,
    sku VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    short_description TEXT,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    compare_price DECIMAL(10,2), -- for showing discounts
    cost_price DECIMAL(10,2), -- for profit calculations
    weight DECIMAL(8,2),
    dimensions VARCHAR(100), -- LxWxH
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    requires_shipping BOOLEAN DEFAULT TRUE,
    is_taxable BOOLEAN DEFAULT TRUE,
    meta_title VARCHAR(255),
    meta_description TEXT,
    stock_quantity INT DEFAULT 0,
    low_stock_threshold INT DEFAULT 5,
    track_inventory BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE SET NULL,
    INDEX idx_sku (sku),
    INDEX idx_slug (slug),
    INDEX idx_category_id (category_id),
    INDEX idx_brand_id (brand_id),
    INDEX idx_active (is_active),
    INDEX idx_featured (is_featured),
    INDEX idx_price (price)
);

-- Product images
CREATE TABLE product_images (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id)
);

-- Product variants (size, color, etc.)
CREATE TABLE product_variants (
    variant_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    sku VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2),
    compare_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    weight DECIMAL(8,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_sku (sku)
);

-- Product attributes (color, size, material, etc.)
CREATE TABLE product_attributes (
    attribute_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type ENUM('text', 'number', 'boolean', 'select', 'multiselect') DEFAULT 'text',
    is_required BOOLEAN DEFAULT FALSE,
    is_filterable BOOLEAN DEFAULT TRUE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product attribute values
CREATE TABLE product_attribute_values (
    value_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    attribute_id INT NOT NULL,
    value TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_id) REFERENCES product_attributes(attribute_id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_attribute_id (attribute_id)
);

-- =============================================
-- SHOPPING CART TABLES
-- =============================================

-- Shopping cart
CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    session_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_session_id (session_id)
);

-- Cart items
CREATE TABLE cart_items (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    INDEX idx_cart_id (cart_id)
);

-- =============================================
-- ORDER MANAGEMENT TABLES
-- =============================================

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'failed', 'refunded', 'partially_refunded') DEFAULT 'pending',
    currency VARCHAR(3) DEFAULT 'USD',
    subtotal DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    shipping_amount DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    
    -- Billing information
    billing_first_name VARCHAR(100) NOT NULL,
    billing_last_name VARCHAR(100) NOT NULL,
    billing_company VARCHAR(100),
    billing_address_1 VARCHAR(255) NOT NULL,
    billing_address_2 VARCHAR(255),
    billing_city VARCHAR(100) NOT NULL,
    billing_state VARCHAR(100),
    billing_postal_code VARCHAR(20) NOT NULL,
    billing_country VARCHAR(100) NOT NULL,
    billing_phone VARCHAR(20),
    
    -- Shipping information
    shipping_first_name VARCHAR(100),
    shipping_last_name VARCHAR(100),
    shipping_company VARCHAR(100),
    shipping_address_1 VARCHAR(255),
    shipping_address_2 VARCHAR(255),
    shipping_city VARCHAR(100),
    shipping_state VARCHAR(100),
    shipping_postal_code VARCHAR(20),
    shipping_country VARCHAR(100),
    shipping_phone VARCHAR(20),
    
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    shipped_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_order_number (order_number),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- Order items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT,
    product_name VARCHAR(255) NOT NULL,
    product_sku VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE RESTRICT,
    INDEX idx_order_id (order_id)
);

-- Order status history
CREATE TABLE order_status_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_order_id (order_id)
);

-- =============================================
-- PAYMENT TABLES
-- =============================================

-- Payment methods
CREATE TABLE payment_methods (
    payment_method_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payment transactions
CREATE TABLE payment_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    transaction_type ENUM('payment', 'refund', 'partial_refund') DEFAULT 'payment',
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status ENUM('pending', 'completed', 'failed', 'cancelled') DEFAULT 'pending',
    gateway_transaction_id VARCHAR(255),
    gateway_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id),
    INDEX idx_order_id (order_id),
    INDEX idx_gateway_transaction_id (gateway_transaction_id)
);

-- =============================================
-- COUPON AND DISCOUNT TABLES
-- =============================================

-- Coupons
CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type ENUM('percentage', 'fixed_amount', 'free_shipping') NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    minimum_amount DECIMAL(10,2) DEFAULT 0,
    usage_limit INT,
    usage_count INT DEFAULT 0,
    usage_limit_per_user INT DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    starts_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_active (is_active)
);

-- Coupon usage tracking
CREATE TABLE coupon_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_id INT NOT NULL,
    user_id INT,
    order_id INT NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_coupon_id (coupon_id),
    INDEX idx_user_id (user_id)
);

-- =============================================
-- REVIEWS AND RATINGS TABLES
-- =============================================

-- Product reviews
CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255),
    comment TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    is_approved BOOLEAN DEFAULT FALSE,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL,
    INDEX idx_product_id (product_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating)
);

-- =============================================
-- WISHLIST TABLES
-- =============================================

-- User wishlists
CREATE TABLE wishlists (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(255) DEFAULT 'My Wishlist',
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- Wishlist items
CREATE TABLE wishlist_items (
    wishlist_item_id INT PRIMARY KEY AUTO_INCREMENT,
    wishlist_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wishlist_id) REFERENCES wishlists(wishlist_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    INDEX idx_wishlist_id (wishlist_id),
    UNIQUE KEY unique_wishlist_product (wishlist_id, product_id, variant_id)
);

-- =============================================
-- INVENTORY TRACKING TABLES
-- =============================================

-- Inventory movements
CREATE TABLE inventory_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    variant_id INT,
    movement_type ENUM('in', 'out', 'adjustment') NOT NULL,
    quantity INT NOT NULL,
    reason VARCHAR(255),
    reference_type ENUM('order', 'return', 'adjustment', 'restock') NOT NULL,
    reference_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_product_id (product_id),
    INDEX idx_created_at (created_at)
);

-- =============================================
-- STORED PROCEDURES
-- =============================================

DELIMITER //

CREATE PROCEDURE RegisterUser(
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255),
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_date_of_birth DATE,
    IN p_gender VARCHAR(255)
)
BEGIN
    DECLARE user_exists INT DEFAULT 0;
    
    -- Check if user already exists
    SELECT COUNT(*) INTO user_exists FROM users WHERE email = p_email;
    
    IF user_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User with this email already exists';
    ELSE
        INSERT INTO users (
            email, password_hash, first_name, last_name, phone, date_of_birth, gender
        )
        VALUES (
            p_email, p_password_hash, p_first_name, p_last_name, p_phone, p_date_of_birth, p_gender
        );
        
        SELECT LAST_INSERT_ID() as user_id;
    END IF;
END //

-- User Login Procedure
CREATE PROCEDURE LoginUser(
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE user_count INT DEFAULT 0;
    
    SELECT COUNT(*) INTO user_count 
    FROM users 
    WHERE email = p_email AND password_hash = p_password_hash AND is_active = TRUE;
    
    IF user_count = 1 THEN
        UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE email = p_email;
        
        SELECT user_id, email, first_name, last_name, is_admin, email_verified
        FROM users 
        WHERE email = p_email AND password_hash = p_password_hash;
    ELSE
        SELECT NULL as user_id, 'Invalid credentials' as error_message;
    END IF;
END //

-- Add Product to Cart Procedure
CREATE PROCEDURE AddToCart(
    IN p_user_id INT,
    IN p_session_id VARCHAR(255),
    IN p_product_id INT,
    IN p_variant_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_cart_id INT;
    DECLARE v_product_price DECIMAL(10,2);
    DECLARE v_existing_quantity INT DEFAULT 0;
    
    -- Get or create cart
    SELECT cart_id INTO v_cart_id 
    FROM cart 
    WHERE (user_id = p_user_id OR session_id = p_session_id) 
    ORDER BY created_at DESC 
    LIMIT 1;
    
    IF v_cart_id IS NULL THEN
        INSERT INTO cart (user_id, session_id) VALUES (p_user_id, p_session_id);
        SET v_cart_id = LAST_INSERT_ID();
    END IF;
    
    -- Get product price
    IF p_variant_id IS NOT NULL THEN
        SELECT COALESCE(price, (SELECT price FROM products WHERE product_id = p_product_id)) 
        INTO v_product_price 
        FROM product_variants 
        WHERE variant_id = p_variant_id;
    ELSE
        SELECT price INTO v_product_price FROM products WHERE product_id = p_product_id;
    END IF;
    
    -- Check if item already exists in cart
    SELECT quantity INTO v_existing_quantity
    FROM cart_items 
    WHERE cart_id = v_cart_id 
      AND product_id = p_product_id 
      AND (variant_id = p_variant_id OR (variant_id IS NULL AND p_variant_id IS NULL));
    
    IF v_existing_quantity > 0 THEN
        -- Update existing item
        UPDATE cart_items 
        SET quantity = quantity + p_quantity,
            price = v_product_price
        WHERE cart_id = v_cart_id 
          AND product_id = p_product_id 
          AND (variant_id = p_variant_id OR (variant_id IS NULL AND p_variant_id IS NULL));
    ELSE
        -- Add new item
        INSERT INTO cart_items (cart_id, product_id, variant_id, quantity, price)
        VALUES (v_cart_id, p_product_id, p_variant_id, p_quantity, v_product_price);
    END IF;
    
    SELECT 'Item added to cart successfully' as message;
END //

-- Create Order Procedure
CREATE PROCEDURE CreateOrder(
    IN p_user_id INT,
    IN p_cart_id INT,
    IN p_billing_first_name VARCHAR(100),
    IN p_billing_last_name VARCHAR(100),
    IN p_billing_address_1 VARCHAR(255),
    IN p_billing_city VARCHAR(100),
    IN p_billing_postal_code VARCHAR(20),
    IN p_billing_country VARCHAR(100),
    IN p_shipping_first_name VARCHAR(100),
    IN p_shipping_last_name VARCHAR(100),
    IN p_shipping_address_1 VARCHAR(255),
    IN p_shipping_city VARCHAR(100),
    IN p_shipping_postal_code VARCHAR(20),
    IN p_shipping_country VARCHAR(100)
)
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_order_number VARCHAR(50);
    DECLARE v_subtotal DECIMAL(10,2) DEFAULT 0;
    DECLARE v_tax_amount DECIMAL(10,2) DEFAULT 0;
    DECLARE v_shipping_amount DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total_amount DECIMAL(10,2) DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_product_id INT;
    DECLARE v_variant_id INT;
    DECLARE v_quantity INT;
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_product_name VARCHAR(255);
    DECLARE v_product_sku VARCHAR(100);
    
    -- Cursor for cart items
    DECLARE cart_cursor CURSOR FOR
        SELECT ci.product_id, ci.variant_id, ci.quantity, ci.price, p.name, 
               COALESCE(pv.sku, p.sku) as sku
        FROM cart_items ci
        JOIN products p ON ci.product_id = p.product_id
        LEFT JOIN product_variants pv ON ci.variant_id = pv.variant_id
        WHERE ci.cart_id = p_cart_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Calculate subtotal
    SELECT SUM(quantity * price) INTO v_subtotal 
    FROM cart_items 
    WHERE cart_id = p_cart_id;
    
    -- Calculate tax (example: 10%)
    SET v_tax_amount = v_subtotal * 0.10;
    
    -- Calculate shipping (example: flat rate $10)
    SET v_shipping_amount = 10.00;
    
    -- Calculate total
    SET v_total_amount = v_subtotal + v_tax_amount + v_shipping_amount;
    
    -- Generate order number
    SET v_order_number = CONCAT('ORD-', DATE_FORMAT(NOW(), '%Y%m%d'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- Create order
    INSERT INTO orders (
        user_id, order_number, subtotal, tax_amount, shipping_amount, total_amount,
        billing_first_name, billing_last_name, billing_address_1, billing_city, 
        billing_postal_code, billing_country,
        shipping_first_name, shipping_last_name, shipping_address_1, shipping_city,
        shipping_postal_code, shipping_country
    ) VALUES (
        p_user_id, v_order_number, v_subtotal, v_tax_amount, v_shipping_amount, v_total_amount,
        p_billing_first_name, p_billing_last_name, p_billing_address_1, p_billing_city,
        p_billing_postal_code, p_billing_country,
        p_shipping_first_name, p_shipping_last_name, p_shipping_address_1, p_shipping_city,
        p_shipping_postal_code, p_shipping_country
    );
    
    SET v_order_id = LAST_INSERT_ID();
    
    -- Add order items
    OPEN cart_cursor;
    read_loop: LOOP
        FETCH cart_cursor INTO v_product_id, v_variant_id, v_quantity, v_price, v_product_name, v_product_sku;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        INSERT INTO order_items (order_id, product_id, variant_id, product_name, product_sku, quantity, unit_price, total_price)
        VALUES (v_order_id, v_product_id, v_variant_id, v_product_name, v_product_sku, v_quantity, v_price, v_quantity * v_price);
        
        -- Update inventory
        IF v_variant_id IS NOT NULL THEN
            UPDATE product_variants SET stock_quantity = stock_quantity - v_quantity WHERE variant_id = v_variant_id;
        ELSE
            UPDATE products SET stock_quantity = stock_quantity - v_quantity WHERE product_id = v_product_id;
        END IF;
        
        -- Record inventory movement
        INSERT INTO inventory_movements (product_id, variant_id, movement_type, quantity, reason, reference_type, reference_id)
        VALUES (v_product_id, v_variant_id, 'out', v_quantity, 'Order sale', 'order', v_order_id);
        
    END LOOP;
    CLOSE cart_cursor;
    
    -- Clear cart
    DELETE FROM cart_items WHERE cart_id = p_cart_id;
    
    -- Add order status history
    INSERT INTO order_status_history (order_id, status, comment)
    VALUES (v_order_id, 'pending', 'Order created');
    
    SELECT v_order_id as order_id, v_order_number as order_number, v_total_amount as total_amount;
END //

-- Update Order Status Procedure
CREATE PROCEDURE UpdateOrderStatus(
    IN p_order_id INT,
    IN p_status VARCHAR(50),
    IN p_comment TEXT,
    IN p_updated_by INT
)
BEGIN
    UPDATE orders 
    SET status = p_status, 
        updated_at = CURRENT_TIMESTAMP,
        shipped_at = CASE WHEN p_status = 'shipped' THEN CURRENT_TIMESTAMP ELSE shipped_at END,
        delivered_at = CASE WHEN p_status = 'delivered' THEN CURRENT_TIMESTAMP ELSE delivered_at END
    WHERE order_id = p_order_id;
    
    INSERT INTO order_status_history (order_id, status, comment, created_by)
    VALUES (p_order_id, p_status, p_comment, p_updated_by);
    
    SELECT 'Order status updated successfully' as message;
END //

-- Get Low Stock Products Procedure
CREATE PROCEDURE GetLowStockProducts()
BEGIN
    SELECT 
        p.product_id,
        p.name,
        p.sku,
        p.stock_quantity,
        p.low_stock_threshold,
        c.name as category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.category_id
    WHERE p.track_inventory = TRUE 
      AND p.stock_quantity <= p.low_stock_threshold
      AND p.is_active = TRUE
    ORDER BY p.stock_quantity ASC;
END //

-- Get Sales Report Procedure
CREATE PROCEDURE GetSalesReport(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        DATE(o.created_at) as order_date,
        COUNT(o.order_id) as total_orders,
        SUM(o.total_amount) as total_revenue,
        AVG(o.total_amount) as average_order_value,
        SUM(o.subtotal) as total_subtotal,
        SUM(o.tax_amount) as total_tax,
        SUM(o.shipping_amount) as total_shipping
    FROM orders o
    WHERE DATE(o.created_at) BETWEEN p_start_date AND p_end_date
      AND o.status NOT IN ('cancelled', 'refunded')
    GROUP BY DATE(o.created_at)
    ORDER BY order_date DESC;
END //

-- Search Products Procedure
CREATE PROCEDURE SearchProducts(
    IN p_search_term VARCHAR(255),
    IN p_category_id INT,
    IN p_min_price DECIMAL(10,2),
    IN p_max_price DECIMAL(10,2),
    IN p_sort_by VARCHAR(50),
    IN p_sort_order VARCHAR(4),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SET @sql = 'SELECT 
        p.product_id,
        p.name,
        p.slug,
        p.short_description,
        p.price,
        p.compare_price,
        p.stock_quantity,
        p.is_featured,
        c.name as category_name,
        b.name as brand_name,
        (SELECT image_url FROM product_images pi WHERE pi.product_id = p.product_id AND pi.is_primary = TRUE LIMIT 1) as primary_image,
        (SELECT AVG(rating) FROM product_reviews pr WHERE pr.product_id = p.product_id AND pr.is_approved = TRUE) as avg_rating,
        (SELECT COUNT(*) FROM product_reviews pr WHERE pr.product_id = p.product_id AND pr.is_approved = TRUE) as review_count
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.category_id
    LEFT JOIN brands b ON p.brand_id = b.brand_id
    WHERE p.is_active = TRUE';
    
    -- Add search term filter
    IF p_search_term IS NOT NULL AND p_search_term != '' THEN
        SET @sql = CONCAT(@sql, ' AND (p.name LIKE ''%', p_search_term, '%'' OR p.description LIKE ''%', p_search_term, '%'' OR p.sku LIKE ''%', p_search_term, '%'')');
    END IF;
    
    -- Add category filter
    IF p_category_id IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.category_id = ', p_category_id);
    END IF;
    
    -- Add price filters
    IF p_min_price IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.price >= ', p_min_price);
    END IF;
    
    IF p_max_price IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.price <= ', p_max_price);
    END IF;
    
    -- Add sorting
    IF p_sort_by IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' ORDER BY ');
        CASE p_sort_by
            WHEN 'name' THEN SET @sql = CONCAT(@sql, 'p.name');
            WHEN 'price' THEN SET @sql = CONCAT(@sql, 'p.price');
            WHEN 'created' THEN SET @sql = CONCAT(@sql, 'p.created_at');
            WHEN 'rating' THEN SET @sql = CONCAT(@sql, 'avg_rating');
            ELSE SET @sql = CONCAT(@sql, 'p.created_at');
        END CASE;
        
        IF p_sort_order = 'DESC' THEN
            SET @sql = CONCAT(@sql, ' DESC');
        ELSE
            SET @sql = CONCAT(@sql, ' ASC');
        END IF;
    END IF;
    
    -- Add limit and offset
    IF p_limit IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' LIMIT ', p_limit);
        IF p_offset IS NOT NULL THEN
            SET @sql = CONCAT(@sql, ' OFFSET ', p_offset);
        END IF;
    END IF;
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //


-- apply coupon
CREATE PROCEDURE ApplyCoupon(
    IN p_coupon_code VARCHAR(50),
    IN p_user_id INT,
    IN p_cart_total DECIMAL(10,2)
)
BEGIN
    -- Declare coupon-related variables
    DECLARE v_coupon_id INT;
    DECLARE v_type VARCHAR(20);
    DECLARE v_value DECIMAL(10,2);
    DECLARE v_min_amount DECIMAL(10,2);
    DECLARE v_usage_limit INT;
    DECLARE v_usage_count INT;
    DECLARE v_limit_per_user INT;
    DECLARE v_is_active BOOLEAN;
    DECLARE v_start TIMESTAMP;
    DECLARE v_expire TIMESTAMP;

    -- Computed values
    DECLARE v_user_usage INT DEFAULT 0;
    DECLARE v_discount DECIMAL(10,2) DEFAULT 0;

    -- Try to get the coupon
    SELECT 
        coupon_id, type, value, minimum_amount, 
        usage_limit, usage_count, usage_limit_per_user,
        is_active, starts_at, expires_at
    INTO 
        v_coupon_id, v_type, v_value, v_min_amount,
        v_usage_limit, v_usage_count, v_limit_per_user,
        v_is_active, v_start, v_expire
    FROM coupons
    WHERE code = p_coupon_code;

    -- If not found
    IF v_coupon_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid coupon code';
    END IF;

    -- Check active
    IF NOT v_is_active THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Coupon is not active';
    END IF;

    -- Check date validity
    IF v_start IS NOT NULL AND NOW() < v_start THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Coupon is not yet valid';
    END IF;

    IF v_expire IS NOT NULL AND NOW() > v_expire THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Coupon has expired';
    END IF;

    -- Minimum cart amount
    IF v_min_amount IS NOT NULL AND p_cart_total < v_min_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimum order amount required, check coupon details';
    END IF;

    -- Global usage limit
    IF v_usage_limit IS NOT NULL AND v_usage_count >= v_usage_limit THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Coupon usage limit reached';
    END IF;

    -- Per-user usage
    IF v_limit_per_user IS NOT NULL THEN
        SELECT COUNT(*) INTO v_user_usage
        FROM coupon_usage
        WHERE user_id = p_user_id AND coupon_id = v_coupon_id;

        IF v_user_usage >= v_limit_per_user THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have reached your usage limit for this coupon';
        END IF;
    END IF;

    -- Calculate discount
    IF v_type = 'percentage' THEN
        SET v_discount = p_cart_total * (v_value / 100);
    ELSEIF v_type = 'fixed_amount' THEN
        SET v_discount = v_value;
    ELSEIF v_type = 'free_shipping' THEN
        SET v_discount = 0; -- Applied during shipping, not cart total
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unknown coupon type';
    END IF;

    -- Cap discount
    IF v_discount > p_cart_total THEN
        SET v_discount = p_cart_total;
    END IF;

    -- Return the result
    SELECT 
        v_coupon_id AS coupon_id,
        v_type AS coupon_type,
        v_discount AS discount_amount,
        'Coupon applied successfully' AS message;
END //

-- Get Customer Order History Procedure
CREATE PROCEDURE GetCustomerOrderHistory(
    IN p_user_id INT,
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT 
        o.order_id,
        o.order_number,
        o.status,
        o.payment_status,
        o.total_amount,
        o.created_at,
        o.shipped_at,
        o.delivered_at,
        COUNT(oi.order_item_id) as item_count
    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.user_id = p_user_id
    GROUP BY o.order_id
    ORDER BY o.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END //

-- Update Product Stock Procedure
CREATE PROCEDURE UpdateProductStock(
    IN p_product_id INT,
    IN p_variant_id INT,
    IN p_quantity INT,
    IN p_movement_type ENUM('in', 'out', 'adjustment'),
    IN p_reason VARCHAR(255),
    IN p_updated_by INT
)
BEGIN
    -- Update stock
    IF p_variant_id IS NOT NULL THEN
        UPDATE product_variants 
        SET stock_quantity = CASE 
            WHEN p_movement_type = 'in' THEN stock_quantity + p_quantity
            WHEN p_movement_type = 'out' THEN stock_quantity - p_quantity
            ELSE p_quantity
        END
        WHERE variant_id = p_variant_id;
    ELSE
        UPDATE products 
        SET stock_quantity = CASE 
            WHEN p_movement_type = 'in' THEN stock_quantity + p_quantity
            WHEN p_movement_type = 'out' THEN stock_quantity - p_quantity
            ELSE p_quantity
        END
        WHERE product_id = p_product_id;
    END IF;
    
    -- Record movement
    INSERT INTO inventory_movements (product_id, variant_id, movement_type, quantity, reason, reference_type, created_by)
    VALUES (p_product_id, p_variant_id, p_movement_type, 
            CASE WHEN p_movement_type = 'out' THEN -p_quantity ELSE p_quantity END, 
            p_reason, 'adjustment', p_updated_by);
    
    SELECT 'Stock updated successfully' as message;
END //

DELIMITER ;

-- =============================================
-- DEFAULT DATA INSERTION
-- =============================================

-- Insert default payment methods
INSERT INTO payment_methods (name, code, description, is_active, sort_order) VALUES
('Credit Card', 'credit_card', 'Pay with credit or debit card', TRUE, 1),
('PayPal', 'paypal', 'Pay with your PayPal account', TRUE, 2),
('Bank Transfer', 'bank_transfer', 'Direct bank transfer', TRUE, 3),
('Cash on Delivery', 'cod', 'Pay when you receive your order', TRUE, 4);

-- Insert default product attributes
INSERT INTO product_attributes (name, type, is_required, is_filterable, sort_order) VALUES
('Color', 'select', FALSE, TRUE, 1),
('Size', 'select', FALSE, TRUE, 2),
('Material', 'text', FALSE, TRUE, 3),
('Weight', 'number', FALSE, FALSE, 4),
('Dimensions', 'text', FALSE, FALSE, 5);

-- Insert sample admin user (password should be hashed in real implementation)
INSERT INTO users (email, password_hash, first_name, last_name, phone, date_of_birth, gender, is_admin, is_active, email_verified) VALUES
('admin@yourstore.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'User', '000-000-0000', '1970-01-01', 'Male', TRUE, TRUE, TRUE);

-- Insert sample categories
INSERT INTO categories (name, slug, description, is_active, sort_order) VALUES
('Electronics', 'electronics', 'Electronic devices and gadgets', TRUE, 1),
('Clothing', 'clothing', 'Fashion and apparel', TRUE, 2),
('Home & Garden', 'home-garden', 'Home improvement and garden supplies', TRUE, 3),
('Sports & Outdoors', 'sports-outdoors', 'Sports equipment and outdoor gear', TRUE, 4),
('Books', 'books', 'Books and literature', TRUE, 5);

-- Insert sample brands
INSERT INTO brands (name, slug, description, is_active) VALUES
('TechBrand', 'techbrand', 'Leading technology brand', TRUE),
('FashionCorp', 'fashioncorp', 'Premium fashion brand', TRUE),
('HomePro', 'homepro', 'Home improvement specialists', TRUE);

-- Insert sample coupon
INSERT INTO coupons (code, name, description, type, value, minimum_amount, usage_limit, is_active, expires_at) VALUES
('WELCOME10', 'Welcome Discount', 'Get 10% off your first order', 'percentage', 10.00, 50.00, 1000, TRUE, DATE_ADD(NOW(), INTERVAL 1 YEAR));

-- =============================================
-- USEFUL VIEWS
-- =============================================

-- Product catalog view with all details
CREATE VIEW v_product_catalog AS
SELECT 
    p.product_id,
    p.sku,
    p.name,
    p.slug,
    p.short_description,
    p.description,
    p.price,
    p.compare_price,
    p.stock_quantity,
    p.is_active,
    p.is_featured,
    c.name as category_name,
    c.slug as category_slug,
    b.name as brand_name,
    b.slug as brand_slug,
    (SELECT image_url FROM product_images pi WHERE pi.product_id = p.product_id AND pi.is_primary = TRUE LIMIT 1) as primary_image_url,
    (SELECT AVG(rating) FROM product_reviews pr WHERE pr.product_id = p.product_id AND pr.is_approved = TRUE) as avg_rating,
    (SELECT COUNT(*) FROM product_reviews pr WHERE pr.product_id = p.product_id AND pr.is_approved = TRUE) as review_count,
    p.created_at,
    p.updated_at
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN brands b ON p.brand_id = b.brand_id;

-- Order summary view
CREATE VIEW v_order_summary AS
SELECT 
    o.order_id,
    o.order_number,
    CONCAT(u.first_name, ' ', u.last_name) as customer_name,
    u.email as customer_email,
    o.status,
    o.payment_status,
    o.total_amount,
    o.created_at,
    o.updated_at,
    COUNT(oi.order_item_id) as item_count,
    SUM(oi.quantity) as total_quantity
FROM orders o
LEFT JOIN users u ON o.user_id = u.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- Low stock alert view
CREATE VIEW v_low_stock_alert AS
SELECT 
    p.product_id,
    p.name,
    p.sku,
    p.stock_quantity,
    p.low_stock_threshold,
    c.name as category_name,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Out of Stock'
        WHEN p.stock_quantity <= p.low_stock_threshold THEN 'Low Stock'
        ELSE 'In Stock'
    END as stock_status
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.track_inventory = TRUE 
  AND p.stock_quantity <= p.low_stock_threshold
  AND p.is_active = TRUE;

-- Sales analytics view
CREATE VIEW v_sales_analytics AS
SELECT 
    DATE(o.created_at) as sale_date,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_revenue,
    AVG(o.total_amount) as avg_order_value,
    SUM(oi.quantity) as total_items_sold
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status NOT IN ('cancelled', 'refunded')
GROUP BY DATE(o.created_at);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- Additional indexes for better performance
CREATE INDEX idx_products_category_active ON products(category_id, is_active);
CREATE INDEX idx_products_brand_active ON products(brand_id, is_active);
CREATE INDEX idx_products_featured_active ON products(is_featured, is_active);
CREATE INDEX idx_products_price_active ON products(price, is_active);
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_orders_date_status ON orders(created_at, status);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_product_reviews_approved ON product_reviews(product_id, is_approved);
CREATE INDEX idx_inventory_movements_date ON inventory_movements(created_at);

-- =============================================
-- TRIGGERS FOR BUSINESS LOGIC
-- =============================================

DELIMITER //

-- Trigger to update product updated_at when stock changes
CREATE TRIGGER tr_product_stock_update 
AFTER UPDATE ON products 
FOR EACH ROW
BEGIN
    IF OLD.stock_quantity != NEW.stock_quantity THEN
        UPDATE products SET updated_at = CURRENT_TIMESTAMP WHERE product_id = NEW.product_id;
    END IF;
END //

-- Trigger to update order total when order items change
CREATE TRIGGER tr_order_total_update 
AFTER INSERT ON order_items 
FOR EACH ROW
BEGIN
    UPDATE orders 
    SET subtotal = (SELECT SUM(total_price) FROM order_items WHERE order_id = NEW.order_id),
        total_amount = subtotal + tax_amount + shipping_amount - discount_amount
    WHERE order_id = NEW.order_id;
END //

-- Trigger to create default wishlist for new users
CREATE TRIGGER tr_create_default_wishlist 
AFTER INSERT ON users 
FOR EACH ROW
BEGIN
    INSERT INTO wishlists (user_id, name, is_public) 
    VALUES (NEW.user_id, 'My Wishlist', FALSE);
END //

DELIMITER ;

-- =============================================
-- FINAL NOTES
-- =============================================

/*
USAGE EXAMPLES:

1. Register a new user:
CALL RegisterUser('john@example.com', 'hashed_password', 'John', 'Doe', '+1234567890');

2. Login user:
CALL LoginUser('john@example.com', 'hashed_password');

3. Add product to cart:
CALL AddToCart(1, 'session123', 1, NULL, 2);

4. Create order:
CALL CreateOrder(1, 1, 'John', 'Doe', '123 Main St', 'City', '12345', 'USA', 'John', 'Doe', '123 Main St', 'City', '12345', 'USA');

5. Update order status:
CALL UpdateOrderStatus(1, 'shipped', 'Order shipped via FedEx', 1);

6. Search products:
CALL SearchProducts('laptop', 1, 100.00, 2000.00, 'price', 'ASC', 10, 0);

7. Apply coupon:
CALL ApplyCoupon('WELCOME10', 1, 150.00);

8. Get sales report:
CALL GetSalesReport('2024-01-01', '2024-12-31');

9. Update stock:
CALL UpdateProductStock(1, NULL, 10, 'in', 'Restocked', 1);

10. Get low stock products:
CALL GetLowStockProducts();

SECURITY CONSIDERATIONS:
- Always hash passwords before storing (use bcrypt or similar)
- Use prepared statements to prevent SQL injection
- Implement proper authentication and authorization
- Add rate limiting for login attempts
- Encrypt sensitive data like payment information
- Regular database backups
- Monitor for suspicious activities

PERFORMANCE OPTIMIZATION:
- Use appropriate indexes (already included)
- Consider partitioning large tables by date
- Implement caching for frequently accessed data
- Use read replicas for reporting queries
- Regular database maintenance and optimization

This schema provides a solid foundation for an e-commerce platform and can be extended based on specific business requirements.
*/