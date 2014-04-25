/**
 * 170913 - Dan Shinkai
 * Classe desenvolvida baseada na classe SHERPARMEOJournal para carregar dados a partir do Tematres.
 */
package org.dspace.content.authority;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.commons.httpclient.NameValuePair;
import org.dspace.core.Context;
import org.dspace.services.model.Request;
import org.dspace.utils.DSpace;

/**
 *  As informacoes nos quais serao recuperadas do Tematres deverao ser especificadas nas variaveis RESULT, LABEL e AUTHORITY.
 *  O RESULT determina a tag contendo todas as informacoes de uma determinada busca. 
 *  O LABEL e a tag no qual estara a informacoes a ser apresentada na pagina.
 *  O AUTHORITY esta relacionado com o authority propriamente dito.
 */
public class TematresSponsorship extends TematresProtocol
{
    private static final String sql_value = "select metadatavalue.text_value " +
        "from metadatavalue " +
        "inner join metadatafieldregistry mfr on (metadatavalue.metadata_field_id = mfr.metadata_field_id) " +
        "inner join metadataschemaregistry msr on (mfr.metadata_schema_id = msr.metadata_schema_id) " +
        "where msr.short_id || '_' || mfr.element || coalesce('_' || mfr.qualifier, '') = ? " +
        "and metadatavalue.authority = ? limit 1";
    
    private Context context = null ;
    private Request request = null;
    
    private static final String RESULT = "term";
    private static final String LABEL = "string";
    private static final String AUTHORITY = "term_id";


    public TematresSponsorship()
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
        // put if there is no query text
        if (text == null || text.trim().length() == 0)
        {
            return new Choices(true);
        }

        // query args to add to Tematres request URL
        NameValuePair args[] = new NameValuePair[2];
        args[0] = new NameValuePair("arg", text);
        args[1] = new NameValuePair("task","search"); // OR: starts, exact

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
