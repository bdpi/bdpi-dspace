/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */

package org.dspace.app.xmlui.aspect.administrative.mapper;

import java.io.IOException;
import java.util.List;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.discovery.DiscoverQuery;
import org.dspace.discovery.DiscoverResult;
import org.dspace.discovery.SearchServiceException;
import org.dspace.discovery.SearchUtils;

/**
 * Search using the Discovery index provider.
 *
 * @author mwood
 */
public class DiscoverySearchRequestProcessor
        implements SearchRequestProcessor
{
    @Override
    public List<DSpaceObject> doItemMapSearch(Context context, String queryString,
            Collection collection)
            throws IOException
    {
        DiscoverQuery query = new DiscoverQuery();
        query.setQuery(queryString);
        query.addFilterQueries("-location:l"+collection.getID());

	// [start] jan.lara 07.out.2014 - item mapping - fast search by handle
        if(queryString.trim().matches("\\w+\\/\\d+$")){
            query.addFilterQueries("handle:" + queryString.trim());
        }
        else if(queryString.trim().matches("\\d+$")){
            query.addFilterQueries("handle:" + ConfigurationManager.getProperty("handle.prefix") + "/" + queryString.trim());
        }
	// [end] jan.lara 07.out.2014 - item mapping - fast search by handle

        DiscoverResult results = null;
        try {
            results = SearchUtils.getSearchService().search(context, query);
        } catch (SearchServiceException ex) {
            throw new IOException(ex); // Best we can do with the interface method's signature
        }

        return results.getDspaceObjects();
    }
}
