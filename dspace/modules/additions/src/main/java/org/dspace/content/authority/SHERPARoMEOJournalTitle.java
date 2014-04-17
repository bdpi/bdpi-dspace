/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content.authority;

import org.apache.commons.httpclient.NameValuePair;
import org.dspace.core.ConfigurationManager;

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
    private static final String RESULT = "journal";
    private static final String LABEL = "jtitle";
    private static final String AUTHORITY = "issn";

    public SHERPARoMEOJournalTitle()
    {
        super();
    }

    @Override
    public String getLabel(String field, String key, String locale)
    {
        // [start] 2014.04.17 jan.lara@sibi.usp.br alterando para retornar nome
        // return key;
        return field;
        // [end]
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
