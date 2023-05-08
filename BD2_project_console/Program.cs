// See https://aka.ms/new-console-template for more information

using System.Dynamic;
using System.Runtime.CompilerServices;
using System.Security.AccessControl;
using BD2_project_lib;
using System.Text.Json;
using System.Text.Json.Serialization;
using Newtonsoft.Json;

Class1 c = new Class1();

//1 zrobienie connection z baza danych
var  conn = c.ConnectToSqlServer("localhost", "BD2_database");

dynamic jsondynamic = new ExpandoObject();
jsondynamic.pesel = "123456789";
jsondynamic.fname = "Stanisław";
jsondynamic.lname = "Kowalski";
jsondynamic.phone_num = "661663668";

var desobj =JsonConvert.SerializeObject(jsondynamic);
Console.WriteLine($"'{desobj}'");


string str = c.FindValue(conn, $"'{desobj}'", "fname");
Console.WriteLine(str);
int choice = 0;
while (choice != 11)
{
    Console.WriteLine("MENU:");
    Console.WriteLine("1. Find value");
    Console.WriteLine("11. Exit App");
    Console.WriteLine("Enter your choice: ");
    choice = Convert.ToInt32(Console.ReadLine());

    // "'{ "pesel" : "123456789", "fname" : "Stanisław", "lname" : "Kowalski", "phone_num" : "661663668"}'"
    
    
    switch (choice)
    {
        case 1:
            c.FindValue(conn, desobj, "fname");
            break;
    }
    




}