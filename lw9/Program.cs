using System;
using System.Linq;

namespace lw9
{
    internal class Program
    {
        static void Help()
        {
            Console.WriteLine("Команды:\n" +
                "01 - выйти из приложения\n" +
                "\n" +
                "12 - добавить запись в бд в Client\n" +
                "13 - добавить запись в бд в Employee\n" +
                "14 - добавить запись в бд в Inventory\n" +
                "15 - добавить запись в бд в Rental\n" +
                "16 - добавить запись в бд в Sale\n" +
                "\n" +
                "22 - удалить запись в бд в Client\n" +
                "23 - удалить запись в бд в Employee\n" +
                "24 - удалить запись в бд в Inventory\n" +
                "25 - удалить запись в бд в Rental\n" +
                "26 - удалить запись в бд в Sale\n" +
                "\n" +
                "32 - изменить запись в бд в Client\n" +
                "33 - изменить запись в бд в Employee\n" +
                "34 - изменить запись в бд в Inventory\n" +
                "35 - изменить запись в бд в Rental\n" +
                "36 - изменить запись в бд в Sale\n" +
                "\n" +
                "42 - найти по строке" +
                " запись в бд в Client\n" +
                "43 - найти по строке запись в бд в Employee\n" +
                "44 - найти по строке запись в бд в Inventory\n" +
                "45 - найти по строке запись в бд в Rental\n" +
                "46 - найти по строке запись в бд в Sale\n");
        }
        static void Main(string[] args)
        {

            Help();
            using (var context = new MyDbContext())
            {
                while (true)
                {
                    Console.WriteLine("Введите команду:");
                    string command = Console.ReadLine();
                    string att1, att2, att3, att4, att5, att6;
                    DateTime data1, data2, data3;
                    double val1, val2;
                    if (command == "01")
                    {
                        Environment.Exit(0);
                    }
                    else if (command == "12")
                    {
                        Console.WriteLine("Введите аттрибут FirstName: ");
                        att1 = Console.ReadLine();
                        Console.WriteLine("Введите аттрибут SecondName: ");
                        att2 = Console.ReadLine();
                        Console.WriteLine("Введите аттрибут phone: ");
                        att3 = Console.ReadLine();
                        Console.WriteLine("Введите аттрибут email: ");
                        att4 = Console.ReadLine();
                        var client = new Client()
                        {
                            Email = att4,
                            PhoneNumber = att3,
                            SecondName = att2,
                            FirstName = att1
                        };
                        context.Clients.Add(client);
                        context.SaveChanges();
                    }
                    else if (command == "13")
                    {
                        Console.WriteLine("Введите аттрибут FirstName: ");
                        att1 = Console.ReadLine();
                        Console.WriteLine("Введите аттрибут SecondName: ");
                        att2 = Console.ReadLine();
                        Console.WriteLine("Введите аттрибут JobPosition: ");
                        att3 = Console.ReadLine();
                        Console.WriteLine("Введите аттрибут Salary: ");
                        att4 = Console.ReadLine();
                        val1 = Double.Parse(att4);
                        var employee = new Employee()
                        {
                            FirstName = att1,
                            SecondName = att2,
                            JobPosition = att3,
                            Salary = val1
                        };
                        context.Employees.Add(employee);
                        context.SaveChanges();
                        Console.ReadLine();
                    }
                    else if (command == "14")
                    {
                        var inventory = new Inventory()
                        {

                        };
                        context.Inventories.Add(inventory);
                    }
                    else if (command == "15")
                    {
                        var rental = new Rental()
                        {
                            
                        };
                        context.Rentals.Add(rental);
                    }
                    else if (command == "16")
                    {
                        var sale = new Sale()
                        {

                        };
                        context.Sales.Add(sale);

                    }
                    else if (command == "22")
                    {
                        var clientToRemove = context.Clients.FirstOrDefault();
                        if (clientToRemove != null)
                        {
                            context.Clients.Remove(clientToRemove);
                        }
                        context.SaveChanges();
                    }
                    else if (command == "23")
                    {

                    }
                    else if (command == "24")
                    {

                    }
                    else if (command == "25")
                    {

                    }
                    else if (command == "26")
                    {

                    }
                    else if (command == "32")
                    {
                        var clientToUpdate = context.Clients.FirstOrDefault();
                        if (clientToUpdate != null)
                        {
                            clientToUpdate.PhoneNumber = "8(800)-888-88-88";
                            clientToUpdate.Email = "123123@gmail.com";
                     
                        }
                        context.SaveChanges();

                    }
                    else if (command == "33")
                    {

                    }
                    else if (command == "34")
                    {

                    }
                    else if (command == "35")
                    {

                    }
                    else if (command == "36")
                    {

                    }
                    else if (command == "42")
                    {
                        var clientsWithFirstName = from c in context.Clients
                                                   where c.FirstName == "Oleg"
                                                   select c;
                        foreach (var client in clientsWithFirstName)
                        {
                            Console.WriteLine($"Client found with Oleg: ", client.ClientId);
                        }
                    }
                    else if (command == "43")
                    {

                    }
                    else if (command == "44")
                    {

                    }
                    else if (command == "45")
                    {

                    }
                    else if (command == "46")
                    {
                        // 1. Упорядочить по папкам модели + логику раскидать по папкам
                    }   // 2. реализовать полный CRUD функционал по одной таблице на выбор
                        // по всем остальным вставить-удалить

                    else if (command == "47")
                    {
                        var employees = context.Employees
                                .GroupBy(e => e.JobPosition)
                                .Select(g => new {
                                    JobPosition = g.Key,
                                    AverageSalary = g.Average(e => e.Salary),
                                    Count = g.Count()
                                })
                                .ToList();
                        foreach (var employee in employees)
                        {
                            Console.WriteLine($"Должность: {employee.JobPosition}, " +
                                $"Средняя зарплата: {employee.AverageSalary}, " +
                                $"Количество сотрудников: {employee.Count}");
                        }
                    }
                }
            }


            //using (var context = new MyDbContext())
            //{

            //    var client = new Client()
            //    {
                    
            //    };
            //    context.Clients.Add(client);
            //    context.SaveChanges();

            //    Console.WriteLine($"id: { client.ClientId }, name: { client.FirstName}, " +
            //        $"surname: {client.SecondName}, email: {client.Email}" +
            //        $"phone: {client.PhoneNumber}");
            //    Console.ReadLine();
            //}
        }
    }
}
