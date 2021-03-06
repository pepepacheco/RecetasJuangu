package chapter13.Ej1;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Recipe 13-1:  Create Connection
 * 
 * @author juneau
 */
public class CreateConnection {
    
    static Properties props = new Properties();
    
    
    String hostname = null;
    String port = null;
    String database = null;
    String username = null;
    String password = null;
    String driver = null;
    String jndi = null;
    
    public CreateConnection(){
        try (InputStream in = Files.newInputStream(FileSystems.getDefault().
                getPath(System.getProperty("user.dir") +
                        File.separator + "db_props.properties")); ) {
            // Looks for properties file in the root of the src directory in Netbeans project
           
            props.load(in);
            in.close();
        } catch (IOException ex) {
            ex.printStackTrace();

        } 
        loadProperties();

    }

    public final void loadProperties(){
        hostname = props.getProperty("host_name");
        port = props.getProperty("port_number");
        database = props.getProperty("db_name");
        username = props.getProperty("username");
        password = props.getProperty("password");
        driver = props.getProperty("driver");
        jndi = props.getProperty("jndi");

    }
    
    /**
     * Demonstrates obtaining a connection via DriverManager
     * @return
     * @throws SQLException 
     */
        public Connection getConnection() throws SQLException {
            Connection conn = null;
            String jdbcUrl;
            if(driver.equals("derby")){
                jdbcUrl = "jdbc:derby://" + this.hostname + ":" + 
                            this.port  + "/" + this.database;
            } else  {
                jdbcUrl = "jdbc:oracle:thin:@" + this.hostname + ":" + 
                            this.port  + ":" + this.database;
            }
            conn = DriverManager.getConnection(jdbcUrl, username, password);
            System.out.println("Successfully connected");
            return conn;
        }
    
    /**
     * Demonstrates obtaining a connection via a DataSource object
     * @return 
     */
    public Connection getDSConnection() {
        Connection conn = null;
        try {
            Context ctx = new InitialContext();
            DataSource ds = (DataSource)ctx.lookup(this.jndi);
            conn = ds.getConnection();

        } catch (NamingException | SQLException ex) {
            ex.printStackTrace();
        }
        return conn;
    }
    
    public static void main(String[] args){
        CreateConnection createConnection = new CreateConnection();
        try {
            createConnection.getConnection();
        } catch (SQLException e){
            e.printStackTrace();
        }
    }
}