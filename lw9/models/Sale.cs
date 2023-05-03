using System;
using System.Security.Policy;

namespace lw9
{
    public class Sale
    {
        public int SaleId { get; set; }
        public string SaleDate { get; set; }
        public double SaleAmount { get; set; }
        public bool IsPaid { get; set; }
        public virtual Employee Employee { get; set; }
        public virtual Rental Rental { get; set; }

     

        public void Create()
        {
            Sale sale = new Sale();

            Console.WriteLine("Введите дату продажи: ");
            sale.SaleDate = Console.ReadLine();

            Console.WriteLine("Введите сумму продажи: ");
            sale.SaleAmount = double.Parse(Console.ReadLine());

            Console.WriteLine("Продажа оплачена? (да/нет): ");
            string isPaidString = Console.ReadLine();
            sale.IsPaid = isPaidString.Equals("да", StringComparison.OrdinalIgnoreCase);

            Console.WriteLine("Введите ID продавца: ");
            int employeeId = int.Parse(Console.ReadLine());
            using (var context = new MyDbContext())
            {
                var employee = context.Employees.Find(employeeId);
                if (employee != null)
                {
                    sale.Employee = employee;
                }
                else
                {
                    Console.WriteLine("Продавец не найден.");
                    return;
                }
            }

            Console.WriteLine("Введите ID аренды (если есть): ");
            int rentalId = int.Parse(Console.ReadLine());
            if (rentalId != 0)
            {
                using (var context = new MyDbContext())
                {
                    var rental = context.Rentals.Find(rentalId);
                    if (rental != null)
                    {
                        sale.Rental = rental;
                    }
                    else
                    {
                        Console.WriteLine("Аренда не найдена.");
                        return;
                    }
                }
            }

            Console.WriteLine("Продажа успешно добавлена.");
            using (var context = new MyDbContext())
            {
                context.Sales.Add(sale);
                context.SaveChanges();
            }
        }

        public void Delete()
        {
            Console.WriteLine("Введите ID продажи для удаления: ");
            int saleId = int.Parse(Console.ReadLine());
            using (var context = new MyDbContext())
            {
                var sale = context.Sales.Find(saleId);
                if (sale != null)
                {
                    context.Sales.Remove(sale);
                    context.SaveChanges();
                    Console.WriteLine("Продажа успешно удалена.");
                }
                else
                {
                    Console.WriteLine("Продажа не найдена.");
                }
            }
        }

    }

}
