namespace lw9
{
    public class Inventory
    {
        public int InventoryId { get; set; }
        public string Name { get; set; }
        public int QuantityAvaliable { get; set; }
        public double RentalPrice { get; set; }
        public virtual Rental Rental { get; set; }
    }
}
