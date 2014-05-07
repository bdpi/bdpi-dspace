<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
--%>

<%@page import="org.dspace.content.Bitstream"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>

<%
    Community[] communities = (Community[]) request.getAttribute("communities");

    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);

    String[] displayAuthors;

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled) {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }

    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");
%>
<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData%>">
    <div class="row">
        <div class="col-md-8">
            <div class="jumbotron">
                <div class="box">
                    <h3 class="chamada">Conheça a BDPI</h3>
                    <p class="espaco">A Biblioteca Digital da Produção Intelectual da Universidade de São Paulo (BDPI) é um sistema de gestão e disseminação da produção científica, acadêmica, técnica e artística gerada pelas pesquisas desenvolvidas na USP.</p>
                </div>

            </div>
            <%
                if (submissions != null && submissions.count() > 0) {
            %>
            <div class="panel">
                <div class="panel-heading">
                    <h3><fmt:message key="jsp.collection-home.recentsub"/>
                        <%
                            if (feedEnabled) {
                                String[] fmts = feedData.substring(feedData.indexOf(':') + 1).split(",");
                                String icon = null;
                                int width = 0;
                                for (int j = 0; j < fmts.length; j++) {
                                    if ("rss_1.0".equals(fmts[j])) {
                                        icon = "rss1.gif";
                                        width = 80;
                                    } else if ("rss_2.0".equals(fmts[j])) {
                                        icon = "rss2.gif";
                                        width = 80;
                                    } else {
                                        icon = "rss.gif";
                                        width = 36;
                                    }
                        %>
                        <a href="<%= request.getContextPath()%>/feed/<%= fmts[j]%>/site"><img src="<%= request.getContextPath()%>/image/<%= icon%>" alt="RSS Feed" width="<%= width%>" height="15" vspace="3" border="0" /></a>
                            <%
                                    }
                                }
                            %>
                    </h3>
                </div>

                <%
                    boolean first = true;
                    for (Item item : submissions.getRecentSubmissions()) {
                        DCValue[] dcv = item.getMetadata("dc", "title", null, Item.ANY);
                        String displayTitle = "Untitled";
                        if (dcv != null & dcv.length > 0) {
                            displayTitle = dcv[0].value;
                        }
                        dcv = item.getMetadata("dc", "contributor", "author", Item.ANY);
                        if (dcv != null & dcv.length > 0) {
                            displayAuthors = new String[dcv.length];
                            for (int dcvcounter = 0; dcvcounter < dcv.length; dcvcounter++) {
                                displayAuthors[dcvcounter] = dcv[dcvcounter].value;
                            }
                        } else {
                            displayAuthors = new String[1];
                            displayAuthors[0] = "";
                        }
                        dcv = item.getMetadata("dc", "description", "abstract", Item.ANY);
                        String displayAbstract = "";
                        if (dcv != null & dcv.length > 0) {
                            displayAbstract = dcv[0].value;
                        }
                        dcv = item.getMetadata("dc", "rights", null, Item.ANY);
                        String displayRights = "";
                        if (dcv != null & dcv.length > 0) {
                            displayRights = dcv[0].value;
                        }
                %>
                <div class="media padding15">
                    <a class="pull-left" href="#">
                        <% if (displayRights.equals("openAccess")) {%>
                        <img class="pull-left" src="image/32px-Open_Access_logo_PLoS_white.svg.png" height="32px">
                        <% } else { %>
                        <img class="pull-left" src="image/32px-Closed_Access_logo_white.svg.png" height="32px">
                        <% }%>
                    </a>
                    <div class="media-body col-md-11">
                        <a href="<%= request.getContextPath()%>/handle/<%=item.getHandle()%>"><h4 class="media-heading"><%=StringUtils.abbreviate(displayTitle, 400)%>﻿</h4></a>
                        <p><%
                            int maxcount;
                            String etal = "";
                            if (displayAuthors.length > 10) {
                                maxcount = 10;
                                etal = " et al";
                            } else {
                                maxcount = displayAuthors.length;
                        }
                        for (int acount = 0; acount < maxcount; acount++) { %>
                            <% if (acount > 0) { %>; <% }%><%=StringUtils.abbreviate(displayAuthors[acount], 1000)%>
                            <% }%><%=etal%></p>
                        <p><%= StringUtils.abbreviate(displayAbstract, 500)%></p>
                    </div>
                </div>
                <%
                        first = false;
                    }
                %>
            </div>
            <%
                }
            %>
        </div>
        <div class="col-md-4">
            <div class="panel text-justify">
                <div class="panel-heading">
                    <h3>Unidades USP</h3>
                </div>
                <div class="row tooltip-demo">
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/1315"><img class="img-responsive" data-src="holder.js/100%x60" title="Centro de Biologia Marinha - CEBIMar"></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/1"><img class="img-responsive" src="image/logosusp/cena.jpg" title="Centro de Energia Nuclear na Agricultura - CENA"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/1365"><img class="img-responsive" src="image/logosusp/each.jpg" title="Escola de Artes, Ciências e Humanidades - EACH"></a></div>
                    <div class="col-md-3" style="height: 60px; margin-bottom: 5px;"><a href="handle/BDPI/22"><br/><img class="img-responsive" src="image/logosusp/eca.jpg" title="Escola de Comunicações e Artes - ECA"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/1360"><img class="img-responsive" src="image/logosusp/eeferp.jpg" title="Escola de Educação Física e Esporte de Ribeirão Preto - EEFERP"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/94"><img class="img-responsive" src="image/logosusp/eefe.jpg" title="Escola de Educação Física e Esporte - EEFE"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/115"><img class="img-responsive" src="image/logosusp/eerp.jpg" title="Escola de Enfermagem de Ribeirão Preto - EERP"></a></div>
                    <div class="col-md-3" style="height: 60px; margin-bottom: 5px;"><a href="handle/BDPI/68"><img class="img-responsive" src="image/logosusp/ee.jpg" title="Escola de Enfermagem - EE"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/136"><img class="img-responsive" src="image/logosusp/eel.jpg" title="Escola de Engenharia de Lorena - EEL"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/162"><img class="img-responsive" src="image/logosusp/eesc.jpg" title="Escola de Engenharia de São Carlos - EESC"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/213"><img class="img-responsive" src="image/logosusp/ep.jpg" title="Escola Politécnica - EP"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/294"><img class="img-responsive" src="image/logosusp/esalq.jpg" title="Escola Superior de Agricultura Luiz de Queiroz - ESALQ"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/360"><img class="img-responsive" src="image/logosusp/fau.jpg" title="Faculdade de Arquitetura e Urbanismo - FAU"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/407"><img class="img-responsive" src="image/logosusp/fcfrp.jpg" title="Faculdade de Ciências Farmacêuticas de Ribeirão Preto - FCFRP"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/381"><img class="img-responsive" src="image/logosusp/fcf.jpg" title="Faculdade de Ciências Farmacêuticas - FCF"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/479"><img class="img-responsive" src="image/logosusp/fdrp.jpg" title="Faculdade de Direito de Ribeirão Preto - FDRP"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" src="image/logosusp/fd.jpg" title="Faculdade de Direito - FD"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/542"><img class="img-responsive" src="image/logosusp/fearp.jpg" title="Faculdade de Economia, Administração e Contabilidade de Ribeirão Preto - FEARP"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/521"><img class="img-responsive" src="image/logosusp/fea.jpg" title="Faculdade de Economia, Administração e Contabilidade - FEA"></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/500"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>         
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div>
                    <div class="col-md-3" style="margin-bottom: 5px;"><a href="handle/BDPI/428"><img class="img-responsive" data-src="holder.js/100%x60" alt="..."></a></div> 
                </div>
            </div>
            <div class="panel text-justify">
                <div class="panel-heading">
                    <h3>Últimas notícias</h3>
                </div>
                <div class="media padding15">
                    <a class="pull-left" href="#">
                        <span class="glyphicon glyphicon-list-alt icon"></span>
                    </a>
                    <div class="media-body">
                        <h4 class="media-heading">Media heading</h4>
                        Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
                    </div>
                </div>
                <div class="media padding15">
                    <a class="pull-left" href="#">
                        <span class="glyphicon glyphicon-list-alt icon"></span>
                    </a>
                    <div class="media-body">
                        <h4 class="media-heading">Media heading</h4>
                        Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
                    </div>
                </div>
                <div class="media padding15">
                    <a class="pull-left" href="#">
                        <span class="glyphicon glyphicon-list-alt icon"></span>
                    </a>
                    <div class="media-body">
                        <h4 class="media-heading">Media heading</h4>
                        Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
                    </div>
                </div>
            </div>
            <div class="panel">
                <div class="panel-body pull-center">
                    <div class="addthis_toolbox addthis_default_style addthis_32x32_style" style="width:350px;height:70px">
                        <a class="addthis_button_facebook_like" fb:like:layout="box_count" fb:like:action="recommend"></a>
                        <a class="addthis_button_tweet" tw:count="vertical"></a>
                        <a class="addthis_button_google_plusone" g:plusone:size="tall"></a>
                        <a class="addthis_button_linkedin_counter" li:counter="top"></a>
                        <a class="addthis_button_compact"></a>
                    </div>
                    <script async="async" defer="true" type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-4f9b00617c1df207" >
                        & #160;
                    </script>
                </div>
            </div>
        </div>
    </div>
    <div class="row text-center">
        <div class="col-lg-4">
            <span class="glyphicon glyphicon-floppy-open iconbg"></span>
            <h3>Como depositar</h3>
            <p>Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod. Nullam id dolor id nibh ultricies vehicula ut id elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna.</p>
            <p><a class="btn btn-primary pull-right" href="#" role="button">Saiba mais »</a></p>
            </br></br>
        </div>
        <!-- /.col-lg-4 -->
        <div class="col-lg-4">
            <span class="glyphicon glyphicon-comment iconbg"></span>
            <h3>Como citar</h3>
            <p>Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh.</p>
            <p><a class="btn btn-primary pull-right" href="#" role="button">Saiba mais »</a>
            </p>
            </br></br>
        </div>
        <!-- /.col-lg-4 -->
        <div class="col-lg-4">
            <span class="glyphicon glyphicon-pencil iconbg"></span>
            <h3>BDPI em números</h3>
            <dl class="dl-horizontal">
                <dt>Unidades</dt>
                <dd>42</dd>
                <dt>Departamentos</dt>
                <dd>127</dd>
                <dt>Registros</dt>
                <dd>38000</dd>
                <dt>Texto completo</dt>
                <dd>38000</dd>
            </dl>
        </div>
    </div>

</dspace:layout>
