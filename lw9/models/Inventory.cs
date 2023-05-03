using System;

namespace lw9
{
    public class Inventory
    {
        public int InventoryId { get; set; }
        public string Name { get; set; }
        public int QuantityAvaliable { get; set; }
        public double RentalPrice { get; set; }
        public virtual Rental Rental { get; set; }

        public void Create()
        {
            Inventory inventory = new Inventory();

            Console.WriteLine("Введите атрибут Name: ");
            inventory.Name = Console.ReadLine();

            Console.WriteLine("Введите атрибут QuantityAvaliable: ");
            inventory.QuantityAvaliable = Int32.Parse(Console.ReadLine());

            Console.WriteLine("Введите атрибут RentalPrice: ");
            inventory.RentalPrice = double.Parse(Console.ReadLine());

            Console.WriteLine("Инвентарь успешно добавлен.");
            using (var context = new MyDbContext())
            {
                context.Inventories.Add(inventory);
                context.SaveChanges();
            }
        }

        public void Delete()
        {
            Console.WriteLine("Введите id для удаления: ");
            int id = int.Parse(Console.ReadLine());
            using (var context = new MyDbContext())
            {
                var inventory = context.Inventories.Find(id);
                if (inventory != null)
                {
                    context.Inventories.Remove(inventory);
                    context.SaveChanges();
                    Console.WriteLine("Инвентарь успешно удален.");
                }
                else
                {
                    Console.WriteLine("Инвентарь не найден.");
                }
            }
        }
    }

  
}
