package dao;

import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletContext;

import dto.Board;
import util.JDBConnect;

public class BoardDao extends JDBConnect {
	
	public BoardDao() {
		super();
		// TODO Auto-generated constructor stub
	}
	public BoardDao(ServletContext application) {
		super(application);
	}
	// 전체 문의글 개수
	public int getTotalQnaCount() {
        int count = 0;
        try {
			String sql = "SELECT COUNT(*) FROM board";
			psmt = con.prepareStatement(sql);
			rs = psmt.executeQuery();
			if (rs.next()) {
			    count = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return count;
    }
	// 답변 완료된 문의글 개수
	public int getAnsweredQnaCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM board WHERE answer IS NOT NULL AND answer != ''";
		try {
			psmt = con.prepareStatement(sql);
			rs = psmt.executeQuery();
			if (rs.next()) {
			    count = rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return count;
    }
	// 글 작성
	public int insertQuestion(Board b) {
		int res = 0;
		try {
			String sql = "INSERT INTO board (writer_id, title, content) VALUES (?, ?, ?)";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, b.getWriterId());
			psmt.setString(2, b.getTitle());
			psmt.setString(3, b.getContent());
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
	
	// 내 글 목록
	public ArrayList<Board> selectMyPosts(String userId) {
		ArrayList<Board> bPost = new ArrayList<>();
		try {
			String sql = "SELECT board_id, writer_id, title, content, answer, write_date, answer_date FROM board WHERE writer_id = ? ORDER BY write_date DESC";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, userId);
			rs = psmt.executeQuery();
			while(rs.next()) {
				Board b = new Board();
				b.setBoardId(rs.getInt("board_id"));
			    b.setWriterId(rs.getString("writer_id"));
			    b.setTitle(rs.getString("title"));
			    b.setContent(rs.getString("content"));
			    b.setAnswer(rs.getString("answer"));
			    b.setWriteDate(rs.getTimestamp("write_date"));
			    b.setAnswerDate(rs.getTimestamp("answer_date"));
			    bPost.add(b);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return bPost;
	}
	
	// 전체 목록 (관리자)
	public ArrayList<Board> selectAll() {
		ArrayList<Board> blist = new ArrayList<>();
		try {
			String sql = "SELECT board_id, writer_id, title, content, answer, write_date, answer_date FROM board ORDER BY write_date DESC";
			psmt = con.prepareStatement(sql);
			rs = psmt.executeQuery();
			while(rs.next()) {
				Board b = new Board();
				b.setBoardId(rs.getInt("board_id"));
			    b.setWriterId(rs.getString("writer_id"));
			    b.setTitle(rs.getString("title"));
			    b.setContent(rs.getString("content"));
			    b.setAnswer(rs.getString("answer"));
			    b.setWriteDate(rs.getTimestamp("write_date"));
			    b.setAnswerDate(rs.getTimestamp("answer_date"));
			    blist.add(b);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return blist;
	}
	
	// 게시글 상세 조회
	public Board selectById(int boardId) {
		Board b = null;
		try {
			String sql = "SELECT board_id, writer_id, title, content, answer, write_date, answer_date FROM board WHERE board_id = ?";
			psmt = con.prepareStatement(sql);
			psmt.setInt(1, boardId);
			rs = psmt.executeQuery();
			if(rs.next()) {
				b = new Board();
				b.setBoardId(rs.getInt("board_id"));
			    b.setWriterId(rs.getString("writer_id"));
			    b.setTitle(rs.getString("title"));
			    b.setContent(rs.getString("content"));
			    b.setAnswer(rs.getString("answer"));
			    b.setWriteDate(rs.getTimestamp("write_date"));
			    b.setAnswerDate(rs.getTimestamp("answer_date"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return b;
	}

	// 관리자 답변 작성
	public int updateAnswer(int boardId, String answer) {
		int res = 0;
		try {
			String sql = "UPDATE board SET answer = ?, answer_date = NOW() WHERE board_id = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, answer);
			psmt.setInt(2, boardId);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}
}
