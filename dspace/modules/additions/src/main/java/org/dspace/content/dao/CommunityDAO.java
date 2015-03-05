/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.content.dao;

import org.dspace.core.Context;

/**
 *
 * @author leonardo
 */
public abstract class CommunityDAO {
    protected Context context;

    public CommunityDAO(){}

    protected CommunityDAO(Context ctx)
    {
        context = ctx;
    }
}
