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



    public String FindValue(SqlConnection conn,string json_data, string key)
    {
        conn.Open();
        SqlCommand cmd = new SqlCommand("SELECT  dbo.find_value(@json_data, @key)", conn);
        
        cmd.Parameters.AddWithValue("@json_data", json_data);
        cmd.Parameters.AddWithValue("@key", key);
        
        string str = cmd.ExecuteScalar().ToString();

        conn.Close();
        return str;

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
    
    
    



}