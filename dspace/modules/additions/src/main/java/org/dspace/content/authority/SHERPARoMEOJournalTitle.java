/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content.authority;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.commons.httpclient.NameValuePair;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.services.model.Request;
import org.dspace.utils.DSpace;

import org.apache.log4j.Logger;

/**
 * Sample Journal-name authority based on SHERPA/RoMEO
 *
 * WARNING: This is a very crude and incomplete implementation, done mainly
 *  as a proof-of-concept.  Any site that actually wants to use it will
 *  probably have to refine it (and give patches back to dspace.org).
 *
 * @see SHERPARoMEOProtocol
 * @author Larry Stone
 * @version $Revision $
 */
public class SHERPARoMEOJournalTitle extends SHERPARoMEOProtocol
{

    private static final String sql_value = "select metadatavalue.text_value " +
        "from metadatavalue " +
        "inner join metadatafieldregistry mfr on (metadatavalue.metadata_field_id = mfr.metadata_field_id) " +
        "inner join metadataschemaregistry msr on (mfr.metadata_schema_id = msr.metadata_schema_id) " +
        "where msr.short_id || '_' || mfr.element || coalesce('_' || mfr.qualifier, '') = ? " +
        "and metadatavalue.authority = ? limit 1";

    private Context context = null ;
    private Request request = null;

    private static final String RESULT = "journal";
    private static final String LABEL = "jtitle";
    private static final String AUTHORITY = "issn";
    
    private static final Logger logger = Logger.getLogger(SHERPARoMEOJournalTitle.class);
    
    
    public SHERPARoMEOJournalTitle ()
    {
        super();
    }
            
    private Context getContext() throws SQLException {
        request = new DSpace().getRequestService().getCurrentRequest();
        context = (Context) request.getAttribute("dspace.context");
        if(context == null){
            request.setAttribute("dspace.context", new Context(Context.READ_ONLY));
            context = (Context) request.getAttribute("dspace.context");
        }
        return context;
    }

    @Override
    public String getLabel(String field, String key, String locale)
    {
        // [start] 2014.04.17 jan.lara@sibi.usp.br alterando para retornar nome
        // [old] return key;
        try {
            String value;
            PreparedStatement statement = getContext().getDBConnection().prepareStatement(sql_value);
            statement.setString(1,field);
            statement.setString(2,key);
	    ResultSet rs = statement.executeQuery();
            
            if(rs.next()) {
                value = rs.getString("text_value");
            }
	    else {
		value = key;
	    }
            rs.close();
            statement.close();
            
            return value;

        } catch(SQLException sqle) {
            sqle.printStackTrace(System.out);
            return key;
        }
        //[end]
    }
    
    @Override
    public Choices getMatches(String text, int collection, int start, int limit, String locale)
    {
        // punt if there is no query text
        if (text == null || text.trim().length() == 0)
        {
            return new Choices(true);
        }

        // query args to add to SHERPA/RoMEO request URL
        NameValuePair args[] = new NameValuePair[3];
        args[0] = new NameValuePair("jtitle", text);
        args[1] = new NameValuePair("qtype","contains"); // OR: starts, exact
        args[2] = new NameValuePair("ak",ConfigurationManager.getProperty("sherpa.romeo.apikey"));
        
        Choices result = query(RESULT, LABEL, AUTHORITY, args, start, limit);
        if (result == null)
        {
            result =  new Choices(true);
        }
        return result;
    }

    @Override
    public Choices getMatches(String field, String text, int collection, int start, int limit, String locale) {
        return getMatches(text, collection, start, limit, locale);
    }
}
