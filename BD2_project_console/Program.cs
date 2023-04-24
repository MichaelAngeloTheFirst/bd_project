// See https://aka.ms/new-console-template for more information
using BD2_project_lib;



Class1 c = new Class1();

//1 zrobienie connection z baza danych
var  conn = c.ConnectToSqlServer("localhost", "BD2_database");
// c.Printpatients(conn);

//2 zinsertowanie jsona do bd
string patient1  = @"{
    'FirstName': 'Steven',
    'LastName': 'Doe',
    'Pesel' : '12345678901',
    'PhoneNumber' : '123456789',
    'VaccinationDate' : '2021-05-05'
}";
// Console.WriteLine(patient1);

// c.InsertPatient(conn, patient1);
