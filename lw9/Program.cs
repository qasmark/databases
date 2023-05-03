using System;
using System.Collections.Generic;
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
                 "42 - найти по строке" +
                " запись в бд в Client\n" +
                "52 - выдать аналитический запрос по зарплате профессии в бд в Employee");
        }
        static void Main()
        {
            Help();
            using (var context = new MyDbContext())
            {
                while (true)
                {
                    Console.Write("Введите команду: ");
                    int request = int.Parse(Console.ReadLine());
                    if (request == 1)
                    {
                        break;
                    }

                    switch (request)
                    {
                        case 12:
                            var client = new Client();
                            client.Create();
                            break;
                        case 13:
                            var employee = new Employee();
                            employee.Create();
                            break;
                        case 14:
                            var inventory = new Inventory();
                            inventory.Create();
                            break;
                        case 15:
                            var rental = new Rental();
                            rental.Create();
                            break;
                        case 16:
                            var sale = new Sale();
                            sale.Create();
                            break;
                        case 22:
                            var newClient = new Client();
                            newClient.Delete();
                            break;
                        case 23:
                            var newEmployee = new Employee();
                            newEmployee.Delete();
                            break;
                        case 24:
                            var newInventory = new Inventory();
                            newInventory.Delete();
                            break;
                        case 25:
                            var newRental = new Rental();
                            newRental.Delete();
                            break;
                        case 26:
                            var newSale = new Sale();
                            newSale.Delete();
                            break;
                        case 32:
                            var newClientF = new Client();

                            break;
                    }
                }
            }
        }
    }
}
