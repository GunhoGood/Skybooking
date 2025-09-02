package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.Usersdao;
import dto.Users;

@WebServlet("/checkId")
public class Checkidcontroller extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = req.getParameter("id");

        Usersdao dao = new Usersdao(req.getServletContext());
        Users u = dao.select(id);
        dao.close();

        resp.setContentType("text/plain; charset=UTF-8");
        if (u == null) {
            resp.getWriter().write("available");
        } else {
            resp.getWriter().write("unavailable");
        }
    }
}
