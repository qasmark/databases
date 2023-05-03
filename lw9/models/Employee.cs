using System.Text.RegularExpressions;
using System;
using System.Linq;

namespace lw9
{
    public class Employee
    {
        public int EmployeeID { get; set; }
        public string FirstName { get; set; }
        public string SecondName { get; set; }
        public string JobPosition { get; set; }
        public double Salary { get; set; }

        public void Create()
        {
            using (var context = new MyDbContext())
            {
                var employee = new Employee();

                Console.WriteLine("Введите атрибут FirstName: ");
                employee.FirstName = Console.ReadLine();

                Console.WriteLine("Введите атрибут SecondName: ");
                employee.SecondName = Console.ReadLine();

                Console.WriteLine("Введите атрибут JobPosition: ");
                employee.JobPosition = Console.ReadLine();

                Console.WriteLine("Введите атрибут salary: ");
                employee.Salary = Int32.Parse(Console.ReadLine());

                Console.WriteLine("Работник успешно добавлен.");
                context.Employees.Add(employee);
                context.SaveChanges();
            }
        }

        public void Delete()
        {
            using (var context = new MyDbContext())
            {
                Console.WriteLine("Введите id: ");
                int id = Int32.Parse(Console.ReadLine());

                var employee = context.Employees.Find(id);

                if (employee != null)
                {
                    context.Employees.Remove(employee);
                    context.SaveChanges();
                    Console.WriteLine("Работник успешно удален.");
                }
                else
                {
                    Console.WriteLine("Работник не найден.");
                }
                context.SaveChanges();

            }

        }
        public static void AnalyzeSalary()
        {
            using (var context = new MyDbContext())
            {
                var result = context.Employees
                    .GroupBy(e => e.JobPosition)
                    .Select(g => new { JobPosition = g.Key, TotalSalary = g.Sum(e => e.Salary) })
                    .OrderByDescending(g => g.TotalSalary);

                Console.WriteLine("Аналитические данные:");
                foreach (var item in result)
                {
                    Console.WriteLine($"Должность: {item.JobPosition}, Общая зарплата: {item.TotalSalary}");
                }
            }
        }

    }


}
