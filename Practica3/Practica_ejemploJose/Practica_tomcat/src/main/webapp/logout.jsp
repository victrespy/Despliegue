<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  session.invalidate();
  response.setHeader("Cache-Control","no-store");
  response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
