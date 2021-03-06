<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Default navigation bar
--%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean) request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf('?');
    if (c > -1) {
        currentPage = currentPage.substring(0, c);
    }

    // E-mail may have to be truncated. Trocado pelo nome de usuário
    String navbarUserFirstName = null;

    if (user != null) {
        navbarUserFirstName = user.getFirstName();
    }

    // get the browse indices
    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
    BrowseInfo binfo = (BrowseInfo) request.getAttribute("browse.info");
    String browseCurrent = "";
    if (binfo != null) {
        BrowseIndex bix = binfo.getBrowseIndex();
        // Only highlight the current browse, only if it is a metadata index,
        // or the selected sort option is the default for the index
        if (bix.isMetadataIndex() || bix.getSortOption() == binfo.getSortOption()) {
            if (bix.getName() != null) {
                browseCurrent = bix.getName();
            }
        }
    }
%>


<div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
</div>
<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation" >
    <ul class="nav navbar-nav" >
        <li class="<%= currentPage.endsWith("/home.jsp") ? "active" : ""%>"><a href="<%= request.getContextPath()%>/"><span class="glyphicon glyphicon-home"></span> <fmt:message key="jsp.layout.navbar-default.home"/></a></li>

        
        
    </ul>
    <ul class="nav navbar-nav navbar-right">

        <li class="dropdown">
            <%
                if (user != null) {
            %>
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.loggedin">
                    <fmt:param><%= StringUtils.abbreviate(navbarUserFirstName, 20)%></fmt:param>    
                </fmt:message> <b class="caret"></b></a>
                <%
                } else {
                %>
            <a href="<%= request.getContextPath()%>/mydspace"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.login.password.title"/></a><!-- jsp.layout.navbar-default.sign -->
                <% }%>             
            <ul class="dropdown-menu">
               
                <li><a href="<%= request.getContextPath()%>/mydspace"><fmt:message key="jsp.layout.navbar-default.users"/></a></li>
                <li><a href="<%= request.getContextPath()%>/subscribe"><fmt:message key="jsp.layout.navbar-default.receive"/></a></li>
                <li><a href="<%= request.getContextPath()%>/profile"><fmt:message key="jsp.layout.navbar-default.edit"/></a></li>

                <%
                    if (isAdmin) {
                %>
                <li class="divider"></li>  
                <li><a href="<%= request.getContextPath()%>/dspace-admin"><fmt:message key="jsp.administer"/></a></li>
                    <%
                        }
                        if (user != null) {
                    %>
                <li><a href="<%= request.getContextPath()%>/logout"><span class="glyphicon glyphicon-log-out"></span> <fmt:message key="jsp.layout.navbar-default.logout"/></a></li>
                    <% }%>
            </ul>
        </li>
    </ul>
    <ul class="nav navbar-nav navbar-right" style="background-color:#1094ab;padding:0;margin-top:0; margin-bottom:0 ">
<li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" style="color:white"><fmt:message key="jsp.layout.navbar-default.browse"/> <strong class="caret"></strong></a>
            <ul class="dropdown-menu" >
                <li><a href="<%= request.getContextPath()%>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
  
                    <%-- Insert the dynamic browse indices here --%>

                <%
                    for (int i = 0; i < bis.length; i++) {
                        BrowseIndex bix = bis[i];
                        String key = "browse.menu." + bix.getName();
                %>
                <li><a href="<%= request.getContextPath()%>/browse?type=<%= bix.getName()%>"><fmt:message key="<%= key%>"/></a></li>
                    <%
                        }
                    %>

                <%-- End of dynamic browse indices --%>

            </ul>
        </li>
	</ul>
    <%-- Search Box --%>
	<ul class="nav navbar-nav navbar-right" style="background-color:#1094ab;">
    <form method="get" action="<%= request.getContextPath()%>/simple-search" class="navbar-form navbar-right" scope="search" >
        <div class="form-group" style="height:35px; color: white; font-size:1em; height-align:middle">
	<label for="tequery"><fmt:message key="jsp.search.title"/>&nbsp;&nbsp;&nbsp;</label>
            <input type="text" class="form-control" name="query" id="tequery" size="25"/>
			<!-- 
			Parte que tirei do input: placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>"
			-->

        </div>
        <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span></button>
	
		
		
            <%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
            <%
                                    if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
                                    {
            %>        
                          <br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
            <%
                        }
            %>
			--%>
    </form></ul>
	
    <!-- Button trigger modal -->
    <!-- Modal Política de Acesso Aberto -->

    <div class="modal fade" id="openAccessPolicy" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <fmt:message key="page.openaccesspolicy" var="paginat"/>
            <dspace:include page="${paginat}"/>
        </div>
    </div>

    <!-- Modal Política de privacidade -->
    <div class="modal fade" id="politicaDePrivacidade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <fmt:message key="page.privacypolicy" var="paginapp"/>
                <dspace:include page="${paginapp}"/>
            </div>
        </div>
    </div>

    <!-- Modal Direitos Autorais -->
    <div class="modal fade" id="direitosAutorais" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <fmt:message key="page.rights" var="paginart"/>
                <dspace:include page="${paginart}"/>
            </div>
        </div>
    </div>

    <!-- Modal FAQ -->
    <div class="modal fade" id="faq" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" >
                <fmt:message key="page.faq" var="paginafaq"/>
                <dspace:include page="${paginafaq}"/>
            </div>
        </div>
    </div>

    <!-- Modal Créditos -->
    <div class="modal fade" id="creditos" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <fmt:message key="page.creditos" var="paginacreditos"/>
                <dspace:include page="${paginacreditos}"/>
            </div>
        </div>
    </div>       

   <!-- Modal MAP -->
    <div class="modal fade" id="map" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content" >
                <fmt:message key="page.map" var="paginamap"/>
                <dspace:include page="${paginamap}"/>
            </div>
        </div>
    </div>
    

</nav>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script>

$(document).ready(function(){

	$("a[data-target='#faq']").css('cursor','pointer');

	});

</script>







