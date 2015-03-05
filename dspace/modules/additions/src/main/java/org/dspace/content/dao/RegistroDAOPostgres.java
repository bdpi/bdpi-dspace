package org.dspace.content.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.dspace.core.Context;
import java.sql.SQLException;


public class RegistroDAOPostgres extends RegistroDAO
{
    /** Query para contar o total de registros. É feito o somatório do total de itens por coleção. */
    private static final String selectTotalRegistros = "SELECT SUM(COUNT) AS total_registros FROM collection_item_count";

    /** Query para totalizar os itens do tipo openAccess. Contabiliza-se todos os itens marcados como OpenAccess (no campo de id 53)  *
     * e que não foram retirados (withdrawn='f'), que sejam é buscáveis (discoverable='t') e que estejam em arquivo (in_archive='t'). */
    private static final String selectTotalRegistrosOpenAccess = "SELECT COUNT(*) AS total_open_access FROM " +
        "( SELECT metadatavalue.*, item.* from metadatavalue INNER JOIN item ON metadatavalue.item_id=item.item_id" +
        "WHERE metadatavalue.metadata_field_id=53 AND text_value='openAccess' AND item.withdrawn='f' AND item.discoverable='t'" +
        "AND item.in_archive='t') AS tabelaOpenAccess";
    
    public RegistroDAOPostgres() {
    }

    public RegistroDAOPostgres(Context ctx)
    {
        super(ctx);
        this.context = ctx;
    }
    
    /** Método que retorna o total de registros cadastrados na bdpi.
     * @return o total de itens
     * @throws java.sql.SQLException  */  
    public int getTotalRegistros() throws SQLException {
        try {
            context = new Context();
            PreparedStatement statement = context.getDBConnection().prepareStatement(selectTotalRegistros);
            ResultSet rs = statement.executeQuery();
            int totalRegistros = 0;		 
            if(rs.next()) totalRegistros = rs.getInt("total_registros");
            rs.close();
            statement.close();
            context.complete();
            return totalRegistros;
         } catch(SQLException sql) {
            System.out.println("Erro: no SQL ----" + sql.getMessage() );
            sql.printStackTrace(System.out);
            return -1;
          } 
    }

    /** Método que retorna o total de registros open access cadastrados e disponíveis ao público na bdpi.
     * @return o total de itens open access
     * @throws java.sql.SQLException  */      
    public int getTotalRegistrosOpenAccess() throws SQLException {
        try {
            context = new Context();
            PreparedStatement statement = context.getDBConnection().prepareStatement(selectTotalRegistrosOpenAccess);
            ResultSet rs = statement.executeQuery();
            int totalRegistrosOpenAccess = 0;		 
            if(rs.next()) totalRegistrosOpenAccess = rs.getInt("total_open_access");
            rs.close();
            statement.close();
            context.complete();
            return totalRegistrosOpenAccess;
         } catch(SQLException sql) {
            System.out.println("Erro: no SQL ----" + sql.getMessage() );
            sql.printStackTrace(System.out);
            return -1;
          } 
    }
}