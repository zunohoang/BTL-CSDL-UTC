CREATE TABLE "Student"(
    "StudentID" INT NOT NULL,
    "Name" VARCHAR(255) NOT NULL,
    "BirthDate" DATE NOT NULL,
    "Sex" VARCHAR(255) NOT NULL,
    "PhoneNumber" CHAR(255) NOT NULL,
    "RoomID" INT NOT NULL,
    CONSTRAINT "student_studentid_primary" PRIMARY KEY("StudentID")
);

CREATE TABLE "Contract"(
    "ContractID" INT NOT NULL,
    "StartDate" DATE NOT NULL,
    "EndDate" DATE NOT NULL,
    "TotalAmount" INT NOT NULL,
    "EmployeeID" INT NOT NULL,
    "StudentID" INT NOT NULL,
    "RoomID" INT NOT NULL,
    CONSTRAINT "contract_contractid_primary" PRIMARY KEY("ContractID")
);

CREATE TABLE "Room"(
    "RoomID" INT NOT NULL,
    "Price" DECIMAL(10,2) NOT NULL,
    "Capacity" INT NOT NULL,
    "RoomName" VARCHAR(255) NOT NULL,
    "ManagerID" INT NOT NULL,
    "RoomTypeID" INT NOT NULL,
    "BuildingID" INT NOT NULL,
    CONSTRAINT "room_roomid_primary" PRIMARY KEY("RoomID")
);

CREATE TABLE "Facility"(
    "FacilityID" INT NOT NULL,
    "FacilityName" VARCHAR(255) NOT NULL,
    "Quantity" INT NOT NULL,
    "Brand" VARCHAR(255) NOT NULL,
    "Price" DECIMAL(10,2) NOT NULL,
    "AvailableQuantity" INT NOT NULL,
    CONSTRAINT "facility_facilityid_primary" PRIMARY KEY("FacilityID")
);


CREATE TABLE "Room_Facility"(
    "FacilityID" INT NOT NULL,
    "RoomID" INT NOT NULL,
    "Price" DECIMAL(10,2) NOT NULL,
    "Quantity" INT NOT NULL,
    "AvailableQuantity" INT NOT NULL,
    "PurchaseDate" DATE NOT NULL,
    CONSTRAINT "room_facility_primary" PRIMARY KEY("FacilityID", "RoomID")
);

CREATE TABLE "RoomType"(
    "RoomTypeID" INT NOT NULL,
    "Quantity" INT NOT NULL,
    CONSTRAINT "roomtype_roomtypeid_primary" PRIMARY KEY("RoomTypeID")
);

CREATE TABLE "Building"(
    "BuildingID" INT NOT NULL,
    "BuildingName" VARCHAR(255) NOT NULL,
    "RoomQuantity" INT NOT NULL,
    CONSTRAINT "building_buildingid_primary" PRIMARY KEY("BuildingID")
);

CREATE TABLE "Employee"(
    "EmployeeID" INT NOT NULL,
    "FullName" VARCHAR(255) NOT NULL,
    "PhoneNumber" CHAR(255) NOT NULL,
    "PositionID" INT NOT NULL,
    CONSTRAINT "employee_employeeid_primary" PRIMARY KEY("EmployeeID")
);

CREATE TABLE "Position"(
    "PositionID" INT NOT NULL,
    "PositionName" VARCHAR(255) NOT NULL,
    CONSTRAINT "position_positionid_primary" PRIMARY KEY("PositionID")
);

CREATE TABLE "Invoice"(
    "InvoiceID" INT NOT NULL,
    "CreatedDate" DATE NOT NULL,
    "ElectricRate" DECIMAL(10,2) NOT NULL,
    "WaterRate" DECIMAL(10,2) NOT NULL,
    "PaymentStatus" VARCHAR(20) NOT NULL CHECK ("PaymentStatus" IN ('Pending', 'Paid', 'Overdue')), 
    "StartElectricReading" DECIMAL(10,2) NOT NULL, 
    "StartWaterReading" DECIMAL(10,2) NOT NULL,
    "EndElectricReading" DECIMAL(10,2) NOT NULL,
    "EndWaterReading" DECIMAL(10,2) NOT NULL,
    "EmployeeID" INT NOT NULL,
    "RoomID" INT NOT NULL,
    CONSTRAINT "invoice_invoiceid_primary" PRIMARY KEY("InvoiceID")
);

ALTER TABLE "Contract" 
    ADD CONSTRAINT "contract_employeeid_foreign" FOREIGN KEY("EmployeeID") REFERENCES "Employee"("EmployeeID");

ALTER TABLE "Employee" 
    ADD CONSTRAINT "employee_positionid_foreign" FOREIGN KEY("PositionID") REFERENCES "Position"("PositionID");

ALTER TABLE "Contract" 
    ADD CONSTRAINT "contract_studentid_foreign" FOREIGN KEY("StudentID") REFERENCES "Student"("StudentID");

ALTER TABLE "Student" 
    ADD CONSTRAINT "student_roomid_foreign" FOREIGN KEY("RoomID") REFERENCES "Room"("RoomID");

ALTER TABLE "Room" 
    ADD CONSTRAINT "room_managerid_foreign" FOREIGN KEY("ManagerID") REFERENCES "Student"("StudentID");

ALTER TABLE "Invoice" 
    ADD CONSTRAINT "invoice_roomid_foreign" FOREIGN KEY("RoomID") REFERENCES "Room"("RoomID");

ALTER TABLE "Invoice" 
    ADD CONSTRAINT "invoice_employeeid_foreign" FOREIGN KEY("EmployeeID") REFERENCES "Employee"("EmployeeID");

ALTER TABLE "Room" 
    ADD CONSTRAINT "room_roomtypeid_foreign" FOREIGN KEY("RoomTypeID") REFERENCES "RoomType"("RoomTypeID");

ALTER TABLE "Room_Facility" 
    ADD CONSTRAINT "room_facility_facilityid_foreign" FOREIGN KEY("FacilityID") REFERENCES "Facility"("FacilityID");

ALTER TABLE "Room_Facility" 
    ADD CONSTRAINT "room_facility_roomid_foreign" FOREIGN KEY("RoomID") REFERENCES "Room"("RoomID");

ALTER TABLE "Room" 
    ADD CONSTRAINT "room_buildingid_foreign" FOREIGN KEY("BuildingID") REFERENCES "Building"("BuildingID");