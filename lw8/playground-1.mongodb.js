// 6. Инвентарь, клиенты, прокат инвентаря.

db = connect("localhost:27017");

// 3.1 Отобразить коллекции баз данных
db.getCollectionNames();

// 3.2 вставка одной записи insertOne

db.client.insertOne({
    first_name: "John",
    last_name: "Doe",
    phone_number: "555-1234",
    email: "john.doe@example.com"
});

db.inventory.insertOne({
    name: "Kite",
    quantity_available: 8,
    price: 12.99
})

db.rental.insertOne({
    rental_date: "18-04-2023",
    return_date: "25-04-2023",
    due_date: 7,
    rental_fee: 90.93,
    is_returned: false,
    inventory_id: db.inventory.findOne()._id,
    client_id: db.client.findOne()._id
})
db.rental.find();

db.rental.find();
db.inventory.insertOne({
    name: "Ski",
    quantity_available: 5,
    price: 15.99
})

// 3.2 Вставка нескольких записей insertMany
db.employee.insertMany([{
        first_name: "Oleg",
        second_name: "Olegov",
        job_position: "Shop assistant",
        salary: 25000
    },
    {
        first_name: "Ivan",
        second_name: "Ivanov",
        job_position: "Manager",
        salary: 35000
    },
    {
        first_name: "Oleg",
        second_name: "Divanov",
        job_position: "Intern",
        salary: 15000
    }
])
db.client.insertMany([{
        first_name: "Ivan",
        second_name: "Russian",
        phone_number: "234-333",
        email: ""
    },
    {
        first_name: "Oleg",
        second_name: "Mongol",
        phone_number: "144-001",
        email: "olegmongol@gmail.com"
    },
    {
        first_name: "Ruslan",
        second_name: "Enlgishman",
        phone_number: "234-333",
        email: "123123@gmail.com"
    }
])

db.sale.insertOne({
    sale_date: "18-04-2023",
    total_amount: 90.93,
    is_paid: true,
    rental_id: db.rental.findOne({ _id: ObjectId("643faeb2d597d16e5362c9ba") })._id,
    employee_id: db.employee.findOne({ _id: ObjectId("643faf999cd25dd62c1297ee") })._id
})


db.getCollectionNames();
db.client.find();
db.rental.find();
db.employee.find();
db.sale.find();

// 3.3 Удаление записей
// Удаление одной записи по условию deleteOne
db.employee.deleteOne({ first_name: "Ivan" });

// Удаление нескольких записей по условию deleteMany
//db.client.deleteMany({ phone_number: "234-333" });

// 3.4 Поиск записей
// Поиск по ID
db.client.findOne({ _id: ObjectId("643fafcf943903ae292cdff0") });

// Поиск записи по атрибуту первого уровня
db.employee.find({ "first_name": "Oleg" });

// Поиск записи по нескольким атрибутам (логический оператор AND)
db.employee.find({
    "$and": [
        { first_name: "Oleg" },
        { second_name: "Olegov" }
    ]
});

// Поиск записи по одному из условий (логический оператор OR)
db.employee.find({
    "$or": [
        { salary: 25000 },
        { job_position: "Intern" }
    ]
})

// Поиск с использованием оператора сравнения
db.inventory.find({
    price: { "$gte": 13 },
})

// Поиск с использованием двух операторов сравнения
db.employee.find({
    salary: { "$gt": 15000, "$lte": 30000 }
})

// массив сделать с работниками на знание языков

// Поиск по значению в массиве
db.employee.find({}, { "languages.0": 1 });
// Поиск по количеству элементов в массиве
db.employee.find({
    langauges: { "$size": 1 }
})
db.employee.find();
// Поиск записей без атрибута
db.sale.find({
    is_paid: { "$exists": false }
})
db.employee.find();
// 3.5 Обновление записей
// Изменить значение атрибута у записи
db.inventory.updateOne({ _id: ObjectId("643fdaf1c16e15f6db433a1d") }, { "$set": { price: 16 } })

db.inventory.find();

// Добавить атрибут записи
db.employee.updateMany({}, { "$set": { expreience: 1 } })
db.employee.find();
db.client.find();
// Удалить атрибут у записи
db.client.updateOne({ _id: ObjectId("643fafcf943903ae292cdfef") }, { "$unset": { "email": "" } });