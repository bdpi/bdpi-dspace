package org.dspace.authenticate;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.sql.SQLException;
import java.util.logging.Level;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import static org.dspace.authenticate.AuthenticationMethod.NO_SUCH_USER;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;

import net.spy.memcached.MemcachedClient;

import org.scribe.builder.ServiceBuilder;
import org.scribe.builder.api.USPdigitalApi;
import org.scribe.oauth.OAuthService;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.model.Verifier;
import org.scribe.model.Response;

import org.json.JSONObject;
import org.json.JSONException;

/**
 *
 * @author Jan Leduc de Lara
 * @version $Revision$
 */
public class OAuthAuthentication
        implements AuthenticationMethod {

    private static final Logger log = Logger.getLogger(OAuthAuthentication.class);
    private static final int MEMCACHED_TIMEOUT = 120;
    private static final String MEMCACHED_IP = "127.0.0.1";
    private static final int MEMCACHED_TCP = 11211;
    private static final String PROTECTED_RESOURCE_URL = ConfigurationManager.getProperty("authentication-oauth", "PROTECTED_RESOURCE_URL");
    private static final String API_KEY = ConfigurationManager.getProperty("authentication-oauth", "API_KEY");
    private static final String API_SECRET = ConfigurationManager.getProperty("authentication-oauth", "API_SECRET");
    private static final OAuthService oauthservice = new ServiceBuilder()
                .apiKey(API_KEY)
                .apiSecret(API_SECRET)
                .provider(USPdigitalApi.class)
                .build();
    
    private static MemcachedClient cache = null;
    
    private int httpRequestHashCode = 0;
    private String strLoginPageURL = "";
    
    private static MemcachedClient getCache(){
        try {
            if(cache == null) cache = new MemcachedClient(new InetSocketAddress(MEMCACHED_IP, MEMCACHED_TCP));
            return cache;
        }
        catch(IOException e){
            log.debug(e);
            return null;
        }
    }
    
    @Override
    public boolean canSelfRegister(Context context,
            HttpServletRequest request,
            String username)
            throws SQLException {
        return true;
    }

    @Override
    public void initEPerson(Context context, HttpServletRequest request,
            EPerson eperson)
            throws SQLException {
        
        try {
        
            JSONObject jso = (JSONObject) request.getAttribute("jso");

            context.turnOffAuthorisationSystem();
            eperson.setEmail(jso.getString("emailPrincipalUsuario"));
            eperson.setNetid(jso.getString("loginUsuario"));
            String[] name = (jso.getString("nomeUsuario")).trim().split("\\s+");
            StringBuilder firstname = new StringBuilder();
            StringBuilder lastname = new StringBuilder();
            for(int stri=0; stri<name.length ; stri++){
                if(stri==0) firstname.append(name[stri]);
                else {
                    if(lastname.length()==0) lastname.append(name[stri]);
                    else lastname.append(" ").append(name[stri]);
                }
            }
            eperson.setFirstName(firstname.toString());
            eperson.setLastName(lastname.toString());
            eperson.setCanLogIn(true);
            eperson.setLanguage("pt_BR");
            eperson.setSelfRegistered(true);
            eperson.setMetadata("phone", jso.getString("numeroTelefoneFormatado"));
            eperson.setMetadata("uspdigital_email_alternativo", jso.getString("emailAlternativoUsuario"));
            eperson.setMetadata("uspdigital_email_usp", jso.getString("emailUspUsuario"));
            eperson.setMetadata("uspdigital_usuario_tipo", jso.getString("tipoUsuario"));
        
            eperson.update();
        } catch (AuthorizeException ex) {
            java.util.logging.Logger.getLogger(OAuthAuthentication.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JSONException e) {
            log.trace(e);
        }
        
        context.restoreAuthSystemState();
        context.commit();
    }
    
    @Override
    public boolean allowSetPassword(Context context,
            HttpServletRequest request,
            String username)
            throws SQLException {
        return false;
    }

    @Override
    public boolean isImplicit() {
        return false;
    }

    @Override
    public int authenticate(Context context,
            String oauth_token,
            String oauth_verifier,
            String realm,
            HttpServletRequest request)
            throws SQLException {

        Token accessToken = oauthservice.getAccessToken(
                            new Token(oauth_token,(String) getCache().get(oauth_token)),
                            new Verifier(oauth_verifier));

        OAuthRequest orequest = new OAuthRequest(Verb.POST, PROTECTED_RESOURCE_URL);

        oauthservice.signRequest(accessToken, orequest);
        Response oresponse = orequest.send();
        
        EPerson eperson;

        try {

            JSONObject jso = new JSONObject(oresponse.getBody());

            // System.out.println("[AQUIAGORA] #########retornou######");
            // System.out.println("[AQUIAGORA] " + oresponse.getBody());
            // System.out.println("[AQUIAGORA] #########retornou######");

            if (jso.getString("loginUsuario").length() > 0) {
                
                request.setAttribute("jso", jso);

                eperson = EPerson.findByNetid(context, jso.getString("loginUsuario"));
                if(eperson == null){
                    eperson = EPerson.findByEmail(context, jso.getString("emailPrincipalUsuario"));
                }
                if(eperson == null){
                    eperson = EPerson.findByEmail(context, jso.getString("emailAlternativoUsuario"));
                }
                if(eperson == null){
                    eperson = EPerson.findByEmail(context, jso.getString("emailUspUsuario"));
                }
                if (eperson == null) {
                    try {
                        context.turnOffAuthorisationSystem();
                        eperson = EPerson.create(context); //cria novo usuário no banco
                        initEPerson(context, request, eperson);
                        context.setCurrentUser(eperson);
                        context.restoreAuthSystemState();
                        request.removeAttribute("jso");
                        return SUCCESS;
                    } catch (AuthorizeException ex) {
                        java.util.logging.Logger.getLogger(OAuthAuthentication.class.getName()).log(Level.SEVERE, null, ex);
                        request.removeAttribute("jso");
                        return BAD_ARGS;
                    }
                } else {
                    context.turnOffAuthorisationSystem();
                    initEPerson(context, request, eperson); //atualiza e mantém atualizados os dados do usuário
                    context.setCurrentUser(eperson);
                    context.restoreAuthSystemState();
                    request.removeAttribute("jso");
                    return SUCCESS;
                }
            } else {
                return NO_SUCH_USER;
            }

        } catch (JSONException e) {

            log.trace("Failed to authorize looking up EPerson", e);

            return NO_SUCH_USER;

        } catch(SQLException sqle){
            log.trace("Failed to authorize looking up EPerson", sqle);

            return NO_SUCH_USER;
            
        } catch (AuthorizeException ex) {
            java.util.logging.Logger.getLogger(OAuthAuthentication.class.getName()).log(Level.SEVERE, null, ex);
            return NO_SUCH_USER;
        }

    }

    @Override
    public String loginPageURL(Context context,
            HttpServletRequest request,
            HttpServletResponse response) {

        if (httpRequestHashCode != request.hashCode()) {
            
            // devido a algum bug do dspace, o metodo loginPageURL
            // e chamado 3 vezes a cada vez que essa pagina
            // e carregada. O uso do httpRequestHashCode evita
            // que o token seja gerado 3 vezes a cada chamada.
            
            httpRequestHashCode = request.hashCode();

            Token requesttoken = oauthservice.getRequestToken();
            getCache().set(requesttoken.getToken(), MEMCACHED_TIMEOUT, requesttoken.getSecret());
            strLoginPageURL = response.encodeRedirectURL(oauthservice.getAuthorizationUrl(requesttoken));
        }
        return strLoginPageURL;
    }

    @Override
    public String loginPageTitle(Context context) {        
        return "org.dspace.eperson.OAuthAuthentication.title";
    }

    @Override
    public int[] getSpecialGroups(Context context, HttpServletRequest request) {
        try {
            if (!context.getCurrentUser().getNetid().equals("")) {
                String groupName = ConfigurationManager.getProperty("authentication-oauth", "login.specialgroup");
                if ((groupName != null) && (!groupName.trim().equals(""))) {
                    Group oauthGroup = Group.findByName(context, groupName);
                    if (oauthGroup == null) {
                        // Oops - the group isn't there.
                        /*
                         log.warn(LogManager.getHeader(context,
                         "oauth_specialgroup",
                         "Group defined in login.specialgroup does not exist"));
                         */
                        return new int[0];
                    } else {
                        return new int[]{oauthGroup.getID()};
                    }
                }
            }
        } catch (Exception npe) {
        }
        return new int[0];

    }
}

