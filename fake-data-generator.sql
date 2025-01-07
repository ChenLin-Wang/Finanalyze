DO $$
DECLARE
    i int;
    random_name text;
    random_email text;
    random_password text;
    random_created_at text;
    random_updated_at text;
    email_domains text[];
BEGIN
    -- 定义常见的邮箱域名
    email_domains := ARRAY['gmail.com', 'icloud.com', 'yahoo.com', 'outlook.com', 'hotmail.com', 'protonmail.com'];

    FOR i IN 1..20 LOOP
        -- 随机生成名字部分（由一些常见名字组成）
        random_name := (ARRAY[
            'alice', 'bob', 'charlie', 'david', 'eve', 'frank', 'grace', 'hannah', 'iris', 'jack',
            'kate', 'leo', 'mike', 'nina', 'olivia', 'paul', 'quinn', 'rachel', 'sam', 'tina',
            'ursula', 'victor', 'wally', 'xander', 'yvonne', 'zane', 'aaron', 'bella', 'carl', 'diana'
        ])[FLOOR(RANDOM() * 30) + 1]; -- 随机选择30个名字中的一个
		
        -- 随机生成邮箱（名字+随机数+邮箱域名）
        random_email := random_name || FLOOR(RANDOM() * 1000) || '@' || email_domains[FLOOR(RANDOM() * 6) + 1];

        -- 随机生成创建和更新时间（不超过当前时间）
        random_created_at := TO_CHAR(NOW() - (FLOOR(RANDOM() * 365)::int || ' days')::interval, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');
        random_updated_at := TO_CHAR(NOW() - (FLOOR(RANDOM() * 365)::int || ' days')::interval, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');

        -- 插入用户数据
        INSERT INTO users (
            id,
            email,
            password,
            is_active,
            is_verified,
            created_at,
            updated_at
        ) VALUES (
            gen_random_uuid(), -- 随机生成 UUID
            random_email,
            '$2b$12$Pzir1qMWlWsBKFrMc45IF.jpXbYA2Yp5NnH52f8H4B/RrZYlh/hfe', -- 12345678
            true,               -- is_active 固定为 true
            false,              -- is_verified 固定为 false
            random_created_at,
            random_updated_at
        );
    END LOOP;
END $$;




DO $$
DECLARE
    user_id uuid;
    username text;
    first_name text;
    middle_name text;
    last_name text;
    avatar text;
    age smallint;
    gender text;
    birthday date;
    address text;
    phone_number text;
    course text;
    year_lvl text;
    school text;
BEGIN
    -- 遍历每个用户
    FOR user_id IN SELECT id FROM users LOOP
    
    	IF user_id = '00000000-0000-0000-0000-000000000000' THEN
            CONTINUE;
        END IF;
        
        -- 生成用户名（截取 email 去掉域名部分）
        username := (SELECT split_part(email, '@', 1) FROM users WHERE id = user_id);
        
        -- 生成随机的用户信息
        first_name := 'First_' || FLOOR(RANDOM() * 1000);
        middle_name := CASE WHEN RANDOM() > 0.5 THEN 'Middle_' || FLOOR(RANDOM() * 1000) ELSE NULL END;
        last_name := 'Last_' || FLOOR(RANDOM() * 1000);
        age := FLOOR(RANDOM() * (60 - 18 + 1) + 18); -- 随机年龄，范围 18-60
        gender := CASE WHEN RANDOM() > 0.5 THEN 'Male' ELSE 'Female' END;
        birthday := CURRENT_DATE - (FLOOR(RANDOM() * 10000) + 6575)::int; -- 随机生日
        address := 'Address_' || FLOOR(RANDOM() * 1000);
        phone_number := '+1-' || FLOOR(RANDOM() * 1000000000)::text; -- 随机电话
        course := CASE WHEN RANDOM() > 0.5 THEN 'Course_' || FLOOR(RANDOM() * 1000) ELSE NULL END;
        year_lvl := CASE WHEN RANDOM() > 0.5 THEN 'Year_' || FLOOR(RANDOM() * 5 + 1) ELSE NULL END;
        school := CASE WHEN RANDOM() > 0.5 THEN 'School_' || FLOOR(RANDOM() * 1000) ELSE NULL END;
        
        -- 插入用户信息
        INSERT INTO user_infos (
        	id,
            user_id,
            username,
            first_name,
            middle_name,
            last_name,
            avatar,
            age,
            gender,
            birthday,
            address,
            phone_number,
            course,
            year_lvl,
            school
        ) VALUES (
        	gen_random_uuid(),
            user_id,
            username,
            first_name,
            middle_name,
            last_name,
            'https://api.finanalyze.whooshings.space/images/default.png',
            age,
            gender,
            birthday,
            address,
            phone_number,
            course,
            year_lvl,
            school
        );
    END LOOP;
END $$;






DO $$
DECLARE
    user_id uuid;
    transaction_count int;
    i int;
    random_transaction_date date;
    random_item_name text;
    random_item_amount smallint;
    random_price_per_unit numeric;
    random_total_price numeric;
    random_location text;
    random_brand text;
    random_category text;
    categories text[] := ARRAY[
        'Food',
        'Clothing',
        'Shelter',
        'Utilities',
        'Transportation',
        'Healthcare',
        'Education',
        'Entertainment',
        'Electronics',
        'Furniture',
        'Household Appliances',
        'Personal Care Products',
        'Luxury Goods',
        'Sports Equipment',
        'Travel',
        'Financial Services',
        'Insurance',
        'Communication Devices',
        'Subscription Services',
        'Books and Media'
    ];
	item_names text[] := ARRAY[
	    'Laptop', 'Smartphone', 'T-shirt', 'Jeans', 'Fridge', 'Washing Machine', 
	    'Headphones', 'Smartwatch', 'Couch', 'Dining Table', 'Blender', 
	    'Toothpaste', 'Shampoo', 'Gaming Console', 'Air Conditioner', 'Microwave', 
	    'Yoga Mat', 'Basketball', 'Bike', 'Tennis Racket', 'Television', 'Monitor', 
	    'Keyboard', 'Mouse', 'Tablet', 'Camera', 'Speaker', 'Coffee Maker', 
	    'Rice Cooker', 'Juicer', 'Water Purifier', 'Hair Dryer', 'Iron', 'Fan', 
	    'Sofa', 'Bookshelf', 'Curtains', 'Desk Lamp', 'Rug', 'Dining Chair', 
	    'Cabinet', 'Mirror', 'Luggage', 'Backpack', 'Sneakers', 'Boots', 
	    'Sandals', 'Jacket', 'Coat', 'Sweater', 'Shirt', 'Shorts', 'Gloves', 
	    'Hat', 'Sunglasses', 'Watch', 'Wallet', 'Briefcase', 'Shoes', 
	    'Pants', 'Tote Bag', 'Scarf', 'Sweatshirt', 'Sweatpants', 'Dress', 
	    'Skirt', 'Pajamas', 'Perfume', 'Lipstick', 'Foundation', 'Earrings', 
	    'Necklace', 'Bracelet', 'Ring', 'Hair Straightener', 'Hair Curler', 
	    'Nail Polish', 'Shaving Kit', 'Toothbrush', 'Floss', 'Shaver', 
	    'Towels', 'Bedsheet', 'Pillow', 'Mattress', 'Blanket', 'Comforter', 
	    'Bedding Set', 'Cloth Hangers', 'Laundry Basket', 'Dishwasher', 'Oven', 
	    'Grill', 'Pressure Cooker', 'Air Fryer', 'Coffee Grinder', 'Waffle Maker', 
	    'Popcorn Machine', 'Kettle', 'Scale', 'Toaster', 'Fridge Organizer', 
	    'Drawer Organizer', 'Dish Rack', 'Cutlery Set', 'Water Bottle', 
	    'Smart Lock', 'Security Camera', 'Smoke Detector', 'Air Purifier', 
	    'Dehumidifier', 'Space Heater', 'Hand Warmer', 'Massage Chair'
	];
	brands text[] := ARRAY[
	    'Apple', 'Samsung', 'Nike', 'Adidas', 'Sony', 'LG', 'Dell', 'HP', 
	    'Ikea', 'Levis', 'Nestle', 'Coca-Cola', 'Tesla', 'Microsoft', 'Intel', 
	    'Huawei', 'Xiaomi', 'OnePlus', 'Lenovo', 'Canon', 'Bose', 'Razer', 
	    'Logitech', 'Seiko', 'Rolex', 'Casio', 'Fossil', 'Puma', 'Reebok', 
	    'Under Armour', 'Vans', 'New Balance', 'Fila', 'Skechers', 'Columbia', 
	    'The North Face', 'Patagonia', 'Colgate', 'Procter & Gamble', 'Unilever', 
	    'Johnson & Johnson', 'Dove', 'Olay', 'LOreal', 'Estée Lauder', 'Maybelline', 
	    'Chanel', 'Gucci', 'Prada', 'Louis Vuitton', 'Burberry', 'Versace', 
	    'H&M', 'Zara', 'Gap', 'Uniqlo', 'Mango', 'Marks & Spencer', 'Tommy Hilfiger', 
	    'Calvin Klein', 'Abercrombie & Fitch', 'Hollister', 'American Eagle', 
	    'Old Navy', 'Forever 21', 'Banana Republic', 'J.Crew', 'Eddie Bauer', 
	    'Levis', 'Wrangler', 'Dockers', 'Tommy Jeans', 'Carhartt', 'Wrangler', 
	    'Sperry', 'Caterpillar', 'Timberland', 'Dr. Martens', 'Vans', 'Converse', 
	    'Jordan', 'Nike SB', 'Adidas Originals', 'Lacoste', 'Pepsi', 'Sprite', 
	    'Mountain Dew', 'Red Bull', 'Dr. Pepper', 'Gatorade', 'Kelloggs', 
	    'General Mills', 'Heinz', 'McDonalds', 'Burger King', 'KFC', 'Pizza Hut', 
	    'Starbucks', 'Subway', 'Dominos', 'Chipotle', 'Taco Bell', 'Wendys'
	];
BEGIN
    -- 遍历每个用户
    FOR user_id IN SELECT id FROM users LOOP
    
    	IF user_id = '00000000-0000-0000-0000-000000000000' THEN
            CONTINUE;
        END IF;
    
        -- 每个用户生成随机交易数量（0～10个）
        transaction_count := 10 + FLOOR(RANDOM() * 1000); -- 随机生成 10～130

        FOR i IN 1..transaction_count LOOP
            -- 生成随机数据
            random_transaction_date := NOW() - (FLOOR(RANDOM() * 365 * 20)::int || ' days')::interval; -- 最近一年内随机日期
            random_item_name := item_names[FLOOR(RANDOM() * array_length(item_names, 1)) + 1]; -- 从商品名数组中随机选择
            random_item_amount := FLOOR(RANDOM() * 100 + 1); -- 随机商品数量 (1~10)
            random_price_per_unit := ROUND((RANDOM() * 1000 + 1)::numeric, 2); -- 随机单价 (1.00 ~ 10000.00)
            random_total_price := ROUND((random_item_amount * random_price_per_unit)::numeric, 2); -- 计算总价
            random_location := 'Location_' || FLOOR(RANDOM() * 10); -- 随机地点
			random_brand := brands[FLOOR(RANDOM() * array_length(brands, 1)) + 1]; -- 从品牌名数组中随机选择
            random_category := categories[FLOOR(RANDOM() * array_length(categories, 1) + 1)]; -- 从枚举中随机选择

            -- 插入交易记录
            INSERT INTO transactions (
                id, 
                consumer_id, 
                item_name, 
                item_amount, 
                price_per_unit, 
                total_price, 
                location, 
                brand, 
                category, 
                img, 
                transaction_date
            ) VALUES (
                gen_random_uuid(), -- 随机生成 UUID
                user_id,
                random_item_name,
                random_item_amount,
                random_price_per_unit,
                random_total_price,
                random_location,
                random_brand,
                random_category,
                '00000000-0000-0000-0000-000000000000',
				random_transaction_date
            );
        END LOOP;
    END LOOP;
END $$;