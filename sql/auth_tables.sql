-- 用户表，存储基础的用户信息
-- User table, stores basic user information
CREATE TABLE users (
    id SERIAL PRIMARY KEY,                       -- 用户唯一标识符 / User unique identifier
    email VARCHAR(255) NOT NULL UNIQUE,          -- 用户邮箱，必须唯一 / User email, must be unique
    username VARCHAR(255),                       -- 用户名，非必需 / Username, optional
    password_hash VARCHAR(255) NOT NULL,         -- 加密后的密码哈希 / Hashed password
    created_at TIMESTAMPTZ DEFAULT NOW(),        -- 用户创建时间 / User account creation time
    updated_at TIMESTAMPTZ DEFAULT NOW(),        -- 账户最后更新时间 / Last account update time
    is_active BOOLEAN DEFAULT TRUE,              -- 账户是否激活 / Whether the account is active
    is_verified BOOLEAN DEFAULT FALSE            -- 是否通过验证 / Whether the account is verified
);

-- 登录尝试表，存储用户的登录尝试记录
-- Login attempts table, stores user login attempt records
CREATE TABLE login_attempts (
    id SERIAL PRIMARY KEY,                       -- 登录尝试唯一标识符 / Login attempt unique identifier
    user_id INTEGER REFERENCES users(id),        -- 关联到用户表的外键 / Foreign key to users table
    attempt_time TIMESTAMPTZ DEFAULT NOW(),      -- 登录尝试时间 / Login attempt time
    ip_address VARCHAR(255),                     -- 登录时的 IP 地址 / IP address during login
    is_successful BOOLEAN                        -- 登录是否成功 / Whether the login was successful
);

-- 角色表，用于权限管理
-- Roles table, used for permission management
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,                       -- 角色唯一标识符 / Role unique identifier
    role_name VARCHAR(255) NOT NULL UNIQUE       -- 角色名称 / Role name (e.g. 'admin', 'user')
);

-- 用户-角色关联表，用户与角色的多对多关系
-- User-role relationship table, many-to-many relationship between users and roles
CREATE TABLE user_roles (
    id SERIAL PRIMARY KEY,                       -- 唯一标识符 / Unique identifier
    user_id INTEGER REFERENCES users(id),        -- 关联到用户表的外键 / Foreign key to users table
    role_id INTEGER REFERENCES roles(id)         -- 关联到角色表的外键 / Foreign key to roles table
);

-- 密码重置表，处理忘记密码的情况
-- Password reset table, handles forgotten password requests
CREATE TABLE password_resets (
    id SERIAL PRIMARY KEY,                       -- 密码重置请求唯一标识符 / Password reset request unique identifier
    user_id INTEGER REFERENCES users(id),        -- 关联到用户表的外键 / Foreign key to users table
    reset_token VARCHAR(255) NOT NULL,           -- 重置令牌 / Reset token
    expires_at TIMESTAMPTZ NOT NULL,             -- 重置令牌的过期时间 / Reset token expiration time
    created_at TIMESTAMPTZ DEFAULT NOW()         -- 请求创建时间 / Request creation time
);

-- 会话表，存储用户登录的会话信息
-- Sessions table, stores user login session information
CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,                       -- 会话唯一标识符 / Session unique identifier
    user_id INTEGER REFERENCES users(id),        -- 关联到用户表的外键 / Foreign key to users table
    session_token VARCHAR(255) NOT NULL,         -- 会话令牌 / Session token
    created_at TIMESTAMPTZ DEFAULT NOW(),        -- 会话创建时间 / Session creation time
    expires_at TIMESTAMPTZ NOT NULL              -- 会话过期时间 / Session expiration time
);
