<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  - User profile editing form.
  -
  - This isn't a full page, just the fields for entering a user's profile.
  -
  - Attributes to pass in:
  -   eperson       - the EPerson to edit the profile for.  Can be null,
  -                   in which case blank fields are displayed.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.Locale"%>

<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.Utils" %>

<c:set var="provider_profile_url" ><%=((String) ConfigurationManager.getProperty("authentication-oauth", "provider.profile.url"))%></c:set>

<!--<fmt:message key="xmlui.EPerson.OAuthEditProfile.textlinktoprovider"/>-->

<%
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    EPerson epersonForm = (EPerson) request.getAttribute("eperson");

    String lastName = "";
    String firstName = "";
    String phone = "";
    String language = "";

    if (epersonForm != null)
    {
        // Get non-null values
        lastName = epersonForm.getLastName();
        if (lastName == null) lastName = "";

        firstName = epersonForm.getFirstName();
        if (firstName == null) firstName = "";

        phone = epersonForm.getMetadata("phone");
        if (phone == null) phone = "";

        language = epersonForm.getMetadata("language");
        if (language == null) language = "";
    }
%>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tfullname"><fmt:message key="jsp.register.profile-form.name.field"/></label>
                <div class="col-md-4"><div class="form-control" name="fullname" id="tfullname" ><%= Utils.addEntities(firstName) %> <%= Utils.addEntities(lastName) %></div></div>
	</div>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tphone"><fmt:message key="jsp.register.profile-form.phone.field"/></label>
                <div class="col-md-4"><div class="form-control" name="phone" id="tphone" ><%= Utils.addEntities(phone) %></div></div>
        </div>
	<div class="form-group">
            <label class="col-md-offset-4 col-md-3"><a href="${provider_profile_url}" target="_blank" ><fmt:message key="usp.profile.textlinktoprovider"/></a></label>
        </div>
<% if(false){ %>
    <div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tlanguage"><strong><fmt:message key="jsp.register.profile-form.language.field"/></strong></label>
 		<div class="col-md-3">
        <select class="form-control" name="language" id="tlanguage">
<%
        for (int i = supportedLocales.length-1; i >= 0; i--)
        {
        	String lang = supportedLocales[i].toString();
        	String selected = "";
        	
        	if (language.equals(""))
        	{ if(lang.equals(I18nUtil.getSupportedLocale(request.getLocale()).getLanguage()))
        		{
        			selected = "selected=\"selected\"";
        		}
        	}
        	else if (lang.equals(language))
        	{ selected = "selected=\"selected\"";}
%>
           <option <%= selected %>
                value="<%= lang %>"><%= supportedLocales[i].getDisplayName(UIUtil.getSessionLocale(request)) %></option>
<%
        }
%>
        </select>
        </div>
     </div>
<% } %>
