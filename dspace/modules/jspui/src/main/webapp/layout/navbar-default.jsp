<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Default navigation bar
--%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean) request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf('?');
    if (c > -1) {
        currentPage = currentPage.substring(0, c);
    }

    // E-mail may have to be truncated
    String navbarEmail = null;

    if (user != null) {
        navbarEmail = user.getEmail();
    }

    // get the browse indices
    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
    BrowseInfo binfo = (BrowseInfo) request.getAttribute("browse.info");
    String browseCurrent = "";
    if (binfo != null) {
        BrowseIndex bix = binfo.getBrowseIndex();
        // Only highlight the current browse, only if it is a metadata index,
        // or the selected sort option is the default for the index
        if (bix.isMetadataIndex() || bix.getSortOption() == binfo.getSortOption()) {
            if (bix.getName() != null) {
                browseCurrent = bix.getName();
            }
        }
    }
%>


<div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand" href="<%= request.getContextPath()%>/"><img height="25px" src="<%= request.getContextPath()%>/image/dspace-logo-only.png" /></a>
</div>
<nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
    <ul class="nav navbar-nav">
        <li class="<%= currentPage.endsWith("/home.jsp") ? "active" : ""%>"><a href="<%= request.getContextPath()%>/"><span class="glyphicon glyphicon-home"></span> <fmt:message key="jsp.layout.navbar-default.home"/></a></li>

        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.browse"/> <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <li><a href="<%= request.getContextPath()%>/community-list"><fmt:message key="jsp.layout.navbar-default.communities-collections"/></a></li>
                <li class="divider"></li>
                <li class="dropdown-header"><fmt:message key="jsp.layout.navbar-default.browseitemsby"/></li>
                    <%-- Insert the dynamic browse indices here --%>

                <%
                    for (int i = 0; i < bis.length; i++) {
                        BrowseIndex bix = bis[i];
                        String key = "browse.menu." + bix.getName();
                %>
                <li><a href="<%= request.getContextPath()%>/browse?type=<%= bix.getName()%>"><fmt:message key="<%= key%>"/></a></li>
                    <%
                        }
                    %>

                <%-- End of dynamic browse indices --%>

            </ul>
        </li>
        <li><a data-toggle="modal" data-target="#faq"><fmt:message key="jsp.layout.navbar-default.help"/></a></li>
    </ul>
    <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><fmt:message key="jsp.layout.navbar-default.language"/><b class="caret"></b></a>
            <ul class="dropdown-menu text-center">
                <li><a href="?locale=pt_BR"><img src="/image/pt_BR.png" title="Português"></a></li>
                <li><a href="?locale=en"><img src="/image/en.png" title="English"></a></li>
                <li><a href="?locale=es"><img src="/image/es.png" title="Español"></a></li>
            </ul>
        </li>
        <li class="dropdown">
            <%
                if (user != null) {
            %>
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.loggedin">
                    <fmt:param><%= StringUtils.abbreviate(navbarEmail, 20)%></fmt:param>
                </fmt:message> <b class="caret"></b></a>
                <%
                } else {
                %>
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="glyphicon glyphicon-user"></span> <fmt:message key="jsp.layout.navbar-default.sign"/> <b class="caret"></b></a>
                <% }%>             
            <ul class="dropdown-menu">
                <li><a data-toggle="modal" data-target="#openAccessPolicy">Política de Acesso Aberto</a></li>
                <li><a data-toggle="modal" data-target="#politicaDePrivacidade">Política de privacidade</a></li>
                <li><a data-toggle="modal" data-target="#direitosAutorais">Direitos autorais</a></li>
                <li><a data-toggle="modal" data-target="#faq">FAQ</a></li>
                <li><a href="<%= request.getContextPath()%>/feedback"><fmt:message key="jsp.layout.footer-default.feedback"/></a></li>
                <li class="divider"></li>
                <li class="dropdown-header">Usuários</li>
                <li><a href="<%= request.getContextPath()%>/mydspace"><fmt:message key="jsp.layout.navbar-default.users"/></a></li>
                <li><a href="<%= request.getContextPath()%>/subscribe"><fmt:message key="jsp.layout.navbar-default.receive"/></a></li>
                <li><a href="<%= request.getContextPath()%>/profile"><fmt:message key="jsp.layout.navbar-default.edit"/></a></li>

                <%
                    if (isAdmin) {
                %>
                <li class="divider"></li>  
                <li><a href="<%= request.getContextPath()%>/dspace-admin"><fmt:message key="jsp.administer"/></a></li>
                    <%
                        }
                        if (user != null) {
                    %>
                <li><a href="<%= request.getContextPath()%>/logout"><span class="glyphicon glyphicon-log-out"></span> <fmt:message key="jsp.layout.navbar-default.logout"/></a></li>
                    <% }%>
            </ul>
        </li>
    </ul>

    <%-- Search Box --%>
    <form method="get" action="<%= request.getContextPath()%>/simple-search" class="navbar-form navbar-right" scope="search">
        <div class="form-group">
            <input type="text" class="form-control" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>" name="query" id="tequery" size="25"/>
        </div>
        <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span></button>
            <%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
            <%
                                    if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
                                    {
            %>        
                          <br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
            <%
                        }
            %> --%>
    </form>

    <!-- Button trigger modal -->

    <!-- Modal Política de Acesso Aberto -->
    <div class="modal fade" id="openAccessPolicy" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Política de Acesso Aberto</h4>
                </div>
                <div class="modal-body">
                    <div>
                        <a target="_blank" href="http://www.producao.sibi.usp.br/static/pages/RESOLUCAO6444.pdf">Baixar a resolução em formato PDF</a>
                        <br/>
                        <p><b>RESOLUÇÃO Nº 6444, DE 22 DE OUTUBRO DE 2012.</b></p>
                        <p>(D.O.E. - 23.10.2012)</p>
                        <br/>
                        <p style="margin-left:20%;">Dispõe sobre diretrizes e procedimentos para promover e assegurar a coleta, tratamento e preservação da produção intelectual gerada nas Unidades USP e pelos Programas Conjuntos de Pós-Graduação, bem como sua disseminação e acessibilidade para a comunidade.</p>
                        <br/>
                        <p>O Reitor da Universidade de São Paulo, usando de suas atribuições legais, tendo em vista o deliberado pelo Presidente da d. Comissão de Legislação e Recursos, “ad referendum” daquele Colegiado, e considerando a necessidade de:</p>
                        <p style="margin-left:5%;">
                            -       preservar a memória institucional;<br/>
                            -       ampliar a visibilidade e acessibilidade da produção intelectual (científica, acadêmica, artística e técnica) da USP;<br/>
                            -       potencializar o intercâmbio com outras instituições nacionais e internacionais;<br/>
                            -       certificar o uso de indicadores confiáveis referentes à produção intelectual da USP;<br/>
                            -       aperfeiçoar a gestão de investimentos em pesquisa, ensino e extensão nesta Instituição, baixa a seguinte
                        </p>
                        <br/>
                        <p style="text-align:center;"><b>RESOLUÇÃO:</b></p>
                        <br/>
                        <p><b>Artigo 1o.</b> - A Biblioteca Digital da Produção Intelectual (doravante denominada BDPI) passa a ser o instrumento oficial incumbido de reunir a produção intelectual da USP, de modo a:</p>
                        <p style="margin-left:5%;">
                            I - aumentar a visibilidade, acessibilidade e difusão dos resultados da atividade acadêmica e de pesquisa da USP por meio da coleta, organização e preservação em longo prazo;<br/>
                            II - facilitar a gestão e o acesso à informação sobre a produção intelectual da USP, por meio da oferta de indicadores confiáveis e validados;<br/>
                            III - integrar-se a um conjunto de iniciativas nacionais e internacionais, por meio de padrões e protocolos de integração qualificados e normalizados.
                        </p>
                        <br/>
                        <p style="text-align:center;"><b>Do Conselho Supervisor do SIBi</b></p>
                        <br/>
                        <p><b>Artigo 2o.</b> - Fica o Conselho Supervisor do Sistema Integrado de Bibliotecas – SIBi incumbido de estabelecer e validar normas para coleta, tratamento e preservação da produção intelectual gerada na Universidade (atendendo às especificidades da produção impressa e digital), bem como definir os tipos de documentos para depósito, além das teses e dissertações defendidas nas Unidades USP.</p>
                        <br/>
                        <p style="text-align:center;"><b>Da constituição da memória documental</b></p>
                        <br/>
                        <p><b>Artigo 3o.</b> - Para a formação e desenvolvimento da memória da produção intelectual da USP, os docentes, servidores técnicos e administrativos, alunos e pós-doutorandos deverão depositar na BDPI o conteúdo integral de produtos de sua autoria, à medida que forem publicados ou editados.</p>
                        <p style="margin-left:5%;">
                            § 1º - A inserção de conteúdos na BDPI poderá ser feita por auto-arquivamento (depósito feito diretamente pelo próprio autor do trabalho), pela equipe da biblioteca de sua Unidade funcional ou por importação de dados executada pela gerência da BDPI.<br/>
                            § 2º - O depósito da produção intelectual deverá ser realizado de forma não exclusiva, mantendo os autores dos documentos todos os seus direitos.<br/>
                            § 3º - Se de direito, o acesso aos documentos poderá ser aberto, embargado (por tempo limitado pelo contrato assinado pelo autor com a casa editorial), restrito para uso apenas pelos computadores da USP ou restrito completamente (neste caso, o arquivo digital depositado servirá apenas para gestão e governança da produção).<br/>
                            § 4º - Quando produção intelectual não disponível em formato digital, os metadados deverão ser registrados na BDPI e um exemplar da produção deverá ser depositado na biblioteca de sua Unidade funcional.<br/>
                        </p>
                        <br/>
                        <p><b>Artigo 4o.</b> - As teses e dissertações seguem o padrão estabelecido pela Resolução CoPGr nº 6018, de 13.10.2011.</p>
                        <br/>
                        <p><b>Artigo 5o.</b> - Recomenda-se a todos os membros da comunidade USP a publicação de seus resultados de pesquisa, preferencialmente, em fontes que se encontrem em livre acesso ou que façam constar em seus contratos de publicação a permissão para depósito na BDPI. </p>
                        <br/>
                        <p style="text-align:center;"><b>Das Bibliotecas do SIBi</b></p>
                        <br/>
                        <p><b>Artigo 6o.</b> - Compete às Bibliotecas do SIBi, em relação à BDPI:</p>
                        <p style="margin-left:5%;">
                            I - efetuar o registro técnico de produção intelectual na BDPI, desde que solicitado por sua Unidade de vínculo ou por membros daquela comunidade;<br/>
                            II - a edição, revisão, validação e disponibilização online da produção intelectual auto-arquivada pelos autores;<br/>
                            III - a organização de ações periódicas de capacitação sobre procedimentos e esclarecimentos das funcionalidades existentes, dirigidas à comunidade USP;<br/>
                            IV - o apoio aos autores USP na averiguação da situação de suas publicações perante entidades externas, a quem tenham eventualmente sido cedidos os direitos de autor;<br/>
                            V - o fornecimento de dados, informações e estatísticas institucionais requeridas por suas Unidades de vínculo;<br/>
                            VI - a garantia da atualização permanente dos registros da produção intelectual na BDPI, a partir de ações periódicas junto aos autores de sua Unidade de vínculo.
                        </p>
                        <br/>
                        <p style="text-align:center;"><b>Da Coordenação pelo Departamento Técnico do SIBi</b></p>
                        <br/>
                        <p><b>Artigo 7o.</b> - O Departamento Técnico do SIBi, em relação à BDPI, será responsável pela:</p>
                        <p style="margin-left:5%;">
                            I - gerência e atualização constante do sistema de gestão decorrente de evolução tecnológica;<br/>
                            II - geração de dados e indicadores sobre a produção intelectual da USP para fins diversos, dentre eles o Anuário Estatístico ou outros que venham a ser requeridos pelos Órgãos da Universidade;<br/>
                            III - garantia da disseminação de indicadores confiáveis e certificados sobre a produção intelectual gerada na Universidade;<br/>
                            IV - preparação de diretrizes e mecanismos para garantir o controle e a preservação digital da produção intelectual gerada pela USP;<br/>
                            V - formação das competências necessárias às equipes das Bibliotecas do SIBi, visando à plena realização das atividades relativas à BDPI;<br/>
                            VI - criação de mecanismos de estímulo e ações de integração que possibilitem a interoperabilidade e racionalização de recursos com bancos de dados informacionais internos e externos à USP.
                        </p>
                        <br/>
                        <p><b>Artigo 8o.</b> - Para o pleno desenvolvimento das atividades da BDPI, deverá ser assegurada sua integração aos sistemas corporativos da Universidade.</p>
                        <br/>
                        <p><b>Artigo 9o.</b> - Esta Resolução entrará em vigor na data de sua publicação, ficando revogadas a Resolução nº 4221, de 17.11.1995, e todas as disposições em contrário.</p>
                        <br/>
                        <p>Reitoria da Universidade de São Paulo, 22 de outubro de 2012.</p>
                        <p style="text-align:center;">JOÃO GRANDINO RODAS<br/>Reitor</p>


                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Política de privacidade -->
    <div class="modal fade" id="politicaDePrivacidade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Política de privacidade</h4>
                </div>
                <div class="modal-body">
                    <p>Os visitantes da Biblioteca Digital da Produção Intelectual (BDPI) podem navegar pelos serviços e produtos, sem fornecimento de qualquer informação pessoal para terceiros.</p>
                    <p>A Biblioteca Digital da Produção Intelectual (BDPI) possui informações pessoais identificáveis apenas dos docentes, alunos e funcionários da Universidade de São Paulo assegurando a integridade e segurança desses dados por meio de tecnologia adequada.</p>
                    <p>A Biblioteca Digital da Produção Intelectual (BDPI) compromete-se a não monitorar ou divulgar informações sobre o acesso do usuário, a menos que seja obrigado a fazê-lo mediante ordem judicial.</p>
                    <p>A Biblioteca Digital da Produção Intelectual (BDPI) não utiliza cookies e, portanto, não tem acesso às informações coletadas pelos sites da USP ou direcionados por links.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Direitos Autorais -->
    <div class="modal fade" id="direitosAutorais" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Direitos Autorais</h4>
                </div>
                <div class="modal-body">
                    <p>A equipe do SIBi busca não violar o direito de propriedade das editoras comerciais, mas, caso seja detectado algum arquivo fora das exigências contratuais, solicitamos <a href="/feedback">entrar em contato</a> de maneira a regularizar a situação com urgência.</p>
                    <p>Para consultar as políticas de direitos autorais das revistas científicas, acesse a página abaixo, para consultar em uma única tela, os sites especializados <a href="http://www.sherpa.ac.uk/romeo/">RoMEO/SHERPA</a> e <a href="http://diadorim.ibict.br/">DIADORIM</a>:</p>
                    <p><a target="_blank" href="http://acessoaberto.usp.br/copyright/pesquisa.html">Políticas de Copyright e Auto-Arquivo</a></p>
                    <p>Para saber mais sobre as questões relacionadas com o acesso aberto, direitos autorais e auto-arquivo de documentos acesse o <a target="_blank" href="http://acessoaberto.usp.br/copyright/faq.html">Site Acesso Aberto USP</a></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal FAQ -->
    <div class="modal fade" id="faq" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">FAQ</h4>
                </div>
                <div class="modal-body">
                            <div>
		<br/>
   	    <p><b>1) O que é um repositório?</b></p>
		<p style="margin-left:5%;">
		Repositório digital se estabelecem com infra-estrutura de banco de dados capaz de armazenar coleções de documentos em meio eletrônico. 
		Repositórios digitais também podem ser chamados de Bibliotecas Digitais, (Kuramoto, 2008). 
		O repositório gerencia a produção intelectual de uma instituição pelo armazenamento, organização, preservação, recuperação e disseminação. 
		</p>
		<br/>

		<p><b>2) O que é Biblioteca Digital da Produção Intelectual da Universidade de São Paulo (BDPI)? </b></p>
		<p style="margin-left:5%;">
		A Biblioteca Digital da Produção Intelectual da Universidade de São Paulo (BDPI) é um sistema de gestão e disseminação da produção científica, 
		acadêmica, técnica e artística gerada pelas pesquisas desenvolvidas na USP. A <a href="http://producao.usp.br/page/politicaAcessoPtBR" target="_blank">Resolução 6444, de 22 de outubro de 2012</a>, 
		estabelece e determina a BDPI como o instrumento oficial da Universidade de São Paulo para reunião da produção intelectual.
		</p>
		<br/>

		<p><b>3) Quais os objetivos da BDPI?</b></p>
		<p style="margin-left:5%;">
		- Aumentar a visibilidade, acessibilidade e difusão dos resultados da atividade acadêmica e de pesquisa da USP por meio da coleta, organização e preservação em longo prazo;<br/>
        - Facilitar a gestão e o acesso à informação sobre a produção intelectual da USP, por meio da oferta de indicadores confiáveis e validados;<br/>
        - Integrar-se a um conjunto de iniciativas nacionais e internacionais, por meio de padrões e protocolos de integração qualificados e normalizados.
		</p>
		<br/>
		
		<p><b>4) Como foi desenvolvida a BDPI?</b></p>
		<p style="margin-left:5%;">
		A BDPI surgiu em 2009 com o projeto do IBICT e o software utilizado é o DSpace.  
		Foi lançada com a produção intelectual das unidades pilotos da USP em 2010 reunindo a EACH, ECA, FMVZ; 
		mais tarde somando-se a esse grupo as unidades EESC, FSP.  Redesenhada, definitivamente, a partir de 2011 para ser lançada oficialmente em 2012 com 29 mil documentos 
		indexados da SCIELO e Web of Science (WoS), juntamente com a <a href="http://www.usp.br/drh/novo/legislacao/doe2012/res-usp6444.html" target="_blank">resolução 6444 de 22.10.2012</a>.<br/>
	    Em 2013, a BDPI é aberta ao público com novas implementações na versão atualizada 3.1: utiliza o Protocolo de comunicação da Iniciativa dos Arquivos Abertos (OAI-PMH) como provedor de dados, 
		cuja aplicação possibilita que itens do DSpace estejam disponíveis para serem coletados(harvested), auto-arquivamento pelos autores USP,  
		inclusão de novas tipologias, além de artigos, livros e capítulos de livros, trabalhos de eventos.
		</p>
		<br/>
		
		<p><b>5) Como está organizada a BDPI?</b></p>
		<p style="margin-left:5%;">
		A BDPI está organizada pelas unidades USP ligadas aos seus respectivos departamentos e nestes suas coleções.
		</p>
		<br/>
		
		<p><b>6) Que tipo de documento posso encontrar na BDPI?</b></p>
		<p style="margin-left:5%;">
		A BDPI apresenta os tipos de documentos: Artigos e Materiais de Revistas Científicas, Livros e Capítulos de Livros e Comunicações em Eventos.
		</p>
		<br/>
		
		<p><b>7) Quais direitos de autor estão associados aos documentos submetidos na BDPI?</b></p>
		<p style="margin-left:5%;">
		Os autores devem conceder à Instituição uma licença Não-Exclusiva para arquivar e tornar acessível, nomeadamente através da BDPI, os seus documentos em formato digital. 
		Com a concessão da licença não-exclusiva para arquivar e dar acesso ao seu trabalho, os docentes e pesquisadores continuam a reter todos os seus direitos de autor.
		</p>
		<br/>
		
		<p><b>8) Quem pode depositar documentos na BDPI?</b></p>
		<p style="margin-left:5%;">
		Docentes, servidores técnicos e pós-graduandos da USP poderão depositar a respectiva produção intelectual.
		</p>
		<br/>
		
		<p><b>9) Quais os benefícios do autor ao tornar disponível? </b></p>
		<p style="margin-left:5%;">
		Os autores que depositam sua produção científica na BDPI desfrutam de benefícios como: preservação digital, segurança da informação, 
		gestão de direitos e de acesso contribuindo para o aumento de visibilidade e aumento do impacto dos resultados de suas pesquisas.
		</p>
		<br/>
		
		<p><b>10) Documentos de Autor USP em parceria com outros autores poderão ser cadastrado na BDPI?</b></p>
		<p style="margin-left:5%;">
		Sim, desde que exista pelo menos um autor USP, os outros podem ser de Instituições Externas. As afiliações dos autores externos é dada no artigo.
		</p>
		<br/>
		
		<p><b>11) O que é “Acesso aberto”?</b></p>
		<p style="margin-left:5%;">
		Entende-se por movimento de acesso aberto a “literatura científica disposta online livre de restrições de direito autoral, licenças de uso e custos,” 
		pesquisadores estão engajados cada vez mais em torno desse movimento e procuram depositar sua produção intelectual em repositórios livres. 
		O acesso aberto permite que o texto integral dos documentos seja lido, descarregado (download), distribuído, impresso, pesquisado ou referenciado (link).<br/>
		Leia mais: <a href="http://oa.mpg.de/lang/en-uk/berlin-prozess/berliner-erklarung/" target="_blank">Berlin Declaration</a>, 
		<a href="http://legacy.earlham.edu/~peters/fos/bethesda.htm" target="_blank">Bethesda Declaration</a>, 
		<a href="http://www.budapestopenaccessinitiative.org/" target="_blank">Budapest Declaration</a>.
		</p>
		<br/>
		
		<p><b>12) Como é o uso da Licença Creative Common (CC) na BDPI-USP?</b></p>
		<p style="margin-left:5%;">
		Na submissão, o autor poderá escolher as seguintes Licenças Creative Common:<br/>
		<b>CC BY</b> – Atribuição (BY): Os licenciados têm o direito de copiar, distribuir, exibir e executar a obra e fazer trabalhos derivados dela, desde que os créditos sejam dados ao autor ou licenciador, na maneira especificada por estes;<br/>
		<b>CC BY-NC</b> – Uso não Comercial (NC): Os licenciados podem copiar, distribuir, exibir e executar a obra e fazer trabalhos derivados dela, desde que sejam para fins <u>não-comerciais</u>;<br/>
		<b>CC BY-SA</b> – Share Alike (SA) : Os licenciados devem distribuir obras derivadas somente sob uma licença idêntica à que governa a obra original;<br/>
		<b>CC BY-NC-AS</b> - Share Alike (SA) : Os licenciados devem distribuir obras derivadas somente sob uma licença idêntica à que governa a obra original, desde que sejam para fins <u>não-comerciais</u>.
		</p>
		<br/>

		<p><b>13) O que é copyright?</b></p>
		<p style="margin-left:5%;">
		Copyright é uma forma de direito intelectual, significa, literalmente, "direito de cópia", é um direito legal que concede ao autor de trabalhos originais 
		direitos exclusivos de exploração de uma obra artística, literária ou científica, proibindo a reprodução por qualquer meio. 
		Ele impede a cópia ou exploração de uma obra sem que haja permissão. O símbolo do copyright © presente em uma obra restringe a sua impressão sem autorização prévia, 
		impedindo que haja benefícios financeiros para outros que não sejam o autor ou o editor da obra.
		</p>
		<br/>
		
		<p><b>14) O que é Dspace?</b></p>
		<p style="margin-left:5%;">
		DSpace é um software aberto para uso em instituições acadêmicas sem fins lucrativos, usado para construção de repositórios digitais abertos. É gratuito, 
		fácil de instalar e personalizar para atender às necessidades de qualquer organização. Consulte: <a href="http://www.dspace.org/" target="_blank">http://www.dspace.org/</a>
		</p>
		<br/>
		
		<p><b>15) O que são metadados?</b></p>
		<p style="margin-left:5%;">
		Conjunto de elementos com semântica padronizada, que possibilitam representar as informações eletrônicas e descrever recursos eletrônicos de maneira bibliográfica.
		Devido a sua característica de aplicação na área bibliográfica e a simplicidade de uso, o formato de metadados eleito para utilização do DSpace é o padrão Dublin Core (DC). É uma versão qualificada, que possui 15 elementos básicos e mais 35 elementos de refinamento. O DC objetiva colocar dados necessários para descrever, identificar, processar, localizar e recuperar documentos disponíveis na Internet.
		</p>
		<br/>
		
		<p><b>16) O que é auto-arquivamento? Qual o objetivo?</b></p>
		<p style="margin-left:5%;">
		Auto-arquivar (<i>self-archive</i>) significa depositar um documento digital em um site público da web compilado para o protocolo Open Archive Initiative (OAI).
		O auto-arquivamento não restringe o ato de depositar um documento exclusivamente ao autor do texto eletrônico, mas admite igualmente a submissão por terceiros, desde que autorizada pelo autor.<br/>
		O objetivo é gerar visibilidade e acesso aos trabalhos de pesquisas desenvolvidos, aumentando as possibilidades de ser citado e conhecido amplamente. Além disso, minimizar radicalmente as barreiras impostas nos sistemas tradicionais de publicação.
		</p>
		<br/>
		
		<p><b>17) Auto-aquivar é o mesmo que publicar?</b></p>
		<p style="margin-left:5%;">
		Não. A diferença entre auto-publicação (<i>vanity press</i>) e auto-arquivamento (<i>refereed research</i>) e que neste último, o fato de tornar público um texto científico em arquivo aberto, não significa que se tratar de uma publicação. 
		No entanto, o fato do artigo ter obtido uma boa apreciação entre os pares é suficiente para ser contado com publicação. A distinção no meio científico é, portanto, a qualidade do trabalho e para isso necessita de validação de um grupo de especialistas. 
		Contudo auto-arquivar é um excelente forma para estabelecer prioridades e afirmar direitos autorais.
		</p>
		<br/>
		
		<p><b>18) O que é a Open Archives Initiative (OAI)? </b></p>
		<p style="margin-left:5%;">
		Lançada em 1999, com o objetivo de criar uma plataforma simples para permitir a interoperabilidade e a pesquisa de publicações científicas de diversas disciplinas. Essa iniciativa surgiu dentro da comunidade dos eprints e partiu de uma abordagem essencialmente técnica, resultando no protocolo OAI-PMH.<br/> 
		<a href="http://www.openarchives.org/" target="_blank">Open Archives Initiative (OAI)</a> desenvolveu um código partilhado para tags de metadados (ex: “date”, “author”, “title”, “journal”, etc.). Ver as <a href="http://www.openarchives.org/documents/FAQ.html" target="_blank">FAq's OAI</a>. 
		Os textos completos dos documentos podem estar em diferentes formatos e localizações, mas se usarem as mesmas tags de metadados tornam-se interoperáveis. Os seus metadados podem ser colhidos (<i>harvesting</i>) e todos os documentos podem, então, ser procurados conjuntamente e recuperados como se estivessem todos numa coleção global, acessível a todos. 
		<a href="http://www.scielo.br/scielo.php?script=sci_arttext&amp;pid=S0100-19652006000200010&amp;lng=en&amp;nrm=iso&amp;tlng=pt#fig02" target="_blank">Veja a figura</a>. 
		</p>
		<br/>
		
		<p><b>19) O que é OAI-compliance?</b></p>
		<p style="margin-left:5%;">
		Consiste no uso das tags de metadados OAI. Repositório e documento pode ser OAI-compliant, assim, tornam-se interoperáveis significando que os documentos distribuídos podem ser tratados como se estivessem todos no mesmo lugar e com o mesmo formato. 
		</p>
		<br/>
				
		<p><b>20) Bibliotecários serão responsáveis pela correção dos artigos submetidos por docentes? </b></p>
		<p style="margin-left:5%;">
		Sim. O técnico e/ou bibliotecário necessitam complementar os dados na etapa de revisão. A validação/publicação do registro é de responsabilidade do bibliotecário.
		</p>
		<br/>
		
		<p><b>21) Em caso de submissão de artigos disponíveis em dois idiomas (português e inglês) os dois arquivos poderão ser disponibilizados?</b></p>
		<p style="margin-left:5%;">
		Sim, os dois arquivos poderão ser anexados.
		</p>
		<br/>
		
		<p><b>22) O que é um item?</b></p>
		<p style="margin-left:5%;">
		É o documento individualmente considerado que compõe uma coleção. Para cada item deve haver um conjunto  de metadados correspondentes.
		</p>
		<br/>
		
		<p><b>23) Submeti um documento, mas este não aparece na coleção respectiva. Por quê?</b></p>
		<p style="margin-left:5%;">
		Porque o artigo poder  está na fase de revisão ou publicação. <br/>
		Outra possibilidade é que o artigo tenha sido inserido apenas na comunidade de um autor. Documentos entre autores USP de diferentes unidades/departamentos serão mapeados 
		(associar o item da coleção “origem” à coleção “destino” para fins estatísticos e recuperação da informação) pela Equipe da BDPI do Departamento Técnico do Sistema Integrado de Bibliotecas da USP.
		</p>
		<br/>
		
		<p><b>24) Existe data de publicação inicial a partir da qual devem ser depositados os documentos na BDPI-USP? </b></p>
		<p style="margin-left:5%;">
		Sim, poderão ser inseridos documentos referentes ao ano de 2013 em diante. Lembrando que antes de submeter qualquer registro, o depositante deverá pesquisar na BDPI para verificar se o registro já foi indexado anteriormente.
		</p>
		<br/>
		
		<p><b>25) Quem tem acesso aos documentos depositados na BDPI?</b></p>
		<p style="margin-left:5%;">
		Os documentos depositados, em sua maioria, tem acesso aberto a qualquer interessado. Na BDPI temos os seguintes tipos de acesso: <br/>
		- acesso fechado: o usuário não tem acesso ao documento;<br/>
		- restritos ao IP USP: apenas a comunidade USP tem acesso ao documento;<br/>
		- embargado, utilizado para documentos protegidos por um período determinado de tempo, decorrido o prazo o acesso é automático.
		</p>
		<br/>
		
		<p><b>26) Deixei um item em processo de depósito sem finalizar. E agora?</b></p>
		<p style="margin-left:5%;">
		O formulário de depósito da BDPI permite que o depositante interrompa o processo de submissão, salvando o registro para retornar mais tarde.
		</p>
		<br/>
		
		<p><b>27) O que são “pré print”, “pós print” e “versão publicada”?</b></p>
		<p style="margin-left:5%;">
		- Pré-print (preprint): refere-se a um artigo ainda não publicado<br/>
		- Pós-print (posprint): refere-se a um artigo que foi aceito em um periódico com revisão por pares<br/>
		- Published Version (versão publicada): refere-se a um artigo que foi aceito e publicado em um periódico com revisão por pares.
		</p>
		<br/>
		
		<p><b>28) Se publicar meu artigo na BDPI, perco os meus direitos de autor?</b></p>
		<p style="margin-left:5%;">
		Os autores devem conceder à Instituição uma licença Não-Exclusiva para arquivar e tornar acessível pela BDPI, os seus documentos em formato digital. 
		Com a concessão desta licença não-exclusiva para arquivar e dar acesso ao seu trabalho, os docentes e investigadores continuam a reter todos os seus direitos de autor.
		</p>
		<br/>		
		
		<p><b>29) A Política da BDPI autoriza disponibilização de artigos restritos?</b></p>
		<p style="margin-left:5%;">
		Não. Artigos restritos tem o acesso ao documento na íntegra proibido (documentos sob copyright).
		</p>
		<br/>
		
		<p><b>30) Produção intelectual oriundas de bases de dados de acesso restrito e assinadas pela USP podem ser disponibilizadas na BDPI?</b></p>
		<p style="margin-left:5%;">
		Sim, porém o acesso ao texto completo será restrito ao IP USP.
		</p>
		<br/>
		
		<p><b>31) Posso publicar um artigo numa revista e ao mesmo tempo na BDPI?</b></p>
		<p style="margin-left:5%;">
		Sim, a publicação do artigo na BDPI, apenas aumenta a visibilidade, acessibilidade, difusão e preservação do mesmo. Contudo, o autor do artigo precisa pertencer à comunidade USP.
		</p>
		<br/>
		
		<p><b>32) Como se dá a alteração de status para artigos embargados?</b></p>
		<p style="margin-left:5%;">
		Decorrido o prazo de proteção ao documento pelo período determinado de tempo, a alteração de status se dá automaticamente.
		</p>
		<br/>
		
		<p><b>33) A minha dissertação de mestrado foi publicada por uma editora que a colocou no circuito comercial. Posso publicá-la também na BDPI?</b></p>
		<p style="margin-left:5%;">
		Sim, desde que o livro contenha a informação de que a obra ou parte dela poderá ser reproduzida em meio digital ou solicitada autorização prévia e por escrito do Editor.
		</p>
		<br/>

		<p><b>34) Artigo originário de tese recebe o link da tese?</b></p>
		<p style="margin-left:5%;">
		Sim, o link da tese poderá ser disponibilizado no campo URL.
		</p>
		<br/>
		
		<p><b>35) Por que motivo uma editora ou o publicador de uma revista permite a publicação de artigos em acesso aberto?</b></p>
		<p style="margin-left:5%;">
		Pelo fato de que editora ou publicador integram o movimento de acesso livre ao conhecimento científico que, atualmente integra vários países, entre os quais o 
		Brasil por parte dos pesquisadores, agências de fomento à pesquisa, editores de revistas científicas, pelo governo e adoção de políticas nacionais de distribuição de 
		softwares gratuitos de editoração de revistas eletrônicas.
		</p>
		<br/>
		
		<p><b>36) Artigos na versão revisada pré-print poderão ser inseridos na BDPI?</b></p>
		<p style="margin-left:5%;">
		Sim, pré-print podem ser inseridos na BDPI.
		</p>
		<br/>
		
		<p><b>37) E se o editor proibir o auto-arquivo do pré-print?</b></p>
		<p style="margin-left:5%;">
		O pré-print é auto-arquivado na fase em que ainda não existe nenhum acordo de transferência de copyright e o autor detém o direito exclusivo. 
		</p>
		<br/>
		
		<p><b>38) Artigos em versão revisada por pares poderão ser inseridos na BDPI?</b></p>
		<p style="margin-left:5%;">
		Sim, artigos revisados por pares podem ser disponibilizados na BDPI. Assim como pós- print e a versão publicada.
		</p>
		<br/>
		
		<p><b>39) Como é realizado o acesso à BDPI?</b></p>
		<p style="margin-left:5%;">
		O acesso à BDPI é feito pelo número USP e a mesma senha utilizada pela comunidade nos sistemas USP.
		</p>
		<br/>
		
		<p><b>40) Como encontrar a informação desejada na BDPI?</b></p>
		<p style="margin-left:5%;">
		A BDPI dispõe de “Busca” e “Busca avançada” para recuperação da informação. O usuário poderá ter acesso aos documentos pelo autor, título do documento, assunto, revista, agência de fomento. 
		Documentos de acesso restrito ao IP USP poderão ser recuperados pelos computadores existentes nas bibliotecas da USP ou acesso VPN.
		</p>
		<br/>
		
		<p><b>41) Posso enviar os resultados de pesquisa na BDPI por e-mail?</b></p>
		<p style="margin-left:5%;">
		Os resultados de buscas feitas nas opções de “Busca” ou “Busca Avançada” não poderão ser salvos e encaminhados por e-mail para utilização posterior. 
		</p>
		<br/>
		
		<p><b>42) O que é preservação digital?</b></p>
		<p style="margin-left:5%;">
		Emprego de mecanismos que permitem o armazenamento em repositórios de objetos digitais e que garantem a perenidade dos seus conteúdos. Compreende o planejamento, a alocação de recursos e a 
		aplicação de métodos e tecnologias para assegurar que a informação digital de valor contínuo permaneça acessível e utilizável.
		</p>
		<br/>
		
		<p><b>43) A quem encaminho dúvidas sobre submissão da produção, sobre a BDPI em geral?</b></p>
		<p style="margin-left:5%;">
		Caso ocorra algum problema com a submissão do item ou outra particularidade, o usuário poderá entrar em contato com o 
		Departamento Técnico do Sistema Integrado de Bibliotecas (DT/SIBi) pelo e-mail: <a href="atendimento@sibi.usp.br">atendimento@sibi.usp.br</a>
		</p>
		<br/>
		
		<p><b>44) Livros de autores USP que não sejam de acesso aberto poderão ser inseridos na BDPI?</b></p>
		<p style="margin-left:5%;">
		Sim, poderão ser colocados os arquivos de capa, sumário e resenha (caso exista) em “Arquivos do item”.
		</p>
		<br/>
		
         </div>
                    </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>
    

</nav>
    
