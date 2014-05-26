<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Feedback form JSP
  -
  - Attributes:
  -    feedback.problem  - if present, report that all fields weren't filled out
  -    authenticated.email - email of authenticated user, if any
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    boolean problem = (request.getParameter("feedback.problem") != null);
    String email = request.getParameter("email");

    if (email == null || email.equals(""))
    {
        email = (String) request.getAttribute("authenticated.email");
    }

    if (email == null)
    {
        email = "";
    }

    String feedback = request.getParameter("feedback");
    if (feedback == null)
    {
        feedback = "";
    }

    String fromPage = request.getParameter("fromPage");
    if (fromPage == null)
    {
		fromPage = "";
    }
%>

<dspace:layout titlekey="jsp.feedback.form.title">
    <%-- <h1>Feedback Form</h1> --%>
    <h1><fmt:message key="jsp.feedback.form.title"/></h1>

    <%-- <p>Thanks for taking the time to share your feedback about the
    DSpace system. Your comments are appreciated!</p> --%>
    <p><fmt:message key="jsp.feedback.form.text1"/></p>

<%
    if (problem)
    {
%>
        <%-- <p><strong>Please fill out all of the information below.</strong></p> --%>
        <p><strong><fmt:message key="jsp.feedback.form.text2"/></strong></p>
<%
    }
%>
    <form action="<%= request.getContextPath() %>/feedback" method="post" class="form-horizontal" role="form">
        <div class="form-group">
            <label for="temail" class="col-sm-2 control-label"><fmt:message key="jsp.feedback.form.email"/></label>
             <div class="col-sm-10">
            <input type="text" name="email" class="form-control" id="temail" size="50" value="<%=StringEscapeUtils.escapeHtml(email)%>" />
            </div>
        </div>
        <div class="form-group">
            <label for="tfeedback" class="col-sm-2 control-label"><fmt:message key="jsp.feedback.form.comment"/></label>
            <div class="col-sm-10">
            <textarea name="feedback" class="form-control" id="tfeedback" rows="6" cols="50"><%=StringEscapeUtils.escapeHtml(feedback)%></textarea>
            </div>
         </div>   
        <div class="col-sm-offset-2 col-sm-10">
            <input type="submit" name="submit" class="btn btn-default" value="<fmt:message key="jsp.feedback.form.send"/>" />
        </div>
    </form>
<br/><br/>
</dspace:layout>
