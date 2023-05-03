namespace lw9.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Clients",
                c => new
                    {
                        ClientId = c.Int(nullable: false, identity: true),
                        FirstName = c.String(),
                        SecondName = c.String(),
                        PhoneNumber = c.String(),
                        Email = c.String(),
                    })
                .PrimaryKey(t => t.ClientId);
            
            CreateTable(
                "dbo.Employees",
                c => new
                    {
                        EmployeeID = c.Int(nullable: false, identity: true),
                        FirstName = c.String(),
                        SecondName = c.String(),
                        JobPosition = c.String(),
                        Salary = c.Double(nullable: false),
                    })
                .PrimaryKey(t => t.EmployeeID);
            
            CreateTable(
                "dbo.Inventories",
                c => new
                    {
                        InventoryId = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                        QuantityAvaliable = c.Int(nullable: false),
                        RentalPrice = c.Double(nullable: false),
                        Rental_RentalId = c.Int(),
                    })
                .PrimaryKey(t => t.InventoryId)
                .ForeignKey("dbo.Rentals", t => t.Rental_RentalId)
                .Index(t => t.Rental_RentalId);
            
            CreateTable(
                "dbo.Rentals",
                c => new
                    {
                        RentalId = c.Int(nullable: false, identity: true),
                        RentalDate = c.DateTime(nullable: false),
                        RentalDaysTime = c.DateTime(nullable: false),
                        IsReturned = c.Boolean(nullable: false),
                        Client_ClientId = c.Int(),
                    })
                .PrimaryKey(t => t.RentalId)
                .ForeignKey("dbo.Clients", t => t.Client_ClientId)
                .Index(t => t.Client_ClientId);
            
            CreateTable(
                "dbo.Sales",
                c => new
                    {
                        SaleId = c.Int(nullable: false, identity: true),
                        SaleDate = c.DateTime(nullable: false),
                        SaleAmount = c.Double(nullable: false),
                        IsPaid = c.Boolean(nullable: false),
                        Employee_EmployeeID = c.Int(),
                        Rental_RentalId = c.Int(),
                    })
                .PrimaryKey(t => t.SaleId)
                .ForeignKey("dbo.Employees", t => t.Employee_EmployeeID)
                .ForeignKey("dbo.Rentals", t => t.Rental_RentalId)
                .Index(t => t.Employee_EmployeeID)
                .Index(t => t.Rental_RentalId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Sales", "Rental_RentalId", "dbo.Rentals");
            DropForeignKey("dbo.Sales", "Employee_EmployeeID", "dbo.Employees");
            DropForeignKey("dbo.Inventories", "Rental_RentalId", "dbo.Rentals");
            DropForeignKey("dbo.Rentals", "Client_ClientId", "dbo.Clients");
            DropIndex("dbo.Sales", new[] { "Rental_RentalId" });
            DropIndex("dbo.Sales", new[] { "Employee_EmployeeID" });
            DropIndex("dbo.Rentals", new[] { "Client_ClientId" });
            DropIndex("dbo.Inventories", new[] { "Rental_RentalId" });
            DropTable("dbo.Sales");
            DropTable("dbo.Rentals");
            DropTable("dbo.Inventories");
            DropTable("dbo.Employees");
            DropTable("dbo.Clients");
        }
    }
}
