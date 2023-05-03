namespace lw9.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MyMigrationName : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Rentals", "RentalDate", c => c.String());
            AlterColumn("dbo.Sales", "SaleDate", c => c.String());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Sales", "SaleDate", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Rentals", "RentalDaysTime", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Rentals", "RentalDate", c => c.DateTime(nullable: false));
        }
    }
}
