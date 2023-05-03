using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System;
using System.Text.RegularExpressions;

namespace lw9
{
    public class Client
    {
        public int ClientId { get; set; }
        public string FirstName { get; set; }
        public string SecondName { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }

        public void Create()
        {
            using (var context = new MyDbContext())
            {
                var client = new Client();

                Console.WriteLine("Введите атрибут FirstName: ");
                client.FirstName = Console.ReadLine();

                Console.WriteLine("Введите атрибут SecondName: ");
                client.SecondName = Console.ReadLine();

                Regex phoneRegex = new Regex(@"^\d{10}$"); // проверка на 10 цифр

                while (true)
                {
                    Console.WriteLine("Введите атрибут PhoneNumber: ");
                    string phone = Console.ReadLine();
                    if (!phoneRegex.IsMatch(phone))
                    {
                        Console.WriteLine("Некорректный ввод, требуется номер из 10 цифр.");
                    }
                    else
                    {
                        client.PhoneNumber = phone;
                        break;
                    }
                }

                // Для проверки адреса электронной почты
                Regex emailRegex = new Regex(@"^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$");

                while (true)
                {
                    Console.WriteLine("Введите атрибут Email: ");
                    string email = Console.ReadLine();
                    if (!emailRegex.IsMatch(email))
                    {
                        Console.WriteLine("Некорректный ввод, требуется правильный адрес " +
                            "электронной почты.");
                    }
                    else
                    {
                        client.Email = email;
                        break;
                    }
                }
                Console.WriteLine("Клиент успешно добавлен.");
                context.Clients.Add(client);
                context.SaveChangesAsync();
            }
        }

        public Client Read()
        {
            Console.WriteLine("Введите id: ");
            int id = Int32.Parse(Console.ReadLine());

            using (var context = new MyDbContext())
            {
                try
                {
                    var client = context.Clients.FirstOrDefault(c => c.ClientId == id);
                    if (client == null)
                    {
                        Console.WriteLine($"Клиент с идентификатором {id} не найден.");
                    }
                    return client;
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Ошибка при выполнении запроса в базу данных: {ex.Message}");
                    return null;
                }
            }
        }

        public void Update()
        {
            using (var context = new MyDbContext())
            {
                Console.WriteLine("Введите id: ");
                int id = Int32.Parse(Console.ReadLine());
                var clientToUpdate = context.Clients.Find(id);
                PrintClient(clientToUpdate);
                Console.Write("Какой атрибут вы хотите изменить? (Вводите по имени): ");
                string request = Console.ReadLine();
                switch (request)
                {
                    case "FirstName":
                        clientToUpdate.FirstName = Console.ReadLine();
                        break;
                    case "SecondName":
                        clientToUpdate.SecondName = Console.ReadLine();
                        break;
                    case "PhoneNumber":
                        clientToUpdate.PhoneNumber = Console.ReadLine();
                        break;
                    case "Email":
                        clientToUpdate.Email = Console.ReadLine();
                        break;
                }
                context.SaveChanges();
            }
        }
        public void Delete()
        {
            using (var context = new MyDbContext())
            {
                Console.WriteLine("Введите id: ");
                int id = Int32.Parse(Console.ReadLine());

                var client = context.Clients.Find(id);

                context.Clients.Remove(client);

                context.SaveChanges();
            }
        }

        // методы поиска по строке
        public List<Client> SearchBySecondName()
        {
            Console.WriteLine("Введите фамилию, по которой вы хотите найти клиентов: ");
            string request = Console.ReadLine();

            using (var context = new MyDbContext())
            {
                return context.Clients.Where(c => c.SecondName.Contains(request)).ToList();
            }
        }

        public List<Client> SearchByFirstName()
        {
            Console.WriteLine("Введите имя, по которому вы хотите найти клиентов: ");
            string request = Console.ReadLine();
            using (var context = new MyDbContext())
            {
                return context.Clients.Where(c => c.FirstName.Contains(request)).ToList();
            }
        }
        public List<Client> SearchByPhoneNumber()
        {
            Console.WriteLine("Введите номер телефона, по которому вы хотите найти клиентов: ");
            string request = Console.ReadLine();
            using (var context = new MyDbContext())
            {
                return context.Clients.Where(c => c.PhoneNumber.Contains(request)).ToList();
            }
        }
        public List<Client> SearchByEmail(string email)
        {
            Console.WriteLine("Введите почту, по которому вы хотите найти клиентов: ");
            string request = Console.ReadLine();
            using (var context = new MyDbContext())
            {
                return context.Clients.Where(c => c.Email.Contains(request)).ToList();
            }
        }

        // Печать на экран
        public void PrintClient(Client client)
        {
            Console.WriteLine($"id: {client.ClientId}\nname: {client.FirstName}\n" +
                $"surname: {client.SecondName}\nemail: {client.Email}\n" +
                $"phone: {client.PhoneNumber}");
        }

        public void PrintClients(List<Client> clients)
        {
            foreach (Client client in clients)
            {
                PrintClient(client);
                Console.WriteLine("\n");
            }
        }

    }
}
