
CREATE TABLE Customers (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Email TEXT NOT NULL,
    FirstName TEXT,
    LastName TEXT,
    Adult BOOLEAN NOT NULL DEFAULT 0,
    Pass TEXT,
	Discount INTEGER NOT NULL DEFAULT 0,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000)
);
CREATE TABLE Shippings (
    Id INTEGER PRIMARY KEY AUTOINCREMENT, 
    CustomerId INTEGER NOT NULL,          
    AddressLine1 TEXT NOT NULL,           
    AddressLine2 TEXT,                    
    Zip TEXT NOT NULL,                    
    State TEXT,                           
    City TEXT NOT NULL,                   
    Country TEXT NOT NULL, 
	IsDefault BOOLEAN NOT NULL DEFAULT 0,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    UNIQUE (CustomerId, AddressLine1, AddressLine2, Zip, State, City, Country)
);
CREATE TABLE OrderStatuses (
    Id INTEGER PRIMARY KEY AUTOINCREMENT, 
    Status TEXT NOT NULL,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000)
);
CREATE TABLE Orders (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,   
    ShippingId INTEGER NOT NULL,            
    OrderStatusId INTEGER NOT NULL,         
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (ShippingId) REFERENCES Shippings(Id), 
    FOREIGN KEY (OrderStatusId) REFERENCES OrderStatuses(Id) 
);
CREATE TABLE Products (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
	NestId TEXT NOT NULL UNIQUE,
    Name TEXT NOT NULL,
    Description TEXT,
	RateActual INTEGER,
	Slug TEXT NOT NULL UNIQUE,
	Popularity INTEGER,
	PriceActual INTEGER NOT NULL DEFAULT 0,
	PriceOld INTEGER,
	Vat INTEGER NOT NULL DEFAULT 20,
	Published INTEGER NOT NULL DEFAULT 1,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000)
);


CREATE TABLE Params (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000)
);


CREATE TABLE ParamsValues (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    ParamId INTEGER NOT NULL,
    ParamValue TEXT NOT NULL,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (ParamId) REFERENCES Params (Id) ON DELETE CASCADE
);


CREATE TABLE ProductValues (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    ProductId INTEGER NOT NULL,
    ParamId INTEGER NOT NULL,
    ParamValueId INTEGER NOT NULL,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (ProductId) REFERENCES Products (Id) ON DELETE CASCADE,
    FOREIGN KEY (ParamId) REFERENCES Params (Id) ON DELETE CASCADE,
    FOREIGN KEY (ParamValueId) REFERENCES ParamsValues (Id) ON DELETE CASCADE
);

CREATE TABLE Carts (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,   
    OrderId INTEGER NOT NULL,               
    ProductId INTEGER NOT NULL,
    Qty INTEGER NOT NULL DEFAULT 1,
	PriceActual INTEGER NOT NULL DEFAULT 0,
	PriceOld INTEGER NOT NULL DEFAULT 0,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (OrderId) REFERENCES Orders(Id),       
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    UNIQUE (OrderId, ProductId)
);

CREATE TABLE Sessions (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,   
	SessionToken TEXT NOT NULL UNIQUE,
	SessionExp INTEGER NOT NULL,
    CustomerId INTEGER,
    OrderId INTEGER,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id), 
    FOREIGN KEY (OrderId) REFERENCES Orders(Id)
);
CREATE TABLE PaymentMethodTypes (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000)
);

CREATE TABLE PaymentProviders (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000)
);

CREATE TABLE PaymentMethods (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerId INTEGER NOT NULL,
    MethodTypeId INTEGER NOT NULL,
    ProviderId INTEGER,
	IdMethodByProvider TEXT,
	IdCustomerByProvider TEXT,
    AccountIdentifier TEXT NOT NULL,
    ExpiryDate TEXT,
    IsDefault BOOLEAN NOT NULL DEFAULT 0,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id) ON DELETE CASCADE,
    FOREIGN KEY (MethodTypeId) REFERENCES PaymentMethodTypes(Id),
    FOREIGN KEY (ProviderId) REFERENCES PaymentProviders(Id)
);
CREATE TABLE AllowedPaymentMethods (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    PaymentMethodTypeId INTEGER NOT NULL,
    PaymentProviderId INTEGER NOT NULL,
    CreatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    UpdatedAt INTEGER DEFAULT (strftime('%s', 'now') * 1000),
    FOREIGN KEY (PaymentMethodTypeId) REFERENCES PaymentMethodTypes (Id) ON DELETE CASCADE,
    FOREIGN KEY (PaymentProviderId) REFERENCES PaymentProviders (Id) ON DELETE CASCADE,
    UNIQUE (PaymentMethodTypeId, PaymentProviderId)
);


CREATE TRIGGER Update_Customers_UpdatedAt
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    UPDATE Customers
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_Shippings_UpdatedAt
AFTER UPDATE ON Shippings
FOR EACH ROW
BEGIN
    UPDATE Shippings
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_OrderStatuses_UpdatedAt
AFTER UPDATE ON OrderStatuses
FOR EACH ROW
BEGIN
    UPDATE OrderStatuses
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_Orders_UpdatedAt
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_Products_UpdatedAt
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    UPDATE Products
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_Params_UpdatedAt
AFTER UPDATE ON Params
FOR EACH ROW
BEGIN
    UPDATE Params
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_ParamsValues_UpdatedAt
AFTER UPDATE ON ParamsValues
FOR EACH ROW
BEGIN
    UPDATE ParamsValues
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_ProductValues_UpdatedAt
AFTER UPDATE ON ProductValues
FOR EACH ROW
BEGIN
    UPDATE ProductValues
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_Carts_UpdatedAt
AFTER UPDATE ON Carts
FOR EACH ROW
BEGIN
    UPDATE Carts
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_Sessions_UpdatedAt
AFTER UPDATE ON Sessions
FOR EACH ROW
BEGIN
    UPDATE Sessions
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER EnsureSingleDefault
BEFORE INSERT ON Shippings
FOR EACH ROW
WHEN NEW.IsDefault = 1
BEGIN
    UPDATE Shippings
    SET IsDefault = 0
    WHERE CustomerId = NEW.CustomerId;
END;
CREATE TRIGGER EnsureSingleDefaultOnUpdate
BEFORE UPDATE OF IsDefault ON Shippings
FOR EACH ROW
WHEN NEW.IsDefault = 1
BEGIN
    UPDATE Shippings
    SET IsDefault = 0
    WHERE CustomerId = NEW.CustomerId AND Id != NEW.Id;
END;
CREATE TRIGGER Update_PaymentMethods_UpdatedAt
AFTER UPDATE ON PaymentMethods
FOR EACH ROW
BEGIN
    UPDATE PaymentMethods
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER Update_AllowedPaymentMethods_UpdatedAt
AFTER UPDATE ON AllowedPaymentMethods
FOR EACH ROW
BEGIN
    UPDATE AllowedPaymentMethods
    SET UpdatedAt = (strftime('%s', 'now') * 1000)
    WHERE Id = OLD.Id;
END;
CREATE TRIGGER EnsureSingleDefaultPaymentMethod
BEFORE INSERT ON PaymentMethods
FOR EACH ROW
WHEN NEW.IsDefault = 1
BEGIN
    UPDATE PaymentMethods
    SET IsDefault = 0
    WHERE CustomerId = NEW.CustomerId;
END;

CREATE TRIGGER EnsureSingleDefaultPaymentMethodOnUpdate
BEFORE UPDATE OF IsDefault ON PaymentMethods
FOR EACH ROW
WHEN NEW.IsDefault = 1
BEGIN
    UPDATE PaymentMethods
    SET IsDefault = 0
    WHERE CustomerId = NEW.CustomerId AND Id != NEW.Id;
END;


INSERT INTO OrderStatuses (Status) 
VALUES ('Pending'), ('Completed');

INSERT INTO Products (NestId, Name, Description, RateActual, Slug, Popularity, PriceActual, PriceOld, Vat, Published) 
VALUES ('I000', 'Asado', 'Description for product one', 5, 'asado', 100, 2046, 2046, 20, 1),
       ('I00V', 'Generation 2 Chardonay', 'Description for product two', 4, '1848-generation-2-chardonay', 75, 2235, 2235, 20, 1);

INSERT INTO Params (Name) 
VALUES ('Brand'), ('Taste');

INSERT INTO ParamsValues (ParamId, ParamValue) 
VALUES (1, 'Euro Glatt'), (1, '1848'), 
       (2, 'Dry'), (2, 'Sweet');

INSERT INTO ProductValues (ProductId, ParamId, ParamValueId) 
VALUES (1, 1, 1), (1, 2, 3), (2, 1, 2), (2, 2, 4);

INSERT INTO PaymentMethodTypes (Name)
VALUES ('Credit Card'), ('Debit Card');

INSERT INTO PaymentProviders (Name)
VALUES ('Visa'), ('MasterCard'), ('American Express');

INSERT INTO AllowedPaymentMethods (PaymentMethodTypeId, PaymentProviderId)
VALUES (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3);