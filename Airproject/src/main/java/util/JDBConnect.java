package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletContext;

public class JDBConnect {
	// 데이터베이스와 연결 담당
    public Connection con;
    // 정적 쿼리문을 실행할 때
    public Statement stmt;
    // 동적 쿼리문을 실행할 때 
    public PreparedStatement psmt;
    // select 쿼리문의 결과를 저장할 때 
    public ResultSet rs;

    // 기본 생성자
    public JDBConnect() {
        try {
            // JDBC 드라이버 로드
        	// 객체 생성
            Class.forName("com.mysql.jdbc.Driver");

            // DB에 연결
            String url = "jdbc:mysql://localhost:3306/air";  
            
            
            String id = "root";
            String pwd = "87938260"; 
            
            con = DriverManager.getConnection(url, id, pwd); 

            System.out.println("DB 연결 성공(기본 생성자)");
        }
        catch (Exception e) {            
            e.printStackTrace();
        }
    }
    
    
    // 연결 해제(자원 반납)
    public void close() { 
        try {            
            if (rs != null) rs.close(); 
            if (stmt != null) stmt.close();
            if (psmt != null) psmt.close();
            if (con != null) con.close(); 

            System.out.println("JDBC 자원 해제");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    // 두 번째 생성자
    public JDBConnect(String driver, String url, String id, String pwd) {
        try{
            // JDBC 드라이버 로드
            Class.forName(driver);  

            // DB에 연결
            con = DriverManager.getConnection(url, id, pwd);

            System.out.println("DB 연결 성공(인수 생성자 1)");
        }
        catch (Exception e) {            
            e.printStackTrace();
        }
    }

    // 세 번째 생성자
    public JDBConnect(ServletContext application) {
        try {
            // JDBC 드라이버 로드
            String driver = application.getInitParameter("MySqlDriver"); 
            Class.forName(driver); 
            
            // DB에 연결
            String url = application.getInitParameter("MySqlURL"); 
            String id = application.getInitParameter("MySqlId");
            String pwd = application.getInitParameter("MySqlPwd");
            con = DriverManager.getConnection(url, id, pwd);

            System.out.println("DB 연결 성공(인수 생성자 2)"); 
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Connection connect (ServletContext application) {
        try {
            // JDBC 드라이버 로드
            // DB에 연결
            String url = application.getInitParameter("MySqlURL"); 
            String id = application.getInitParameter("MySqlId");
            String pwd = application.getInitParameter("MySqlPwd");
            con = DriverManager.getConnection(url, id, pwd);
            System.out.println("DB 연결 성공(함수)"); 
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
    
    
	public Connection getCon() {
		return con;
	}
	public void setCon(Connection con) {
		this.con = con;
	}
	public Statement getStmt() {
		return stmt;
	}
	public void setStmt(Statement stmt) {
		this.stmt = stmt;
	}
	public PreparedStatement getPsmt() {
		return psmt;
	}
	public void setPsmt(PreparedStatement psmt) {
		this.psmt = psmt;
	}
	public ResultSet getRs() {
		return rs;
	}
	public void setRs(ResultSet rs) {
		this.rs = rs;
	}
    
}
