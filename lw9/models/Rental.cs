using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.Remoting.Contexts;

namespace lw9
{
    public class Rental
    {
        public int RentalId { get; set; }
        public DateTime RentalDate { get; set; }
        public DateTime RentalDaysTime { get; set; }
        public bool IsReturned { get; set; }
        public virtual Client Client { get; set; }

        public void Create()
        {
            Rental rental = new Rental();

            Console.WriteLine("Введите атрибут RentalDate: ");
            rental.RentalDate = DateTime.Parse(Console.ReadLine());

            Console.WriteLine("Введите атрибут RentalDaysTime: ");
            rental.RentalDaysTime = DateTime.Parse(Console.ReadLine());

            rental.IsReturned = false;

            Console.WriteLine("Введите ID клиента: ");
            int clientId = Int32.Parse(Console.ReadLine());

            using (var context = new MyDbContext())
            {
                var client = context.Clients.Find(clientId);
                rental.Client = client;

                Console.WriteLine("Аренда успешно добавлена.");
                context.Rentals.Add(rental);
                context.SaveChanges();
            }
        }

        public void Delete()
        {
            Console.WriteLine("Введите id для удаления: ");
            int id = int.Parse(Console.ReadLine());

            using (var context = new MyDbContext())
            {
                var rental = context.Rentals.Find(id);
                if (rental != null)
                {
                    context.Rentals.Remove(rental);
                    context.SaveChanges();
                    Console.WriteLine("Аренда успешно удалена.");
                }
                else
                {
                    Console.WriteLine("Аренда не найдена.");
                }
            }
        }


    }
}
