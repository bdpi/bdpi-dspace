<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Renders a whole HTML page for displaying item metadata.  Simply includes
  - the relevant item display component in a standard HTML page.
  -
  - Attributes:
  -    display.all - Boolean - if true, display full metadata record
  -    item        - the Item to display
  -    collections - Array of Collections this item appears in.  This must be
  -                  passed in for two reasons: 1) item.getCollections() could
  -                  fail, and we're already committed to JSP display, and
  -                  2) the item might be in the process of being submitted and
  -                  a mapping between the item and collection might not
  -                  appear yet.  If this is omitted, the item display won't
  -                  display any collections.
  -    admin_button - Boolean, show admin 'edit' button
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.handle.HandleManager" %>
<%@ page import="org.dspace.license.CreativeCommons" %>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page import="org.dspace.versioning.Version"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.VersionUtil"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="org.dspace.authorize.AuthorizeManager"%>
<%@page import="java.util.List"%>
<%@page import="org.dspace.core.Constants"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="org.dspace.versioning.VersionHistory"%>
<%@page import="org.elasticsearch.common.trove.strategy.HashingStrategy"%>
<%
    // Attributes
    Boolean displayAllBoolean = (Boolean) request.getAttribute("display.all");
    boolean displayAll = (displayAllBoolean != null && displayAllBoolean.booleanValue());
    Boolean suggest = (Boolean) request.getAttribute("suggest.enable");
    boolean suggestLink = (suggest == null ? false : suggest.booleanValue());
    Item item = (Item) request.getAttribute("item");
    Collection[] collections = (Collection[]) request.getAttribute("collections");
    Boolean admin_b = (Boolean) request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());

    // get the workspace id if one has been passed
    Integer workspace_id = (Integer) request.getAttribute("workspace_id");

    // get the handle if the item has one yet
    String handle = item.getHandle();

    // CC URL & RDF
    String cc_url = CreativeCommons.getLicenseURL(item);
    String cc_rdf = CreativeCommons.getLicenseRDF(item);

    // Full title needs to be put into a string to use as tag argument
    String title = "";
    if (handle == null) {
        title = "Workspace Item";
    } else {
        DCValue[] titleValue = item.getDC("title", null, Item.ANY);
        if (titleValue.length != 0) {
            title = titleValue[0].value;
        } else {
            title = "Item " + handle;
        }
    }

    Boolean versioningEnabledBool = (Boolean) request.getAttribute("versioning.enabled");
    boolean versioningEnabled = (versioningEnabledBool != null && versioningEnabledBool.booleanValue());
    Boolean hasVersionButtonBool = (Boolean) request.getAttribute("versioning.hasversionbutton");
    Boolean hasVersionHistoryBool = (Boolean) request.getAttribute("versioning.hasversionhistory");
    boolean hasVersionButton = (hasVersionButtonBool != null && hasVersionButtonBool.booleanValue());
    boolean hasVersionHistory = (hasVersionHistoryBool != null && hasVersionHistoryBool.booleanValue());

    Boolean newversionavailableBool = (Boolean) request.getAttribute("versioning.newversionavailable");
    boolean newVersionAvailable = (newversionavailableBool != null && newversionavailableBool.booleanValue());
    Boolean showVersionWorkflowAvailableBool = (Boolean) request.getAttribute("versioning.showversionwfavailable");
    boolean showVersionWorkflowAvailable = (showVersionWorkflowAvailableBool != null && showVersionWorkflowAvailableBool.booleanValue());

    String latestVersionHandle = (String) request.getAttribute("versioning.latestversionhandle");
    String latestVersionURL = (String) request.getAttribute("versioning.latestversionurl");

    VersionHistory history = (VersionHistory) request.getAttribute("versioning.history");
    List<Version> historyVersions = (List<Version>) request.getAttribute("versioning.historyversions");

    //Check DOI

    boolean checkdoi = false;
    DCValue[] doi = item.getDC("identifier", "doi", Item.ANY);
    if (doi.length != 0)
    {
        request.setAttribute("checkdoi", true);
        checkdoi = true;
    }
/*
    DCValue[] dcv = item.getMetadata("dc", "identifier", "doi", Item.ANY);
    String displayDOI = "";
    if (dcv != null & dcv.length > 0) {
        displayDOI = dcv[0].value;
    }
*/
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>

<dspace:layout title="<%= title%>">
    <%-- Location bar --%>
    <dspace:include page="/layout/location-bar.jsp" />
    <div class="row">
        <div class="col-md-8">

                <%
                    if (handle != null) {
                %>

                <%
                    if (newVersionAvailable) {
                %>
                <div class="alert alert-warning"><b><fmt:message key="jsp.version.notice.new_version_head"/></b>		
                    <fmt:message key="jsp.version.notice.new_version_help"/><a href="<%=latestVersionURL%>"><%= latestVersionHandle%></a>
                </div>
                <%
                    }
                %>

                <%
                    if (showVersionWorkflowAvailable) {
                %>
                <div class="alert alert-warning"><b><fmt:message key="jsp.version.notice.workflow_version_head"/></b>		
                        <fmt:message key="jsp.version.notice.workflow_version_help"/>
                </div>
                <%
                    }
                %>


                

                <%
                    }

                    String displayStyle = (displayAll ? "full" : "");
                %>
                

                <dspace:item-preview item="<%= item%>" />


                <dspace:item item="<%= item%>" collections="<%= collections%>" style="<%= displayStyle%>" />

                <%-- Versioning table --%>
                <%
                    if (versioningEnabled && hasVersionHistory) {
                        boolean item_history_view_admin = ConfigurationManager
                                .getBooleanProperty("versioning", "item.history.view.admin");
                        if (!item_history_view_admin || admin_button) {
                %>
                <div id="versionHistory" class="panel panel-info">
                    <div class="panel-heading"><fmt:message key="jsp.version.history.head2" /></div>

                    <table class="table panel-body">
                        <tr>
                            <th id="tt1" class="oddRowEvenCol"><fmt:message key="jsp.version.history.column1"/></th>
                            <th 			
                                id="tt2" class="oddRowOddCol"><fmt:message key="jsp.version.history.column2"/></th>
                            <th 
                                id="tt3" class="oddRowEvenCol"><fmt:message key="jsp.version.history.column3"/></th>
                            <th 

                                id="tt4" class="oddRowOddCol"><fmt:message key="jsp.version.history.column4"/></th>
                            <th 
                                id="tt5" class="oddRowEvenCol"><fmt:message key="jsp.version.history.column5"/> </th>
                        </tr>

                        <% for (Version versRow : historyVersions) {

                                EPerson versRowPerson = versRow.getEperson();
                                String[] identifierPath = VersionUtil.addItemIdentifier(item, versRow);
                        %>	
                        <tr>			
                            <td headers="tt1" class="oddRowEvenCol"><%= versRow.getVersionNumber()%></td>
                            <td headers="tt2" class="oddRowOddCol"><a href="<%= request.getContextPath() + identifierPath[0]%>"><%= identifierPath[1]%></a><%= item.getID() == versRow.getItemID() ? "<span class=\"glyphicon glyphicon-asterisk\"></span>" : ""%></td>
                            <td headers="tt3" class="oddRowEvenCol"><% if (admin_button) {%><a
                                    href="mailto:<%= versRowPerson.getEmail()%>"><%=versRowPerson.getFullName()%></a><% } else {%><%=versRowPerson.getFullName()%><% }%></td>
                            <td headers="tt4" class="oddRowOddCol"><%= versRow.getVersionDate()%></td>
                            <td headers="tt5" class="oddRowEvenCol"><%= versRow.getSummary()%></td>
                        </tr>
                        <% } %>
                    </table>
                    <div class="panel-footer"><fmt:message key="jsp.version.history.legend"/></div>
                </div>
                <%
                        }
                    }
                %>
                <br/>
                <%-- Create Commons Link --%>
                <%
                    if (cc_url != null) {
                %>
                <p class="submitFormHelp alert alert-info"><fmt:message key="jsp.display-item.text3"/> <a href="<%= cc_url%>"><fmt:message key="jsp.display-item.license"/></a>
                    <a href="<%= cc_url%>"><img src="<%= request.getContextPath()%>/image/cc-somerights.gif" border="0" alt="Creative Commons" style="margin-top: -5px;" class="pull-right"/></a>
                </p>
                <!--
                <%= cc_rdf%>
                -->
                <%
                } else {
                %>
                <p class="submitFormHelp alert alert-info"><fmt:message key="jsp.display-item.copyright"/></p>
                <%
                    }
                %>
            </div>

            <div class="col-md-4">
                
              
                                    <%
                if (admin_button) // admin edit button
                {%>

                    <div class="panel panel-warning">
                        <div class="panel-heading"><fmt:message key="jsp.admintools"/></div>
                        <div class="panel-body">
                            <form method="get" action="<%= request.getContextPath()%>/tools/edit-item">
                                <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                                <%--<input type="submit" name="submit" value="Edit...">--%>
                                <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.edit.button"/>" />
                            </form>
                            <form method="post" action="<%= request.getContextPath()%>/mydspace">
                                <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                                <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE%>" />
                                <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.item"/>" />
                            </form>
                            <form method="post" action="<%= request.getContextPath()%>/mydspace">
                                <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                                <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE%>" />
                                <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.migrateitem"/>" />
                            </form>
                            <form method="post" action="<%= request.getContextPath()%>/dspace-admin/metadataexport">
                                <input type="hidden" name="handle" value="<%= item.getHandle()%>" />
                                <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
                            </form>
                            <% if (hasVersionButton) {%>       
                            <form method="get" action="<%= request.getContextPath()%>/tools/version">
                                <input type="hidden" name="itemID" value="<%= item.getID()%>" />                    
                                <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.version.button"/>" />
                            </form>
                            <% } %> 
                            <% if (hasVersionHistory) {%>			                
                            <form method="get" action="<%= request.getContextPath()%>/tools/history">
                                <input type="hidden" name="itemID" value="<%= item.getID()%>" />
                                <input type="hidden" name="versionID" value="<%= history.getVersion(item) != null ? history.getVersion(item).getVersionId() : null%>" />                    
                                <input class="btn btn-info col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.version.history.button"/>" />
                            </form>         	         	
                            <% } %>
                        </div>
                    </div>

                <%      } %>
                <div class="panel panel-success">
                    <div class="panel-heading">Informações suplementares</div>
                    <div class="panel-body">
                        <dl>
                  <dt>Como citar</dt>      
                  <dd>
                <%-- <strong>Please use this identifier to cite or link to this item:--%>
                <div style="width: 95%; display: inline-block; word-wrap: break-word;"><fmt:message key="jsp.display-item.identifier"/> <%= HandleManager.getCanonicalForm(handle)%></div>                        
                    </dd>
                    <dt>Metadados do registro</dt>
                    <dd>
                    <%
                        String locationLink = request.getContextPath() + "/handle/" + handle;

                        if (displayAll) {
                    %>
                    <%
                        if (workspace_id != null) {
                    %>
                    <form class="col-md-2" method="post" action="<%= request.getContextPath()%>/view-workspaceitem">
                        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue()%>" />
                        <input class="btn btn-primary" type="submit" name="submit_simple" value="<fmt:message key="jsp.display-item.text1"/>" />
                    </form>
                    <%
                    } else {
                    %>
                    <a class="btn btn-primary" href="<%=locationLink%>?mode=simple">
                        <fmt:message key="jsp.display-item.text1"/>
                    </a>
                    <%
                        }
                    %>
                    <%
                    } else {
                    %>
                    <%
                        if (workspace_id != null) {
                    %>
                    <form class="col-md-2" method="post" action="<%= request.getContextPath()%>/view-workspaceitem">
                        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue()%>" />
                        <input class="btn btn-primary" type="submit" name="submit_full" value="<fmt:message key="jsp.display-item.text2"/>" />
                    </form>
                    <%
                    } else {
                    %>
                    <a class="btn btn-primary" href="<%=locationLink%>?mode=full">
                        <fmt:message key="jsp.display-item.text2"/>
                    </a>
                    <%
                            }
                        }

                        if (workspace_id != null) {
                    %>
                    <form class="col-md-2" method="post" action="<%= request.getContextPath()%>/workspace">
                        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue()%>"/>
                        <input class="btn btn-primary" type="submit" name="submit_open" value="<fmt:message key="jsp.display-item.back_to_workspace"/>"/>
                    </form>
                    <%
                    } else {

                        if (suggestLink) {
                    %>
                    <a class="btn btn-success" href="<%= request.getContextPath()%>/suggest?handle=<%= handle%>" target="new_window">
                        <fmt:message key="jsp.display-item.suggest"/></a>
                        <%
                            }
                        %>
                                        </dd>
                    <dt>Estatísticas de acesso ao registro</dt>
                                        <dd>
                        <a class="statisticsLink  btn btn-primary" href="<%= request.getContextPath()%>/handle/<%= handle%>/statistics"><fmt:message key="jsp.display-item.display-statistics"/></a>
                    </dd>
                    <dt>Buscar este registro em outras fontes pelo SFX</dt>
                    <dd>
                    <%-- SFX Link --%>
                    <%
                        if (ConfigurationManager.getProperty("sfx.server.url") != null) {
                            String sfximage = ConfigurationManager.getProperty("sfx.server.image_url");
                            if (sfximage == null) {
                                sfximage = request.getContextPath() + "/image/sfx-link.gif";
                            }
                    %>
                    <a class="btn" href="<dspace:sfxlink item="<%= item%>"/>" /><img src="<%= sfximage%>" border="0" alt="SFX Query" /></a>
                    <%
                            }
                        }
                    %>
                    </dd>    
                     </dl>   
                    </div>
                    <%
                    if (checkdoi) {
                     %>
                    <div class="panel-heading">Métricas alternativas e redes sociais</div>
                    <div class="panel-body">
                        <!--Altmetric.com-->
                        <script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>
                        <div data-badge-details="right" data-badge-type="1" data-doi="<%=doi[0].value%>" data-hide-no-mentions="true" class="altmetric-embed"></div>
                       
                    </div>
                        <div class="panel-body">
                            <!--PlumX-->
                        <script type="text/javascript" src="//d1x9wcvwqf6hm1.cloudfront.net/w/js/0.1.19/widgets.js"></script>
                        <div class="plumx-widget" plumx-widget-type="plumx-artifact-metrics" doi="<%=doi[0].value%>" hide-when-empty="true"></div>
                        </div>
                        <!--
                       <div class="panel-body">
                           <!--Add This
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
                       </div> -->
                        <div class="panel-heading">Citações</div>
                        <div class="panel-body">
                        <p>Procurar citações no <a href="http://scholar.google.com/scholar?q=<%=doi[0].value%>" target="_blank">Google Scholar</a></p>
                        </div>
                        <div class="panel-body text-center">
                            <script type="text/javascript" src="http://api.elsevier.com/javascript/citedby_image.jsp"></script>

                        <script type="text/javascript">
                            $(document).ready(function getScopusCitation(){
                               var varSearchObj = new searchObj();
                               varSearchObj.setDoi("<%=doi[0].value%>");
                               sciverse.setApiKey("35ff0b478b7d592f81e5b0521dc1f072");
                               sciverse.search(varSearchObj);
                            });
                            <!-- SECTION 2 : Call back -->
                               callback = function(){ document.sciverseForm.searchButton.disabled = true; }
                            <!-- SECTION 3 : Running Search -->
                               runSearch = function(){
                               document.sciverseForm.searchButton.disabled = true;
                               var varSearchObj = new searchObj();
                               varSearchObj.setEid(document.sciverseForm.eid.value);
                               varSearchObj.setDoi(document.sciverseForm.doi.value);
                               varSearchObj.setScp(document.sciverseForm.scp.value);
                               varSearchObj.setPii(document.sciverseForm.pii.value);
                               varSearchObj.setIssn(document.sciverseForm.issn.value);
                               varSearchObj.setIsbn(document.sciverseForm.isbn.value);
                               varSearchObj.setVol(document.sciverseForm.vol.value);
                               varSearchObj.setIssue(document.sciverseForm.issue.value);
                               varSearchObj.setTitle(document.sciverseForm.title.value);
                               varSearchObj.setFirstPg(document.sciverseForm.firstpg.value);
                               varSearchObj.setArtNo(document.sciverseForm.artno.value);
                               sciverse.setApiKey("35ff0b478b7d592f81e5b0521dc1f072");
                               sciverse.search(varSearchObj);
                               }
                        </script>
                <!-- SECTION 4 : Setting defaults -->
                        <script type="text/javascript"> </script>
       
                    <div id="citedBy"></div>
                            
                        </div>    
                 <%
                    }
                %>     
                </div>
            </div>
      

            </div>
            <script>$(".authority.author").after(" <img src=\"\/image/ehUSP.png\">");</script>

        </dspace:layout>
