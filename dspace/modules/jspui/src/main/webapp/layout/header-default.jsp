<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - HTML header for main home page
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteURL = ConfigurationManager.getProperty("dspace.baseUrl");
    String imageFacebook = siteURL + "/image/logo-usp-facebook.jpg";
    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String) request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List) request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String) request.getAttribute("dspace.layout.head");
    String extraHeadDataLast = (String) request.getAttribute("dspace.layout.head.last");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace " + dsVersion;
    String analyticsKey = ConfigurationManager.getProperty("jspui.google.analytics.key");
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://ogp.me/ns/fb#">
    <head>
        <title><%= title%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Generator" content="<%= generator%>" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/jquery-ui-1.10.3.custom/redmond/jquery-ui-1.10.3.custom.css" type="text/css" />
        <!-- <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/bdpi/bdpi.css" type="text/css" /> -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/bdpi/bdpi-theme.css" type="text/css" />
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/bdpi/dspace-theme.css" type="text/css" />
        <%
            if (!"NONE".equals(feedRef)) {
                for (int i = 0; i < parts.size(); i += 3) {
        %>
        <link rel="alternate" type="application/<%= (String) parts.get(i)%>" title="<%= (String) parts.get(i + 1)%>" href="<%= request.getContextPath()%>/feed/<%= (String) parts.get(i + 2)%>/<%= feedRef%>"/>
        <%
                }
            }

            if (osLink) {
        %>
        <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath()%>/<%= osCtx%>description.xml" title="<%= osName%>"/>
        <%
            }

            if (extraHeadData != null) {%>
        <%= extraHeadData%>
        <%
            }
        %>

        <script type='text/javascript' src="<%= request.getContextPath()%>/static/js/jquery/jquery-1.10.2.min.js"></script>
        <script type='text/javascript' src='<%= request.getContextPath()%>/static/js/jquery/jquery-ui-1.10.3.custom.min.js'></script>
        <script type='text/javascript' src='<%= request.getContextPath()%>/static/js/bdpi/bdpi.min.js'></script>
        <script type='text/javascript' src='<%= request.getContextPath()%>/static/js/holder.js'></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/utils.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/choice-support.js"></script>

        <%--Gooogle Analytics recording.--%>
        <%
            if (analyticsKey != null && analyticsKey.length() > 0) {
        %>
        <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', '<%= analyticsKey%>']);
            _gaq.push(['_trackPageview']);

            (function() {
                var ga = document.createElement('script');
                ga.type = 'text/javascript';
                ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0];
                s.parentNode.insertBefore(ga, s);
            })();
        </script>
        <%
            }
            if (extraHeadDataLast != null) {%>
        <%= extraHeadDataLast%>
        <%
            }
        %>

        <!-- Facebook -->
        
        <meta property="og:image" content="<%= imageFacebook%>" />
        <meta property="og:site_name" content="<%= siteName%>"/>
        <meta property="og:url" content=<%= siteURL%>${requestScope['javax.servlet.forward.request_uri']} />
        
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
          <script src="<%= request.getContextPath()%>/static/js/html5shiv.js"></script>
          <script src="<%= request.getContextPath()%>/static/js/respond.min.js"></script>
        <![endif]-->
    </head>

    <%-- HACK: leftmargin, topmargin: for non-CSS compliant Microsoft IE browser --%>
    <%-- HACK: marginwidth, marginheight: for non-CSS compliant Netscape browser --%>
    <div id="uspLogo">
        <img onclick="javascript:window.open('http://www.usp.br');" alt="USP" style="cursor:pointer;" src="http://www.producao.usp.br/a/barrausp/images/left_Logo_usp.jpg" />
        <img onclick="javascript:window.open('http://www.usp.br');" alt="USP" style="cursor:pointer;" src="http://www.producao.usp.br/a/barrausp/images/middle_Logo_usp.gif" />
    </div>
    <script type="text/javascript" src="http://www.producao.usp.br/a/barrausp/js/barra2.js" charset="utf-8"></script>
    <body class="undernavigation">
        <a class="sr-only" href="#content">Skip navigation</a>
            <div class="container">
            <div class="row">
                <div class="col-md-8">
                    <div class="logo">
                        <br/>
                        <br/>
                        <br/>
                        <br/>
                        <br/>
                    </div>
                </div>
                <div class="col-md-4">
                    <address>
                        <strong>Departamento Técnico do Sistema Integrado de Bibliotecas da USP</strong><br>
                        Rua da Biblioteca, S/N - Complexo Brasiliana<br>
                        05508-050 - Cidade Universitária, São Paulo, SP - Brasil<br>
                        <abbr title="Phone">Tel:</abbr> (0xx11) 3091-1539 e 3091-1566<br>
                        <strong>E-mail:</strong> <a href="mailto:#">atendimento@sibi.usp.br</a>
                    </address>
                </div>
            </div>
            <header class="navbar navbar-inverse" role="navigation">
                <%
                    if (!navbar.equals("off")) {
                %>

                <dspace:include page="<%= navbar%>" />

                <%
                } else {
                %>

                <dspace:include page="/layout/navbar-minimal.jsp" />

                <%
                    }
                %>
            </header>
            
           
            <%-- Page contents --%>

            <% if (request.getAttribute("dspace.layout.sidebar") != null) { %>
            <div class="row">

                <% }%>