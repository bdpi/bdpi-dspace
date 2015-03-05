package org.dspace.content.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.dspace.core.Context;
import java.sql.SQLException;


public class CommunityDAOPostgres extends CommunityDAO
{
    /** Query para a contar o total de unidades com registros na BDPI, que são as communities sem communities pai. *
     *  Desconta-se 1 por causa da communitie criada para os "sem unidade".                                        */
    private static final String selectTotalUnidades = "SELECT ( SELECT COUNT(*) FROM COMMUNITY ) " +
            "- ( SELECT COUNT(*) FROM COMMUNITY2COMMUNITY ) - 1 as total_unidades";
    
    /** Query para contar o total de departamentos, que são as communities com pai. Usa-se o fato de que não*/
    private static final String selectTotalDepartamentos = "SELECT " +
            "( SELECT COUNT(*) FROM COMMUNITY2COMMUNITY ) - " +
            "( SELECT COUNT(*) FROM COMMUNITY WHERE NAME LIKE 'Outros departamentos%' ) " +
            "AS total_departamentos";
    
    public CommunityDAOPostgres() {
    }

    public CommunityDAOPostgres(Context ctx)
    {
        super(ctx);
        this.context = ctx;
    }
    
    /** Método que retorna o total de unidades (communities que não têm pai).
     * @return o total de unidades.
     * @throws java.sql.SQLException  */
    public int getTotalUnidades() throws SQLException {
        try {
            context = new Context();
            PreparedStatement statement = context.getDBConnection().prepareStatement(selectTotalUnidades);
            ResultSet rs = statement.executeQuery();
            int totalUnidades = 0;		 
            if(rs.next()) totalUnidades = rs.getInt("total_unidades");
            rs.close();
            statement.close();
            context.complete();
            return totalUnidades;
         } catch(SQLException sql) {
            System.out.println("Erro: no SQL ----" + sql.getMessage() );
            sql.printStackTrace(System.out);
            return -1;
          } 
     }
    
    /** Método que retorna o total de de departamentos (communities que são filhas de communities).
     * @return o total de departamentos.
     * @throws java.sql.SQLException  */
    public int getTotalDepartamentos() throws SQLException {
        try {
            context = new Context();
            PreparedStatement statement = context.getDBConnection().prepareStatement(selectTotalDepartamentos);
            ResultSet rs = statement.executeQuery();
            int totalDepartamentos = 0;		 
            if(rs.next()) totalDepartamentos = rs.getInt("total_departamentos");
            rs.close();
            statement.close();
            context.complete();
            return totalDepartamentos;
         } catch(SQLException sql) {
            System.out.println("Erro: no SQL ----" + sql.getMessage() );
            sql.printStackTrace(System.out);
            return -1;
          } 
     }
}