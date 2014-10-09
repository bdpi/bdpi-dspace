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
        <footer class="navbar navbar-inverse" style="background-color:transparent">
		<br><br>
            <div id="designedby" style="background-color:#FEB524; height:45px;position:relative; float:left; width:100%">
                <h6 style="color:white; font-weight:bold; position:relative; top:-10px">&nbsp;&nbsp;<fmt:message key="jsp.layout.footer-default.theme-by"/> &nbsp;&nbsp;<a href="http://www.cineca.it"><img
                        style="width:35px"
						src="<%= request.getContextPath()%>/image/logo-cineca-small.png"
                        alt="Logo CINECA" /></a>
				<div id="footer_feedback" class="pull-right">
				<fmt:message key="jsp.layout.footer-default.text" />&nbsp;&nbsp;&nbsp;-&nbsp;
                    <a target="_blank" href="<%= request.getContextPath()%>/feedback"><fmt:message key="jsp.layout.footer-default.feedback"/></a>&nbsp;-&nbsp;
                    <a href="<%= request.getContextPath()%>/htmlmap">Mapa do site</a>&nbsp;-&nbsp;
                    <a href="#">Voltar ao in&iacute;cio</a>&nbsp;&nbsp;
				</div>
				</h6>	
            </div>
		</footer>
<h5>
		<address class="text-center">
Departamento Técnico do Sistema Integrado de Bibliotecas da USP<br>
Rua da Biblioteca, s/n - Complexo Brasiliana - 05508-050 - Cidade Universitária, São Paulo, SP - Brasil<br>
<span class="glyphicon glyphicon-phone-alt"></span> (0xx11) 3091-1546 e 3091-4195 &nbsp;&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-envelope" /><a href="mailto:#" style="position:relative; right:8px; top:-2px"> atendimento@sibi.usp.br</a>
</address> <br><br><br></h5>
    </div>

</div>


</main>

</body>
</html>