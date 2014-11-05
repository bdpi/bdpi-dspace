/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import org.dspace.app.webui.util.Authenticate;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.authenticate.AuthenticationManager;
import org.dspace.authenticate.AuthenticationMethod;
import org.dspace.authenticate.OAuthAuthentication;
import org.dspace.core.PluginManager;

/**
 * @author  Jan LL - jan.lara at sibi.usp.br 2014
 * @version $Revision$
 */
public class OAuthServlet extends DSpaceServlet {
    /** log4j logger */
    private static Logger log = Logger.getLogger(OAuthServlet.class);
    
    protected void doDSGet(Context context,
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException, SQLException, AuthorizeException {
        //debugging, show all headers
        java.util.Enumeration names = request.getHeaderNames();
        String name;
        while(names.hasMoreElements())
        {
            name = names.nextElement().toString();
            log.info("header:" + name + "=" + request.getHeader(name));
        }
        
        String jsp = null;
        
        // Locate the eperson
        
        String oauth_token = request.getParameter("oauth_token");
        String oauth_verifier = request.getParameter("oauth_verifier");
        
        if ((oauth_token == null) || (oauth_verifier == null))
        {
            Object[] plugins = PluginManager.getPluginSequence("authentication", AuthenticationMethod.class);
            for (Object plugin : plugins) {
                if (plugin instanceof OAuthAuthentication) {
                    response.sendRedirect(((OAuthAuthentication) plugin).loginPageURL(UIUtil.obtainContext(request), request, response));
                    return;
                }
            }
        }
        
        if(!request.getContextPath().equals(OAuthAuthentication.getOAuthContextPath(request))){
            response.sendRedirect(OAuthAuthentication.getOAuthRedirection(request));
            return;
        }
        
        int status = AuthenticationManager.authenticate(context, oauth_token, oauth_verifier, null, request);
        
        if (status == AuthenticationMethod.SUCCESS){
            // Logged in OK.
            Authenticate.loggedIn(context, request, context.getCurrentUser());
            
            log.info(LogManager.getHeader(context, "login", "type=oauth"));
            
            // resume previous request
            Authenticate.resumeInterruptedRequest(request, response);
            
            return;
        }else if(status == AuthenticationMethod.NO_SUCH_USER){
            jsp = request.getContextPath() + "/login/no-single-sign-out.jsp";
        }else if(status == AuthenticationMethod.BAD_ARGS){
            jsp = request.getContextPath() + "/login/no-email.jsp";
        }
        
        // If we reach here, supplied email/password was duff.
        log.info(LogManager.getHeader(context, "failed_login","result="+String.valueOf(status)));
        JSPManager.showJSP(request, response, jsp);
        
    }
}

