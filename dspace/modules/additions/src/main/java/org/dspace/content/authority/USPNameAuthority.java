/**
 * 
 */
package org.dspace.content.authority;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import org.apache.log4j.Logger;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.services.model.Request;
import org.dspace.utils.DSpace;

/**
 * USP Name Authority
 * 
 * @author Helves Domingues / Jan LL - alterado para uso da base oracle - 17.out.2013*
 * @version $Revision $
 */
public class USPNameAuthority implements ChoiceAuthority {
	private static final Logger log = Logger.getLogger(USPNameAuthority.class);

        private static final String sql_value = "select metadatavalue.text_value " +
        "from metadatavalue " +
        "inner join metadatafieldregistry mfr on (metadatavalue.metadata_field_id = mfr.metadata_field_id) " +
        "inner join metadataschemaregistry msr on (mfr.metadata_schema_id = msr.metadata_schema_id) " +
        "where msr.short_id || '_' || mfr.element || coalesce('_' || mfr.qualifier, '') = ? " +
        "and metadatavalue.authority = ? limit 1";

        // Esquema e tabela onde os dados dos autores estao armazenados
        // codpes,nome, nomeinicial, sobrenome, unidade_sigla, depto_sigla,funcao
        // DISTINCT codpes, nome, nomeinicial, sobrenome, unidade_sigla, depto_sigla, funcao,
        // dtaini, dtafim
        
        /* expressao antiga, desativada em 16.jul.2014
        private static final String DATABASE_TABLE = "(SELECT rownum idrowx, vinculopessoausp.codpes, vinculopessoausp.nompes nome, \n" +
        "regexp_substr(vinculopessoausp.nompes,'(.*)\\s.*',1,1,'i',1) nomeinicial,\n" +
        "nvl(regexp_substr(vinculopessoausp.nompes,'.*\\s(.*)',1,1,'i',1),vinculopessoausp.nompes) sobrenome,\n" +
        "unidade.sglund unidade_sigla,\n" +
        "setor.nomabvset depto_sigla,\n" +
        "vinculopessoausp.tipfnc funcao,\n" +
        "nvl(resuservhistfuncional.dtainisitfun,vinculopessoausp.dtainivin) dtaini,\n" +
        "nvl(resuservhistfuncional.dtafimsitfun,vinculopessoausp.dtafimvin) dtafim\n" +
        "FROM vinculopessoausp\n" +
        "left join resuservhistfuncional on (resuservhistfuncional.codpes = vinculopessoausp.codpes AND vinculopessoausp.tipvin = 'SERVIDOR')\n" +
        "left join unidade on (vinculopessoausp.codund = unidade.codund OR vinculopessoausp.codfusclgund = unidade.codund)\n" +
        "left join setor on (vinculopessoausp.codset = setor.codset)\n" +
        " WHERE_EXPRESSION )";        
        */

        private static final String DATABASE_TABLE = "(SELECT rownum idrowx, codpes nusp, codpes2codpub(view_bdpi.codpes) codpes, view_bdpi.nompes nome, \n" +
        "regexp_substr(view_bdpi.nompes,'(.*)\\s.*',1,1,'i',1) nomeinicial,\n" +
        "nvl(regexp_substr(view_bdpi.nompes,'.*\\s(.*)',1,1,'i',1),view_bdpi.nompes) sobrenome,\n" +
        "view_bdpi.sglund unidade_sigla,\n" +
        "view_bdpi.nomabvset depto_sigla,\n" +
        "view_bdpi.tipfnc funcao,\n" +
        "view_bdpi.dtaini,\n" +
        "view_bdpi.dtafim\n" +
        "FROM view_bdpi\n" +
        " WHERE_EXPRESSION)";
        /*
        private static final String orderingrows = ",\n" +
"decode(substr(lower(tipvin),0,4),'exte',1,'auto',1,'insc',2,'cand',2,'depe',3,0) B,\n" +
"nvl(dtafim,to_date('2199','YYYY')) C,\n" +
"nvl2(sitctousp,decode(lower(sitctousp),'ativado',0,1),0) D,\n" +
"decode(sitatl,'A',0,'P',1,'D',2,3) E,\n" +
"decode(substr(decode(lower(tipfnc),'docente','docente',lower(tipvin)),0,5),'docen',0,'aluno',1,'servi',2,3) F,\n" +
"decode(lower(tipmer),'ms-6',0,'ms-5',1,'ms-4',2,'ms-3',3,'ms-2',4,'ms-1',5,'pc 1',6,'pc 2',7,'pc 3',8) G,\n" +
"numseqpgm H";
        
        private static final String orderby = "order by\n" +
"B,\n" +
"C desc,\n" +
"D,\n" +
"E,\n" +
"F,\n" +
"G,\n" +
"H desc";
        */
        private Context context = null ;
        private static Request request = null;
        
        private Context getContext() throws SQLException {
            if(request == null) request = new DSpace().getRequestService().getCurrentRequest();
            context = (Context) request.getAttribute("dspace.context");
            if(context == null){
                context = new Context(Context.READ_ONLY); 
		request.setAttribute("dspace.context", context);
            }
            return context;
        }
                
        public Connection getReplicaUspDBconnection() {
            Connection ocn = null;
            try {
                DriverManager.registerDriver((Driver) Class.forName(ConfigurationManager.getProperty("usp-authorities", "db.driver")).newInstance());

                ocn = DriverManager.getConnection(ConfigurationManager.getProperty("usp-authorities", "db.url"),
                                                  ConfigurationManager.getProperty("usp-authorities", "db.username"),
                                                  ConfigurationManager.getProperty("usp-authorities", "db.password"));
            }
            catch(ClassNotFoundException e){
                e.printStackTrace(System.out);
            }
            catch(InstantiationException e){
                e.printStackTrace(System.out);
            }
            catch(IllegalAccessException e){
                e.printStackTrace(System.out);
            }
            catch(SQLException e){
                e.printStackTrace(System.out);
            }
            return ocn;
        }
        
	// Construtor
	public USPNameAuthority() {
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

        // Devolve as opcoes possiveis
        @Override
	public Choices getMatches(String field, String query, int collection,
			int start, int limit, String locale) {
		
		PreparedStatement statement;
                ResultSet rs;
                int MAX_AUTORES = ConfigurationManager.getIntProperty("xmlui.lookup.select.size", 50);
                MAX_AUTORES = limit > MAX_AUTORES ? MAX_AUTORES : limit;
                
		try {
			log.debug(" ==1 Parametros == ");				
			log.debug(" == field == " + field);
			log.debug(" == query == " + query);			
			log.debug(" == collection == " + collection);
			log.debug(" == start == " + start);
			log.debug(" == limit == " + limit);
			log.debug(" == locale == " + locale);
			log.debug(" ================== ");
                        
			String nomes[];
                        HashMap<Integer,String[]> filtro = new HashMap<Integer,String[]>();
			nomes = query.toLowerCase().split("[^0-9a-z]+");
                        
                        int pindex = 1;
                        for (String nome : nomes) {
                            try {
                                if (Integer.parseInt(nome) > 0) {
                                    filtro.put(pindex++, new String[]{"view_bdpi.codpes = ?",
                                                                      nome,
                                                                      "int"});
                                }
                            } catch (NumberFormatException e) {
                                filtro.put(pindex++, new String[]{"translate(lower(view_bdpi.nompes),'áéíóúâêîôûàèìòùäëïöüãõç','aeiouaeiouaeiouaeiouaoc') like lower(?)",
                                                                  "%".concat(nome).concat("%"),
                                                                  "string"});
                            }
                        }

                        int total = 0;
                        
                        StringBuilder where_expression = new StringBuilder();
                        
                        where_expression.append(" WHERE ");
                        if(filtro.isEmpty()) where_expression.append("rownum < 0");
                        else {
                            for(int i = 1; i < pindex; i++){
                                if(i > 1) where_expression.append(" AND ");
                                where_expression.append(filtro.get(i)[0]);
                            }
                        }
                        
                        StringBuilder consulta_total = new StringBuilder();
                        consulta_total.append("SELECT COUNT(*) Q FROM ");
                        consulta_total.append(DATABASE_TABLE.replace("WHERE_EXPRESSION",where_expression.toString()));
                        // .replace("ORDERINGROWS","").replace("ORDERBY","")
                        
                        StringBuilder consulta = new StringBuilder();
                        consulta.append("SELECT codpes, nusp, nome, nomeinicial, sobrenome, unidade_sigla, depto_sigla, funcao, dtaini, dtafim FROM ");
                        consulta.append(DATABASE_TABLE.replace("WHERE_EXPRESSION",where_expression.toString()));
                        consulta.append(" WHERE rownum < ").append(String.valueOf(MAX_AUTORES + 1));
                        consulta.append(" AND idrowx > ").append(String.valueOf(start));
                        consulta.append(" order by nome");
                        // .replace("ORDERINGROWS",orderingrows).replace("ORDERBY",orderby)
                        
                        Connection caut = getReplicaUspDBconnection();
                        
                        // System.out.println(" consulta_total == " + consulta_total.toString());
                        statement = caut.prepareStatement(consulta_total.toString());
                        for(int i = 1; i < pindex; i++){
                            if(filtro.get(i)[2].equals("int")){
                                statement.setInt(i, Integer.valueOf(filtro.get(i)[1]));
                            }
                            else if(filtro.get(i)[2].equals("string")){
                                statement.setString(i, filtro.get(i)[1]);
                            }
                        }
                        rs = statement.executeQuery();
                        while(rs.next()){
                            total = rs.getInt("Q");
                        }                        
                        statement.close();
                        
                        // System.out.println(" consulta == " + consulta.toString());
                        statement = caut.prepareStatement(consulta.toString());
                        for(int i = 1; i < pindex; i++){
                            if(filtro.get(i)[2].equals("int")){
                                statement.setInt(i, Integer.valueOf(filtro.get(i)[1]));
                            }
                            else if(filtro.get(i)[2].equals("string")){
                                statement.setString(i, filtro.get(i)[1]);
                            }
                        }
                        rs = statement.executeQuery();
                        ArrayList<Choice> v = new ArrayList<Choice>();
                        while(rs.next()){
                            v.add(new Choice(rs.getString("codpes"),
                                    rs.getString("sobrenome") + ", "
                                  + rs.getString("nomeinicial"),
                                    rs.getString("nome")
                                  + " - "
                                  + String.valueOf(String.valueOf(rs.getInt("nusp"))) + " ("
                                  + nvl(rs.getString("unidade_sigla"),trims(rs.getString("unidade_sigla")), "- ")
                                  + nvl(rs.getString("depto_sigla"), "/ " + trims(rs.getString("depto_sigla")),"/ -")
                                  + ")"
                                  + nvl(rs.getString("funcao")," [" + trims(rs.getString("funcao")) + "]"," ")
                                  + nvl(rs.getDate("dtaini"),"[" + sdfnew(rs.getDate("dtaini")),"[")
                                  + nvl(rs.getDate("dtafim")," a " + sdfnew(rs.getDate("dtafim")) + "]","]")));
                        }
                        statement.close();
                        caut.commit();
                        caut.close();
                        log.debug(" FIM ");
                        return new Choices(v.toArray(new Choice[v.size()]), start, total , Choices.CF_ACCEPTED, v.size()>=limit, 0);
                    } catch (NumberFormatException e) {
                        e.printStackTrace(System.out);
                    } catch (SQLException e) {
                        e.printStackTrace(System.out);
                    }
                    return null;
	}

        @Override
	public Choices getBestMatch(String field, String text, int collection, String locale) {
		Choice v[] = new Choice[1];
		v[0] = new Choice("1", "Nao definido", "Nao definido");
		return new Choices(v, 0, v.length, Choices.CF_UNCERTAIN, false, 0);
	}

	public static boolean notEmpty(String s) {
		return (s != null && s.length() > 0);
	}
        
        public static String nvl(Object vi, String vo, String ve){
            if(vi==null){
                return ve;
            }
            else {
                return vo;
            }
        }
        
        public static String sdfnew(java.sql.Date sdfx){
            if(sdfx == null){
                return "";
            }
            else {
                return new SimpleDateFormat("dd/MM/yyyy").format(sdfx);
            }
        }
        
        public static String trims(String x){
            if(x == null){
                return "";
            }
            else {
                return x.trim();
            }
        }
}
