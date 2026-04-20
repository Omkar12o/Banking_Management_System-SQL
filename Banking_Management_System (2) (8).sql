-- ============================================================
--   BANKING MANAGEMENT SYSTEM - SQL PROJECT
--   Role     : Software Tester Portfolio Project
--   Database : SQLite (compatible with MySQL with minor changes)
--   Author   : [Your Name]
--   Date     : 2026
-- ============================================================


-- ============================================================
-- SECTION 1: RESET / DROP TABLES
-- ============================================================

DROP TABLE IF EXISTS Audit_Log;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Branches;


-- ============================================================
-- SECTION 2: CREATE TABLES
-- ============================================================

CREATE TABLE Branches (
    branch_id    INTEGER PRIMARY KEY,
    branch_name  TEXT    NOT NULL,
    city         TEXT    NOT NULL,
    phone        TEXT,
    established  TEXT    -- Date as text YYYY-MM-DD
);

CREATE TABLE Customers (
    customer_id  INTEGER PRIMARY KEY,
    name         TEXT    NOT NULL,
    city         TEXT    NOT NULL,
    email        TEXT    UNIQUE,
    phone        TEXT,
    dob          TEXT,   -- Date of Birth YYYY-MM-DD
    kyc_status   TEXT    CHECK(kyc_status IN ('Verified','Pending','Rejected'))
);

CREATE TABLE Accounts (
    account_id   INTEGER PRIMARY KEY,
    customer_id  INTEGER NOT NULL,
    branch_id    INTEGER NOT NULL,
    account_type TEXT    CHECK(account_type IN ('Savings','Current','Fixed Deposit')),
    balance      REAL    CHECK(balance >= 0)  DEFAULT 0,
    status       TEXT    CHECK(status IN ('Active','Inactive','Frozen')) DEFAULT 'Active',
    opened_on    TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id)   REFERENCES Branches(branch_id)
);

CREATE TABLE Transactions (
    txn_id       INTEGER PRIMARY KEY,
    account_id   INTEGER NOT NULL,
    amount       REAL    NOT NULL CHECK(amount > 0),
    type         TEXT    CHECK(type IN ('Deposit','Withdrawal','Transfer','Interest')),
    description  TEXT,
    txn_date     TEXT,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Loans (
    loan_id      INTEGER PRIMARY KEY,
    customer_id  INTEGER NOT NULL,
    branch_id    INTEGER NOT NULL,
    loan_type    TEXT    CHECK(loan_type IN ('Home','Personal','Education','Vehicle')),
    loan_amount  REAL    NOT NULL CHECK(loan_amount > 0),
    interest_rate REAL   DEFAULT 8.5,
    status       TEXT    CHECK(status IN ('Approved','Pending','Rejected','Closed'))
                         DEFAULT 'Pending',
    applied_on   TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id)   REFERENCES Branches(branch_id)
);

CREATE TABLE Employees (
    employee_id  INTEGER PRIMARY KEY,
    name         TEXT    NOT NULL,
    branch_id    INTEGER NOT NULL,
    role         TEXT    CHECK(role IN ('Manager','Clerk','Loan Officer','Cashier')),
    salary       REAL    CHECK(salary > 0),
    join_date    TEXT,
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

CREATE TABLE Audit_Log (
    log_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    event_type   TEXT,
    message      TEXT,
    log_time     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- SECTION 3: INSERT SAMPLE DATA
-- ============================================================

-- Branches
INSERT INTO Branches VALUES
(1, 'Mumbai Main',    'Mumbai', '022-11112222', '2000-01-15'),
(2, 'Pune Branch',    'Pune',   '020-33334444', '2005-06-10'),
(3, 'Nagpur Branch',  'Nagpur', '0712-5556666', '2010-03-22'),
(4, 'Delhi Branch',   'Delhi',  '011-77778888', '2008-11-05');

-- Customers
INSERT INTO Customers VALUES
(1,  'Omkar Patil',   'Mumbai', 'omkar@gmail.com',  '9876543210', '1990-04-15', 'Verified'),
(2,  'Rahul Sharma',  'Pune',   'rahul@gmail.com',  '9823456789', '1985-08-22', 'Verified'),
(3,  'Amit Desai',    'Nagpur', 'amit@gmail.com',   '9711234567', '1992-11-30', 'Pending'),
(4,  'Priya Mehta',   'Mumbai', 'priya@gmail.com',  '9988776655', '1995-02-10', 'Verified'),
(5,  'Neha Joshi',    'Pune',   'neha@gmail.com',   '9012345678', '1998-07-18', 'Verified'),
(6,  'Kiran Rao',     'Delhi',  'kiran@gmail.com',  '9876001122', '1988-12-05', 'Rejected'),
(7,  'Sunita Nair',   'Mumbai', 'sunita@gmail.com', '9911223344', '1993-03-25', 'Verified'),
(8,  'Vijay Kumar',   'Nagpur', 'vijay@gmail.com',  '9800112233', '1980-09-14', 'Verified'),
(9,  'Pooja Singh',   'Delhi',  'pooja@gmail.com',  '9700223344', '1996-06-08', 'Pending'),
(10, 'Ravi Tiwari',   'Pune',   'ravi@gmail.com',   '9600334455', '1991-01-20', 'Verified'),
(11, 'Deepa Verma',   'Mumbai', NULL,               '9500445566', '1987-05-17', 'Pending'),  -- NULL email
(12, 'Manoj Gupta',   'Delhi',  'manoj@gmail.com',  '9400556677', '1983-10-29', 'Verified');

-- Accounts
INSERT INTO Accounts VALUES
(101, 1,  1, 'Savings',        50000,  'Active',   '2020-01-10'),
(102, 2,  2, 'Savings',        30000,  'Active',   '2019-06-15'),
(103, 3,  3, 'Current',        75000,  'Active',   '2021-03-20'),
(104, 4,  1, 'Savings',        10000,  'Active',   '2022-07-05'),
(105, 5,  2, 'Fixed Deposit',  100000, 'Active',   '2020-11-11'),
(106, 6,  4, 'Savings',        5000,   'Frozen',   '2018-04-30'),  -- Frozen account
(107, 7,  1, 'Current',        200000, 'Active',   '2017-09-22'),
(108, 8,  3, 'Savings',        15000,  'Active',   '2023-01-18'),
(109, 9,  4, 'Savings',        2000,   'Inactive', '2021-08-14'),  -- Inactive account
(110, 10, 2, 'Savings',        45000,  'Active',   '2019-12-01'),
(111, 11, 1, 'Savings',        0,      'Active',   '2024-02-28'),  -- Zero balance
(112, 12, 4, 'Current',        500000, 'Active',   '2015-06-10');

-- Transactions
INSERT INTO Transactions VALUES
(1,  101, 10000,  'Deposit',    'Cash deposit',         '2026-01-05'),
(2,  101, 5000,   'Withdrawal', 'ATM withdrawal',        '2026-01-10'),
(3,  102, 8000,   'Deposit',    'Online transfer in',    '2026-01-12'),
(4,  102, 3000,   'Withdrawal', 'Bill payment',          '2026-01-15'),
(5,  103, 20000,  'Deposit',    'Business income',       '2026-01-20'),
(6,  104, 2000,   'Deposit',    'Salary credit',         '2026-02-01'),
(7,  104, 1500,   'Withdrawal', 'Online shopping',       '2026-02-05'),
(8,  105, 5000,   'Interest',   'FD interest credited',  '2026-02-10'),
(9,  107, 50000,  'Deposit',    'Business deposit',      '2026-02-15'),
(10, 107, 15000,  'Withdrawal', 'Supplier payment',      '2026-02-20'),
(11, 108, 3000,   'Deposit',    'Cash deposit',          '2026-03-01'),
(12, 110, 12000,  'Deposit',    'Salary credit',         '2026-03-05'),
(13, 110, 4000,   'Withdrawal', 'Grocery payment',       '2026-03-10'),
(14, 112, 100000, 'Deposit',    'Business revenue',      '2026-03-15'),
(15, 112, 25000,  'Withdrawal', 'Vendor payment',        '2026-03-20'),
(16, 101, 2000,   'Transfer',   'Transfer to acc 102',   '2026-04-01'),
(17, 102, 2000,   'Transfer',   'Received from acc 101', '2026-04-01'),
(18, 103, 5000,   'Withdrawal', 'Rent payment',          '2026-04-05'),
(19, 108, 1000,   'Deposit',    'Cash deposit',          '2026-04-10'),
(20, 111, 500,    'Deposit',    'First deposit',         '2026-04-13');

-- Loans
INSERT INTO Loans VALUES
(1, 1,  1, 'Home',       2000000, 8.5,  'Approved', '2024-01-15'),
(2, 2,  2, 'Personal',   100000,  12.0, 'Pending',  '2026-03-20'),
(3, 3,  3, 'Education',  500000,  9.0,  'Approved', '2023-08-10'),
(4, 4,  1, 'Vehicle',    350000,  10.5, 'Rejected', '2026-02-28'),
(5, 5,  2, 'Home',       5000000, 8.5,  'Approved', '2022-06-15'),
(6, 7,  1, 'Personal',   200000,  12.0, 'Closed',   '2021-01-10'),
(7, 8,  3, 'Education',  300000,  9.0,  'Pending',  '2026-04-01'),
(8, 10, 2, 'Vehicle',    450000,  10.5, 'Approved', '2025-09-18'),
(9, 12, 4, 'Home',       8000000, 8.5,  'Approved', '2023-11-22'),
(10,6,  4, 'Personal',   50000,   12.0, 'Rejected', '2025-12-01'); -- Rejected (Frozen account)

-- Employees
INSERT INTO Employees VALUES
(1, 'Sanjay Patil',   1, 'Manager',      80000, '2010-05-01'),
(2, 'Rekha Sharma',   1, 'Cashier',      35000, '2015-08-15'),
(3, 'Deepak Joshi',   2, 'Manager',      75000, '2012-03-20'),
(4, 'Anita Rao',      2, 'Clerk',        30000, '2018-07-10'),
(5, 'Suresh Kumar',   3, 'Loan Officer', 50000, '2016-11-25'),
(6, 'Kavita Mehta',   3, 'Cashier',      32000, '2020-01-05'),
(7, 'Nilesh Desai',   4, 'Manager',      82000, '2009-09-12'),
(8, 'Priti Nair',     4, 'Clerk',        28000, '2022-04-18'),
(9, 'Arun Tiwari',    1, 'Loan Officer', 55000, '2014-06-30'),
(10,'Meena Gupta',    2, 'Cashier',      33000, '2019-02-14');


-- ============================================================
-- SECTION 4: TRIGGERS
-- ============================================================

-- Trigger 1: Log every new transaction
CREATE TRIGGER trg_after_transaction
AFTER INSERT ON Transactions
BEGIN
    INSERT INTO Audit_Log(event_type, message)
    VALUES (
        'TRANSACTION',
        'New ' || NEW.type || ' of ' || NEW.amount ||
        ' on account ' || NEW.account_id || ' on ' || NEW.txn_date
    );
END;

-- Trigger 2: Log account status changes (Frozen / Inactive)
CREATE TRIGGER trg_account_status_change
AFTER UPDATE OF status ON Accounts
WHEN OLD.status != NEW.status
BEGIN
    INSERT INTO Audit_Log(event_type, message)
    VALUES (
        'STATUS CHANGE',
        'Account ' || NEW.account_id || ' status changed from ' ||
        OLD.status || ' to ' || NEW.status
    );
END;

-- Trigger 3: Log loan status changes
CREATE TRIGGER trg_loan_status_change
AFTER UPDATE OF status ON Loans
WHEN OLD.status != NEW.status
BEGIN
    INSERT INTO Audit_Log(event_type, message)
    VALUES (
        'LOAN UPDATE',
        'Loan ' || NEW.loan_id || ' for customer ' || NEW.customer_id ||
        ' changed from ' || OLD.status || ' to ' || NEW.status
    );
END;


-- ============================================================
-- SECTION 5: VIEWS
-- ============================================================

-- View 1: Full customer account summary
CREATE VIEW vw_customer_account_summary AS
SELECT
    c.customer_id,
    c.name             AS customer_name,
    c.city,
    c.kyc_status,
    a.account_id,
    a.account_type,
    a.balance,
    a.status           AS account_status,
    b.branch_name
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
JOIN Branches b ON a.branch_id   = b.branch_id;

-- View 2: Branch-wise total balance
CREATE VIEW vw_branch_balance AS
SELECT
    b.branch_name,
    b.city,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance)      AS total_balance
FROM Branches b
LEFT JOIN Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_id;

-- View 3: Active loans with customer info
CREATE VIEW vw_active_loans AS
SELECT
    l.loan_id,
    c.name         AS customer_name,
    l.loan_type,
    l.loan_amount,
    l.interest_rate,
    l.status,
    b.branch_name
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
JOIN Branches  b ON l.branch_id   = b.branch_id
WHERE l.status IN ('Approved','Pending');

-- View 4: Transaction history with account holder name
CREATE VIEW vw_transaction_history AS
SELECT
    t.txn_id,
    c.name       AS customer_name,
    a.account_id,
    t.type,
    t.amount,
    t.description,
    t.txn_date
FROM Transactions t
JOIN Accounts  a ON t.account_id  = a.account_id
JOIN Customers c ON a.customer_id = c.customer_id;


-- ============================================================
-- SECTION 6: STORED PROCEDURES (as named SQL blocks)
--            (In SQLite these are plain queries; in MySQL
--             wrap each block inside CREATE PROCEDURE...END)
-- ============================================================

-- PROCEDURE 1: Fund Transfer between two accounts
-- Usage: Replace :from_acc, :to_acc, :transfer_amount with real values

-- Step 1 – Deduct from sender (only if balance is sufficient)
UPDATE Accounts
SET balance = balance - 5000           -- replace 5000 with transfer amount
WHERE account_id = 101                 -- replace with sender account
  AND balance >= 5000
  AND status = 'Active';

-- Step 2 – Credit to receiver
UPDATE Accounts
SET balance = balance + 5000           -- same transfer amount
WHERE account_id = 102                 -- replace with receiver account
  AND status = 'Active';

-- Step 3 – Log the transfer transactions
INSERT INTO Transactions(txn_id, account_id, amount, type, description, txn_date)
VALUES (100, 101, 5000, 'Transfer', 'Transfer to account 102', DATE('now'));

INSERT INTO Transactions(txn_id, account_id, amount, type, description, txn_date)
VALUES (101, 102, 5000, 'Transfer', 'Received from account 101', DATE('now'));


-- PROCEDURE 2: Calculate Simple Interest on a Loan
-- Formula: SI = (P * R * T) / 100
-- Example: Loan ID 1 → 2000000 at 8.5% for 20 years
SELECT
    loan_id,
    customer_id,
    loan_amount                                      AS principal,
    interest_rate,
    20                                               AS years,
    (loan_amount * interest_rate * 20) / 100         AS simple_interest,
    loan_amount + (loan_amount * interest_rate * 20) / 100 AS total_payable
FROM Loans
WHERE loan_id = 1;

-- PROCEDURE 3: Approve a Pending Loan
UPDATE Loans
SET status = 'Approved'
WHERE loan_id = 2
  AND status  = 'Pending';


-- ============================================================
-- SECTION 7: TEST CASES (40+ Queries)
-- ============================================================
-- Format: TC-ID | Description | Query

-- ── BASIC VALIDATION ────────────────────────────────────────

-- TC-01: View all customers
SELECT * FROM Customers;

-- TC-02: View all accounts
SELECT * FROM Accounts;

-- TC-03: View all transactions
SELECT * FROM Transactions;

-- TC-04: View all loans
SELECT * FROM Loans;

-- TC-05: View all employees
SELECT * FROM Employees;

-- TC-06: View all branches
SELECT * FROM Branches;

-- ── DATA INTEGRITY ───────────────────────────────────────────

-- TC-07: Check for negative balance (should return 0 rows)
SELECT * FROM Accounts WHERE balance < 0;

-- TC-08: Check for duplicate account IDs
SELECT account_id, COUNT(*) AS cnt
FROM Accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

-- TC-09: Check for duplicate customer emails
SELECT email, COUNT(*) AS cnt
FROM Customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

-- TC-10: Check accounts with invalid customer references (orphan records)
SELECT * FROM Accounts
WHERE customer_id NOT IN (SELECT customer_id FROM Customers);

-- TC-11: Check transactions with invalid account references
SELECT * FROM Transactions
WHERE account_id NOT IN (SELECT account_id FROM Accounts);

-- TC-12: Check NULL email customers
SELECT customer_id, name, phone FROM Customers WHERE email IS NULL;

-- TC-13: Check customers with NULL or empty name
SELECT * FROM Customers WHERE name IS NULL OR TRIM(name) = '';

-- TC-14: Verify KYC status values are valid
SELECT * FROM Customers
WHERE kyc_status NOT IN ('Verified','Pending','Rejected');

-- TC-15: Verify account type values are valid
SELECT * FROM Accounts
WHERE account_type NOT IN ('Savings','Current','Fixed Deposit');

-- TC-16: Check accounts with zero balance
SELECT * FROM Accounts WHERE balance = 0;

-- TC-17: Check frozen or inactive accounts
SELECT * FROM Accounts WHERE status IN ('Frozen','Inactive');

-- ── TRANSACTION TESTING ──────────────────────────────────────

-- TC-18: Deposit test — add 3000 to account 104
UPDATE Accounts SET balance = balance + 3000 WHERE account_id = 104;
SELECT balance FROM Accounts WHERE account_id = 104; -- Expected: 13000

-- TC-19: Withdrawal test — deduct 2000 from account 104
UPDATE Accounts SET balance = balance - 2000
WHERE account_id = 104 AND balance >= 2000;
SELECT balance FROM Accounts WHERE account_id = 104; -- Expected: 11000

-- TC-20: Overdraft protection test — attempt to withdraw more than balance
UPDATE Accounts SET balance = balance - 999999
WHERE account_id = 111 AND balance >= 999999;
SELECT balance FROM Accounts WHERE account_id = 111; -- Expected: unchanged (0)

-- TC-21: Transaction on frozen account (should NOT update — app-level check)
SELECT status FROM Accounts WHERE account_id = 106; -- Expected: Frozen

-- TC-22: Total deposits for account 101
SELECT account_id, SUM(amount) AS total_deposits
FROM Transactions
WHERE account_id = 101 AND type = 'Deposit'
GROUP BY account_id;

-- TC-23: Total withdrawals for account 101
SELECT account_id, SUM(amount) AS total_withdrawals
FROM Transactions
WHERE account_id = 101 AND type = 'Withdrawal'
GROUP BY account_id;

-- TC-24: Number of transactions per account
SELECT account_id, COUNT(*) AS txn_count
FROM Transactions
GROUP BY account_id
ORDER BY txn_count DESC;

-- ── LOAN TESTING ─────────────────────────────────────────────

-- TC-25: View all approved loans
SELECT * FROM Loans WHERE status = 'Approved';

-- TC-26: Loans above 10 lakh (high-value loan check)
SELECT * FROM Loans WHERE loan_amount > 1000000;

-- TC-27: Loan interest calculation (Simple Interest)
SELECT loan_id, loan_amount,
       interest_rate,
       (loan_amount * interest_rate * 10) / 100 AS interest_for_10_years
FROM Loans WHERE status = 'Approved';

-- TC-28: Customers with more than one loan
SELECT customer_id, COUNT(*) AS loan_count
FROM Loans
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- TC-29: Rejected loan reasons check (customers with rejected KYC)
SELECT c.name, c.kyc_status, l.loan_type, l.status AS loan_status
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
WHERE l.status = 'Rejected';

-- TC-30: Pending loans older than 30 days (SLA breach simulation)
SELECT * FROM Loans
WHERE status = 'Pending'
  AND applied_on < DATE('now', '-30 days');

-- ── JOIN & RELATIONSHIP TESTING ──────────────────────────────

-- TC-31: Customer name with their account balance (INNER JOIN)
SELECT c.name, a.account_id, a.account_type, a.balance, a.status
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id
ORDER BY a.balance DESC;

-- TC-32: Customers WITHOUT any account (LEFT JOIN orphan check)
SELECT c.customer_id, c.name
FROM Customers c
LEFT JOIN Accounts a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;

-- TC-33: Branch-wise account count and total balance
SELECT b.branch_name, COUNT(a.account_id) AS accounts, SUM(a.balance) AS total_balance
FROM Branches b
LEFT JOIN Accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_id;

-- TC-34: Employees per branch with manager details
SELECT b.branch_name, e.name AS employee, e.role, e.salary
FROM Employees e
JOIN Branches b ON e.branch_id = b.branch_id
ORDER BY b.branch_name, e.role;

-- ── AGGREGATE & SUMMARY ──────────────────────────────────────

-- TC-35: Total money in the bank
SELECT SUM(balance) AS total_bank_balance FROM Accounts WHERE status = 'Active';

-- TC-36: Account with highest balance
SELECT c.name, a.account_id, a.balance
FROM Accounts a
JOIN Customers c ON a.customer_id = c.customer_id
ORDER BY a.balance DESC
LIMIT 1;

-- TC-37: Account with lowest balance
SELECT c.name, a.account_id, a.balance
FROM Accounts a
JOIN Customers c ON a.customer_id = c.customer_id
ORDER BY a.balance ASC
LIMIT 1;

-- TC-38: City-wise customer count
SELECT city, COUNT(*) AS customer_count
FROM Customers
GROUP BY city
ORDER BY customer_count DESC;

-- TC-39: Monthly transaction volume
SELECT
    SUBSTR(txn_date,1,7) AS month,
    COUNT(*)             AS txn_count,
    SUM(amount)          AS total_volume
FROM Transactions
GROUP BY month
ORDER BY month;

-- TC-40: Average salary per role
SELECT role, AVG(salary) AS avg_salary
FROM Employees
GROUP BY role;

-- ── VIEW VALIDATION ──────────────────────────────────────────

-- TC-41: Test customer account summary view
SELECT * FROM vw_customer_account_summary;

-- TC-42: Test branch balance view
SELECT * FROM vw_branch_balance;

-- TC-43: Test active loans view
SELECT * FROM vw_active_loans;

-- TC-44: Test transaction history view
SELECT * FROM vw_transaction_history ORDER BY txn_date DESC;

-- ── AUDIT LOG ────────────────────────────────────────────────

-- TC-45: View all audit log entries
SELECT * FROM Audit_Log ORDER BY log_time DESC;


-- ============================================================
-- SECTION 8: BUG SCENARIOS (10 Bugs with Explanations)
-- ============================================================

-- BUG-01: Missing WHERE clause — updates ALL accounts (critical bug)
-- DESCRIPTION: Developer forgot WHERE clause; ALL balances increase by 5000
-- IMPACT: All account balances corrupted
-- EXPECTED: Only specific account should be updated
-- ❌ BUGGY QUERY:
-- UPDATE Accounts SET balance = balance + 5000;
-- ✅ CORRECT QUERY:
-- UPDATE Accounts SET balance = balance + 5000 WHERE account_id = 101;

-- BUG-02: Wrong JOIN column — cross-matches customer_id with account_id
-- DESCRIPTION: Joins on wrong columns causing false data relationships
-- IMPACT: Returns incorrect customer-account mapping
-- ❌ BUGGY QUERY:
SELECT c.name, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.account_id;  -- WRONG: should be a.customer_id
-- ✅ CORRECT QUERY:
-- JOIN Accounts a ON c.customer_id = a.customer_id;

-- BUG-03: Negative balance violation attempt
-- DESCRIPTION: Trying to set balance to negative directly (constraint should block)
-- IMPACT: CHECK constraint violation if working correctly
-- ❌ BUGGY QUERY:
-- UPDATE Accounts SET balance = -500 WHERE account_id = 104;
-- ✅ CORRECT QUERY (Safe withdrawal):
-- UPDATE Accounts SET balance = balance - 500 WHERE account_id = 104 AND balance >= 500;

-- BUG-04: Duplicate primary key insert
-- DESCRIPTION: Inserting a customer with an already existing ID
-- IMPACT: Causes PRIMARY KEY constraint error
-- ❌ BUGGY QUERY:
-- INSERT INTO Customers VALUES (1, 'Fake User', 'Delhi', 'fake@gmail.com', '0000000000', '2000-01-01', 'Verified');
-- ✅ CORRECT: Use a new unique customer_id

-- BUG-05: Transaction amount = 0 (zero-value transaction)
-- DESCRIPTION: System should not allow a transaction of 0 amount
-- IMPACT: CHECK(amount > 0) constraint should catch this
-- ❌ BUGGY QUERY:
-- INSERT INTO Transactions VALUES (999, 101, 0, 'Deposit', 'Zero amount', '2026-04-20');

-- BUG-06: Transfer without checking sender balance (no atomic update)
-- DESCRIPTION: Deducting from sender but not checking balance first
-- IMPACT: Sender balance can go negative, breaking CHECK constraint
-- ❌ BUGGY QUERY:
-- UPDATE Accounts SET balance = balance - 999999 WHERE account_id = 111;
-- ✅ CORRECT: Always add AND balance >= amount condition

-- BUG-07: Loan approved for unverified KYC customer
-- DESCRIPTION: Loan given to a customer whose KYC is Pending or Rejected
-- IMPACT: Business rule violation
-- DETECT WITH:
SELECT l.loan_id, c.name, c.kyc_status, l.status AS loan_status
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
WHERE l.status = 'Approved'
  AND c.kyc_status != 'Verified';

-- BUG-08: Transaction on a Frozen / Inactive account
-- DESCRIPTION: System should block transactions on non-active accounts
-- DETECT WITH:
SELECT t.txn_id, t.account_id, t.type, t.amount, a.status AS account_status
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
WHERE a.status IN ('Frozen','Inactive');

-- BUG-09: Employee assigned to a non-existent branch
-- DESCRIPTION: Foreign key constraint should prevent this
-- ❌ BUGGY QUERY:
-- INSERT INTO Employees VALUES (99, 'Ghost Employee', 999, 'Clerk', 25000, '2026-01-01');

-- BUG-10: Loan applied for a non-existent customer
-- DESCRIPTION: Foreign key constraint should block this
-- ❌ BUGGY QUERY:
-- INSERT INTO Loans VALUES (99, 999, 1, 'Personal', 10000, 12.0, 'Pending', '2026-04-20');


-- ============================================================
-- SECTION 9: TEST CASE DOCUMENTATION TABLE
-- ============================================================

-- Use this format in Excel or your test management tool:
--
-- +--------+------------------------------------------+----------------------+------------------------+------------------+--------+
-- | TC-ID  | Test Description                         | Input / Condition    | Expected Result        | Actual Result    | Status |
-- +--------+------------------------------------------+----------------------+------------------------+------------------+--------+
-- | TC-07  | Check negative balance                   | balance < 0          | 0 rows returned        | 0 rows returned  | PASS   |
-- | TC-08  | Check duplicate account IDs              | GROUP BY + HAVING    | 0 duplicates           | 0 duplicates     | PASS   |
-- | TC-18  | Deposit 3000 to account 104              | balance was 10000    | balance = 13000        | balance = 13000  | PASS   |
-- | TC-20  | Overdraft protection on account 111      | withdraw 999999      | balance unchanged = 0  | balance = 0      | PASS   |
-- | TC-30  | Pending loans older than 30 days         | applied_on < -30days | Detect SLA breach      | 1 row returned   | PASS   |
-- | BUG-01 | Missing WHERE in UPDATE                  | No condition         | All rows affected      | All rows updated | FAIL   |
-- | BUG-07 | Approved loan for unverified KYC customer| kyc_status = Pending | Should NOT be approved | 1 row found      | FAIL   |
-- | BUG-08 | Transaction on Frozen account            | status = Frozen      | Should be blocked      | Rows found       | FAIL   |
-- +--------+------------------------------------------+----------------------+------------------------+------------------+--------+


-- ============================================================
-- SECTION 10: FINAL SUMMARY REPORT
-- ============================================================

SELECT 'Total Customers'   AS metric, COUNT(*) AS value FROM Customers
UNION ALL
SELECT 'Total Accounts',        COUNT(*) FROM Accounts
UNION ALL
SELECT 'Active Accounts',       COUNT(*) FROM Accounts WHERE status = 'Active'
UNION ALL
SELECT 'Frozen Accounts',       COUNT(*) FROM Accounts WHERE status = 'Frozen'
UNION ALL
SELECT 'Total Transactions',    COUNT(*) FROM Transactions
UNION ALL
SELECT 'Total Loans',           COUNT(*) FROM Loans
UNION ALL
SELECT 'Approved Loans',        COUNT(*) FROM Loans WHERE status = 'Approved'
UNION ALL
SELECT 'Pending Loans',         COUNT(*) FROM Loans WHERE status = 'Pending'
UNION ALL
SELECT 'Total Employees',       COUNT(*) FROM Employees
UNION ALL
SELECT 'Total Branches',        COUNT(*) FROM Branches
UNION ALL
SELECT 'Total Bank Balance',    SUM(balance) FROM Accounts WHERE status = 'Active';

-- ============================================================
-- END OF PROJECT
-- ============================================================
