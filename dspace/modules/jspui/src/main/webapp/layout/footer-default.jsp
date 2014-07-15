<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

<%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null) {
%>
</div>
<div class="col-md-3"> 
    <%= sidebar%>
</div>
</div>       
<%
    }
%>


<%-- Page footer --%>

<div class="row">
    <div class="col-md-12">
        <footer class="navbar navbar-inverse">
            <div id="designedby">
                <fmt:message key="jsp.layout.footer-default.theme-by"/> <a href="http://www.cineca.it"><img
                        src="<%= request.getContextPath()%>/image/logo-cineca-small.png"
                        alt="Logo CINECA" /></a>
                <div id="footer_feedback" class="pull-right">                                    
                    <fmt:message key="jsp.layout.footer-default.text"/>&nbsp;-
                    <a target="_blank" href="<%= request.getContextPath()%>/feedback"><fmt:message key="jsp.layout.footer-default.feedback"/></a>&nbsp;-
                    <a href="<%= request.getContextPath()%>/htmlmap">Mapa do site</a>&nbsp;-
                    <a href="#">Voltar ao início</a>
                </div>
            </div>
	</footer>
    </div>
</div>
                    
<address class="text-center">
Departamento Técnico do Sistema Integrado de Bibliotecas da USP<br>
Rua da Biblioteca, s/n - Complexo Brasiliana - 05508-050 - Cidade Universitária, São Paulo, SP - Brasil<br>
<abbr title="Phone">Tel:</abbr> (0xx11) 3091-1546 e 3091-4195 &nbsp;&nbsp;E-mail: <a href="mailto:#">atendimento@sibi.usp.br</a>
</address> <br><br><br>
	
</main>
</body>
</html>