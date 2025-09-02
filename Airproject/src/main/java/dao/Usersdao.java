package dao;

import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletContext;

import dto.Users;
import util.JDBConnect;

public class Usersdao extends JDBConnect {
	public Usersdao(ServletContext application) {
		super(application);
	}
	// 회원가입
	public int insert(Users u) {
		int res = 0;
		try {
			String sql = "insert into users(id, pwd, email, name, phone, addrNum, address, birth, gender) "
					+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, u.getId());
			psmt.setString(2, u.getPwd());
			psmt.setString(3, u.getEmail());
			psmt.setString(4, u.getName());
			psmt.setString(5, u.getPhone());
			psmt.setString(6, u.getAddrNum());
			psmt.setString(7, u.getAddress());
			psmt.setDate(8, u.getBirth());
			psmt.setString(9, u.getGender());
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			res = -1;
		}
		return res;
	}
	// 회원 탈퇴
	public int delete(String id) {
		int res = 0;
		try {
			String sql = "delete from users where id = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, id);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
	public int adminDelete(String id) {
		int res = 0;
		try {
			String sql = "delete from users where id = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, id);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
	// 회원정보 수정
	public int update(Users u) {
	    int res = 0;
	    try {
	        String sql = "update users set name = ?, email = ?, phone = ?, address = ?, birth = ?, gender = ? where id = ?";
	        psmt = con.prepareStatement(sql);
	        psmt.setString(1, u.getName());
	        psmt.setString(2, u.getEmail());
	        psmt.setString(3, u.getPhone());
	        psmt.setString(4, u.getAddress());
	        psmt.setDate(5, u.getBirth());
	        System.out.println("생일 값: " + u.getBirth());
	        psmt.setString(6, u.getGender());
	        psmt.setString(7, u.getId());
	        res = psmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return res;
	}
	// 비밀번호 찾기 - 개인 정보 수정창
	public int updatePwd(Users u) {
		int res = 0;
		try {
			String sql = "update users set pwd = ? where id = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, u.getPwd());
			psmt.setString(2, u.getId());
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
	// 회원 목록
	public ArrayList<Users> selectList() {
		ArrayList<Users> ulist = new ArrayList<>();
		try {
			String sql = "select * from users";
			psmt = con.prepareStatement(sql);
			rs = psmt.executeQuery();
			while(rs.next()) {
				Users u = new Users();
				u.setId(rs.getString("id"));
                u.setPwd(rs.getString("pwd"));
                u.setEmail(rs.getString("email"));
                u.setName(rs.getString("name"));
                u.setPhone(rs.getString("phone"));
                u.setAddrNum(rs.getString("addrNum"));
                u.setAddress(rs.getString("address"));
                u.setBirth(rs.getDate("birth"));
                u.setGender(rs.getString("gender"));
                u.setCreateDate(rs.getTimestamp("createDate"));
                u.setAdmin(rs.getInt("admin"));
				ulist.add(u);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ulist;
	}
	// (로그인)
	public Users select(String id) {
		Users u = null;
		try {
			String sql = "select * from users where id = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, id);
			rs = psmt.executeQuery();
			if(rs.next()) {
				u = new Users();
				u.setId(rs.getString("id"));
				u.setPwd(rs.getString("pwd"));
				u.setEmail(rs.getString("email"));
				u.setName(rs.getString("name"));
				u.setPhone(rs.getString("phone"));
				u.setAddrNum(rs.getString("addrNum"));
				u.setAddress(rs.getString("address"));
				u.setBirth(rs.getDate("birth"));
				u.setGender(rs.getString("gender"));
				u.setCreateDate(rs.getTimestamp("createDate"));
				u.setAdmin(rs.getInt("admin"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return u;
	}
	// 아이디 찾기
	public String findId(String email, String name) {
		String res = null;
		try {
			String sql = "select id from users where email = ? and name = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, email);
			psmt.setString(2, name);
			rs = psmt.executeQuery();
			if(rs.next()) {
				String fullId = rs.getString(1);
			    int len = fullId.length();

			    if (len < 4 || len > 20) {
			        res = "[유효하지 않은 아이디 길이]"; // 또는 null 반환
			    } else {
			        String prefix = fullId.substring(0, 2); // 앞 2자
			        String suffix = fullId.substring(len - 1); // 마지막 1자
			        String stars = "*".repeat(len - 3); // 가운데 마스킹
			        res = prefix + stars + suffix;
			    }
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
	// 1. 아이디, 이름, 이메일로 사용자 존재 여부 확인 메소드
    public boolean verifyPassword(String id, String name, String email) {
        boolean exists = false;
        try {
            String sql = "SELECT COUNT(*) FROM users WHERE id = ? AND name = ? AND email = ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, id);
            psmt.setString(2, name);
            psmt.setString(3, email);
            rs = psmt.executeQuery();
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 자원 닫기 (메소드 내에서 닫는다면)
            try {
                if (rs != null) rs.close();
                if (psmt != null) psmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return exists;
    }
    // 비밀번호 찾기 - 로그인 창에서 비밀번호 찾기
    public boolean updatePassword(String id, String newPwd) {
        boolean res = false;
        try {
            String sql = "UPDATE users SET pwd = ? WHERE id = ?"; // 아이디로만 업데이트 (본인 확인은 1단계에서 완료되었기 때문)
            psmt = con.prepareStatement(sql);
            psmt.setString(1, newPwd);
            psmt.setString(2, id);
            int result = psmt.executeUpdate();
            res = (result == 1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (psmt != null) psmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return res;
    }
}
