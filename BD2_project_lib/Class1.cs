using System;
using System.Data.SqlClient;
using Dapper;
using DotNetEnv;
using System.IO;
// using Microsoft.SqlServer.Management.Common;
// using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Server;

namespace BD2_project_lib;

public class Class1
{
    public SqlConnection ConnectToSqlServer(String host, String database)
    {
        //create connection string
        string connectionString = "Server=" + host + ";Database=" + database + ";Trusted_Connection=True;";
        
        //create connection
        SqlConnection connection = new SqlConnection(connectionString);
        
        //open connection
        connection.Open();
        Console.WriteLine("Connection opened");
        
        //close connection
        Console.WriteLine("Connection closed");
        connection.Close();
        
        return connection;
    }

    public void CreateDb(SqlConnection conn)
    {
        string script = File.ReadAllText(@"\createDB.sql");
        Server server = new Server(conn);
        server.ConnectionContext.ExecuteNonQuery(script);
    }

    // public void Printpatients(SqlConnection connection)
    // {
    //     //     foreach (var data in connection.Query(@"SELECT * FROM dbo.patient"))
    //     //     {
    //     //         Console.WriteLine("lName: {0}",data.patient_data);
    //     //     }
    //     // }
    //     var patient_data = connection.Query();
    // }


    public void InsertPatient(SqlConnection conn, string jString)
    {
        if(jString == null)
        {
            return;
        }
        //set dynamic parameters
        DynamicParameters parameters = new DynamicParameters();
        parameters.Add("patient_data", jString);
        
        conn.QuerySingleOrDefault("dbo.insertPatient", parameters, commandType: System.Data.CommandType.StoredProcedure);
        
        
        // call procedure to insert patient into patient table
        // conn.Execute("exec dbo.insertPatient  @jsonData", new { jsonData = jString });

    }
    
    
    //functions that checks if tables exists
    public bool CheckIfTableExists(SqlConnection connection, String tableName)
    {
        //check if table exists
        var tableExists = connection.Query(@"SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @tableName", new {tableName});
        if (tableExists != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    

    // //write method that connects to sql server
    // public void ConnectToSqlServer()
    // {
    //     //create connection string
    //     string connectionString = "Server=localhost;Database=BD2_database;Trusted_Connection=True;";
    //     
    //     //create connection
    //     using SqlConnection connection = new SqlConnection(connectionString);
    //     
    //     foreach (var data in connection.Query(@"SELECT * FROM dbo.test_table"))
    //     {
    //         Console.WriteLine(data);
    //         Console.WriteLine(data.lname);
    //     }
    //     
    //     
    //     
    //     //close connection
    //     Console.WriteLine("Connection closed");

    // }
    



}