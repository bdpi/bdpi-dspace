/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.eperson;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.acting.AbstractAction;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.environment.http.HttpEnvironment;
import org.dspace.app.xmlui.utils.AuthenticationUtil;
import org.dspace.app.xmlui.utils.ContextUtil;
import org.dspace.authenticate.AuthenticationMethod;
import org.dspace.authenticate.OAuthAuthentication;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.PluginManager;

/**
 * Attempt to authenticate the user based upon their presented OAuth credentials. 

 * If the authentication attempt is successful then an HTTP redirect will be
 * sent to the browser redirecting them to their original location in the 
 * system before authenticated or if none is supplied back to the DSpace 
 * homepage. The action will also return true, thus contents of the action will
 * be executed.
 * 
 * If the authentication attempt fails, the action returns false.
 * 
 * Example use:
 * 
 * <map:act name="OAuthAction">
 *   <map:serialize type="xml"/>
 * </map:act>
 * <map:transform type="try-to-login-again-transformer">
 *
 * @author <a href="mailto:janleduc@usp.br">Leduc de Lara, Jan</a>
 */

public class OAuthAction extends AbstractAction
{

    /**
     * Attempt to authenticate the user. 
     */
	public Map act(Redirector redirector, SourceResolver resolver, Map objectModel,
            String source, Parameters parameters) throws Exception
    {

        Request request = ObjectModelHelper.getRequest(objectModel);
        final HttpServletResponse httpResponse = (HttpServletResponse) objectModel.get(HttpEnvironment.HTTP_RESPONSE_OBJECT);

        String oauth_token = request.getParameter("oauth_token");
        String oauth_verifier = request.getParameter("oauth_verifier");

        // Protect against NPE errors inside the authentication
        // class.
        if ((oauth_token == null) || (oauth_verifier == null))
        {
            Object[] plugins = PluginManager.getPluginSequence("authentication", AuthenticationMethod.class);
            for (Object plugin : plugins) {
                if (plugin instanceof OAuthAuthentication) {
                    httpResponse.sendRedirect(((OAuthAuthentication) plugin).loginPageURL(ContextUtil.obtainContext(objectModel), request, httpResponse));
                    return new HashMap();
                }
            }
            return null;
        }
        
        if(!request.getContextPath().equals(OAuthAuthentication.getOAuthContextPath(request))){
            httpResponse.sendRedirect(OAuthAuthentication.getOAuthRedirection(request));
            return new HashMap();
        }
        
        Context context = AuthenticationUtil.authenticate(objectModel, oauth_token, oauth_verifier, null); // authenticate ja loga o usuario

        // The user has successfully logged in
        String redirectURL = request.getContextPath();
        if (AuthenticationUtil.isInterupptedRequest(objectModel))
        {
                // Resume the request and set the redirect target URL to
                // that of the originally interrupted request.
                redirectURL += AuthenticationUtil.resumeInterruptedRequest(objectModel);
        }
        else
        {
                // Otherwise direct the user to the specified 'loginredirect' page (or homepage by default)
                String loginRedirect = ConfigurationManager.getProperty("xmlui.user.loginredirect");
                redirectURL += (loginRedirect != null) ? loginRedirect.trim() : "/";	
        }
        // Authentication successful send a redirect.

        httpResponse.sendRedirect(redirectURL);

        // log the user out for the rest of this current request, however they will be reauthenticated
        // fully when they come back from the redirect. This prevents caching problems where part of the
        // request is performed before the user was authenticated and the other half after it succeeded. This
        // way the user is fully authenticated from the start of the request.
        context.setCurrentUser(null);
        return new HashMap();

    }

}
