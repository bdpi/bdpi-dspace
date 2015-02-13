<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display hierarchical list of communities and collections
  -
  - Attributes to be passed in:
  -    communities         - array of communities
  -    collections.map  - Map where a keys is a community IDs (Integers) and 
  -                      the value is the array of collections in that community
  -    subcommunities.map  - Map where a keys is a community IDs (Integers) and 
  -                      the value is the array of subcommunities in that community
  -    admin_button - Boolean, show admin 'Create Top-Level Community' button
  --%>

<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
	
<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.ItemCountException" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<dspace:layout titlekey="jsp.community-list.title">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">Frequent AQ</h4>
                </div>
                <div class="modal-body">
                            <div>
		<br/>
   	    <p><strong>1) O que é um repositório?</strong></p>
		<p style="margin-left:5%;">
		Repositório digital se estabelecem com infra-estrutura de banco de dados capaz de armazenar coleções de documentos em meio eletrônico. 
		Repositórios digitais também podem ser chamados de Bibliotecas Digitais, (Kuramoto, 2008). 
		O repositório gerencia a produção intelectual de uma instituição pelo armazenamento, organização, preservação, recuperação e disseminação. 
		</p>
		<br/>

		<p><strong>2) O que é Biblioteca Digital da Produção Intelectual da Universidade de São Paulo (BDPI)? </strong></p>
		<p style="margin-left:5%;">
		A Biblioteca Digital da Produção Intelectual da Universidade de São Paulo (BDPI) é um sistema de gestão e disseminação da produção científica, 
		acadêmica, técnica e artística gerada pelas pesquisas desenvolvidas na USP. A <a href="http://producao.usp.br/page/politicaAcessoPtBR" target="_blank">Resolução 6444, de 22 de outubro de 2012</a>, 
		estabelece e determina a BDPI como o instrumento oficial da Universidade de São Paulo para reunião da produção intelectual.
		</p>
		<br/>

		<p><strong>3) Quais os objetivos da BDPI?</strong></p>
		<p style="margin-left:5%;">
		- Aumentar a visibilidade, acessibilidade e difusão dos resultados da atividade acadêmica e de pesquisa da USP por meio da coleta, organização e preservação em longo prazo;<br/>
        - Facilitar a gestão e o acesso à informação sobre a produção intelectual da USP, por meio da oferta de indicadores confiáveis e validados;<br/>
        - Integrar-se a um conjunto de iniciativas nacionais e internacionais, por meio de padrões e protocolos de integração qualificados e normalizados.
		</p>
		<br/>
		
		<p><strong>4) Como foi desenvolvida a BDPI?</strong></p>
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
		
		<p><strong>5) Como está organizada a BDPI?</strong></p>
		<p style="margin-left:5%;">
		A BDPI está organizada pelas unidades USP ligadas aos seus respectivos departamentos e nestes suas coleções.
		</p>
		<br/>
		
		<p><strong>6) Que tipo de documento posso encontrar na BDPI?</strong></p>
		<p style="margin-left:5%;">
		A BDPI apresenta os tipos de documentos: Artigos e Materiais de Revistas Científicas, Livros e Capítulos de Livros e Comunicações em Eventos.
		</p>
		<br/>
		
		<p><strong>7) Quais direitos de autor estão associados aos documentos submetidos na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Os autores devem conceder à Instituição uma licença Não-Exclusiva para arquivar e tornar acessível, nomeadamente através da BDPI, os seus documentos em formato digital. 
		Com a concessão da licença não-exclusiva para arquivar e dar acesso ao seu trabalho, os docentes e pesquisadores continuam a reter todos os seus direitos de autor.
		</p>
		<br/>
		
		<p><strong>8) Quem pode depositar documentos na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Docentes, servidores técnicos e pós-graduandos da USP poderão depositar a respectiva produção intelectual.
		</p>
		<br/>
		
		<p><strong>9) Quais os benefícios do autor ao tornar disponível? </strong></p>
		<p style="margin-left:5%;">
		Os autores que depositam sua produção científica na BDPI desfrutam de benefícios como: preservação digital, segurança da informação, 
		gestão de direitos e de acesso contribuindo para o aumento de visibilidade e aumento do impacto dos resultados de suas pesquisas.
		</p>
		<br/>
		
		<p><strong>10) Documentos de Autor USP em parceria com outros autores poderão ser cadastrado na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Sim, desde que exista pelo menos um autor USP, os outros podem ser de Instituições Externas. As afiliações dos autores externos é dada no artigo.
		</p>
		<br/>
		
		<p><strong>11) O que é “Acesso aberto”?</strong></p>
		<p style="margin-left:5%;">
		Entende-se por movimento de acesso aberto a “literatura científica disposta online livre de restrições de direito autoral, licenças de uso e custos,” 
		pesquisadores estão engajados cada vez mais em torno desse movimento e procuram depositar sua produção intelectual em repositórios livres. 
		O acesso aberto permite que o texto integral dos documentos seja lido, descarregado (download), distribuído, impresso, pesquisado ou referenciado (link).<br/>
		Leia mais: <a href="http://oa.mpg.de/lang/en-uk/berlin-prozess/berliner-erklarung/" target="_blank">Berlin Declaration</a>, 
		<a href="http://legacy.earlham.edu/~peters/fos/bethesda.htm" target="_blank">Bethesda Declaration</a>, 
		<a href="http://www.budapestopenaccessinitiative.org/" target="_blank">Budapest Declaration</a>.
		</p>
		<br/>
		
		<p><strong>12) Como é o uso da Licença Creative Common (CC) na BDPI-USP?</strong></p>
		<p style="margin-left:5%;">
		Na submissão, o autor poderá escolher as seguintes Licenças Creative Common:<br/>
		<strong>CC BY</strong> – Atribuição (BY): Os licenciados têm o direito de copiar, distribuir, exibir e executar a obra e fazer trabalhos derivados dela, desde que os créditos sejam dados ao autor ou licenciador, na maneira especificada por estes;<br/>
		<strong>CC BY-NC</strong> – Uso não Comercial (NC): Os licenciados podem copiar, distribuir, exibir e executar a obra e fazer trabalhos derivados dela, desde que sejam para fins <u>não-comerciais</u>;<br/>
		<strong>CC BY-SA</strong> – Share Alike (SA) : Os licenciados devem distribuir obras derivadas somente sob uma licença idêntica à que governa a obra original;<br/>
		<strong>CC BY-NC-AS</strong> - Share Alike (SA) : Os licenciados devem distribuir obras derivadas somente sob uma licença idêntica à que governa a obra original, desde que sejam para fins <u>não-comerciais</u>.
		</p>
		<br/>

		<p><strong>13) O que é copyright?</strong></p>
		<p style="margin-left:5%;">
		Copyright é uma forma de direito intelectual, significa, literalmente, "direito de cópia", é um direito legal que concede ao autor de trabalhos originais 
		direitos exclusivos de exploração de uma obra artística, literária ou científica, proibindo a reprodução por qualquer meio. 
		Ele impede a cópia ou exploração de uma obra sem que haja permissão. O símbolo do copyright © presente em uma obra restringe a sua impressão sem autorização prévia, 
		impedindo que haja benefícios financeiros para outros que não sejam o autor ou o editor da obra.
		</p>
		<br/>
		
		<p><strong>14) O que é Dspace?</strong></p>
		<p style="margin-left:5%;">
		DSpace é um software aberto para uso em instituições acadêmicas sem fins lucrativos, usado para construção de repositórios digitais abertos. É gratuito, 
		fácil de instalar e personalizar para atender às necessidades de qualquer organização. Consulte: <a href="http://www.dspace.org/" target="_blank">http://www.dspace.org/</a>
		</p>
		<br/>
		
		<p><strong>15) O que são metadados?</strong></p>
		<p style="margin-left:5%;">
		Conjunto de elementos com semântica padronizada, que possibilitam representar as informações eletrônicas e descrever recursos eletrônicos de maneira bibliográfica.
		Devido a sua característica de aplicação na área bibliográfica e a simplicidade de uso, o formato de metadados eleito para utilização do DSpace é o padrão Dublin Core (DC). É uma versão qualificada, que possui 15 elementos básicos e mais 35 elementos de refinamento. O DC objetiva colocar dados necessários para descrever, identificar, processar, localizar e recuperar documentos disponíveis na Internet.
		</p>
		<br/>
		
		<p><strong>16) O que é auto-arquivamento? Qual o objetivo?</strong></p>
		<p style="margin-left:5%;">
		Auto-arquivar (<em>self-archive</em>) significa depositar um documento digital em um site público da web compilado para o protocolo Open Archive Initiative (OAI).
		O auto-arquivamento não restringe o ato de depositar um documento exclusivamente ao autor do texto eletrônico, mas admite igualmente a submissão por terceiros, desde que autorizada pelo autor.<br/>
		O objetivo é gerar visibilidade e acesso aos trabalhos de pesquisas desenvolvidos, aumentando as possibilidades de ser citado e conhecido amplamente. Além disso, minimizar radicalmente as barreiras impostas nos sistemas tradicionais de publicação.
		</p>
		<br/>
		
		<p><strong>17) Auto-aquivar é o mesmo que publicar?</strong></p>
		<p style="margin-left:5%;">
		Não. A diferença entre auto-publicação (<em>vanity press</em>) e auto-arquivamento (<em>refereed research</em>) e que neste último, o fato de tornar público um texto científico em arquivo aberto, não significa que se tratar de uma publicação. 
		No entanto, o fato do artigo ter obtido uma boa apreciação entre os pares é suficiente para ser contado com publicação. A distinção no meio científico é, portanto, a qualidade do trabalho e para isso necessita de validação de um grupo de especialistas. 
		Contudo auto-arquivar é um excelente forma para estabelecer prioridades e afirmar direitos autorais.
		</p>
		<br/>
		
		<p><strong>18) O que é a Open Archives Initiative (OAI)? </strong></p>
		<p style="margin-left:5%;">
		Lançada em 1999, com o objetivo de criar uma plataforma simples para permitir a interoperabilidade e a pesquisa de publicações científicas de diversas disciplinas. Essa iniciativa surgiu dentro da comunidade dos eprints e partiu de uma abordagem essencialmente técnica, resultando no protocolo OAI-PMH.<br/> 
		<a href="http://www.openarchives.org/" target="_blank">Open Archives Initiative (OAI)</a> desenvolveu um código partilhado para tags de metadados (ex: “date”, “author”, “title”, “journal”, etc.). Ver as <a href="http://www.openarchives.org/documents/FAQ.html" target="_blank">FAq's OAI</a>. 
		Os textos completos dos documentos podem estar em diferentes formatos e localizações, mas se usarem as mesmas tags de metadados tornam-se interoperáveis. Os seus metadados podem ser colhidos (<em>harvesting</em>) e todos os documentos podem, então, ser procurados conjuntamente e recuperados como se estivessem todos numa coleção global, acessível a todos. 
		<a href="http://www.scielo.br/scielo.php?script=sci_arttext&amp;pid=S0100-19652006000200010&amp;lng=en&amp;nrm=iso&amp;tlng=pt#fig02" target="_blank">Veja a figura</a>. 
		</p>
		<br/>
		
		<p><strong>19) O que é OAI-compliance?</strong></p>
		<p style="margin-left:5%;">
		Consiste no uso das tags de metadados OAI. Repositório e documento pode ser OAI-compliant, assim, tornam-se interoperáveis significando que os documentos distribuídos podem ser tratados como se estivessem todos no mesmo lugar e com o mesmo formato. 
		</p>
		<br/>
				
		<p><strong>20) Bibliotecários serão responsáveis pela correção dos artigos submetidos por docentes? </strong></p>
		<p style="margin-left:5%;">
		Sim. O técnico e/ou bibliotecário necessitam complementar os dados na etapa de revisão. A validação/publicação do registro é de responsabilidade do bibliotecário.
		</p>
		<br/>
		
		<p><strong>21) Em caso de submissão de artigos disponíveis em dois idiomas (português e inglês) os dois arquivos poderão ser disponibilizados?</strong></p>
		<p style="margin-left:5%;">
		Sim, os dois arquivos poderão ser anexados.
		</p>
		<br/>
		
		<p><strong>22) O que é um item?</strong></p>
		<p style="margin-left:5%;">
		É o documento individualmente considerado que compõe uma coleção. Para cada item deve haver um conjunto  de metadados correspondentes.
		</p>
		<br/>
		
		<p><strong>23) Submeti um documento, mas este não aparece na coleção respectiva. Por quê?</strong></p>
		<p style="margin-left:5%;">
		Porque o artigo poder  está na fase de revisão ou publicação. <br/>
		Outra possibilidade é que o artigo tenha sido inserido apenas na comunidade de um autor. Documentos entre autores USP de diferentes unidades/departamentos serão mapeados 
		(associar o item da coleção “origem” à coleção “destino” para fins estatísticos e recuperação da informação) pela Equipe da BDPI do Departamento Técnico do Sistema Integrado de Bibliotecas da USP.
		</p>
		<br/>
		
		<p><strong>24) Existe data de publicação inicial a partir da qual devem ser depositados os documentos na BDPI-USP? </strong></p>
		<p style="margin-left:5%;">
		Sim, poderão ser inseridos documentos referentes ao ano de 2013 em diante. Lembrando que antes de submeter qualquer registro, o depositante deverá pesquisar na BDPI para verificar se o registro já foi indexado anteriormente.
		</p>
		<br/>
		
		<p><strong>25) Quem tem acesso aos documentos depositados na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Os documentos depositados, em sua maioria, tem acesso aberto a qualquer interessado. Na BDPI temos os seguintes tipos de acesso: <br/>
		- acesso fechado: o usuário não tem acesso ao documento;<br/>
		- restritos ao IP USP: apenas a comunidade USP tem acesso ao documento;<br/>
		- embargado, utilizado para documentos protegidos por um período determinado de tempo, decorrido o prazo o acesso é automático.
		</p>
		<br/>
		
		<p><strong>26) Deixei um item em processo de depósito sem finalizar. E agora?</strong></p>
		<p style="margin-left:5%;">
		O formulário de depósito da BDPI permite que o depositante interrompa o processo de submissão, salvando o registro para retornar mais tarde.
		</p>
		<br/>
		
		<p><strong>27) O que são “pré print”, “pós print” e “versão publicada”?</strong></p>
		<p style="margin-left:5%;">
		- Pré-print (preprint): refere-se a um artigo ainda não publicado<br/>
		- Pós-print (posprint): refere-se a um artigo que foi aceito em um periódico com revisão por pares<br/>
		- Published Version (versão publicada): refere-se a um artigo que foi aceito e publicado em um periódico com revisão por pares.
		</p>
		<br/>
		
		<p><strong>28) Se publicar meu artigo na BDPI, perco os meus direitos de autor?</strong></p>
		<p style="margin-left:5%;">
		Os autores devem conceder à Instituição uma licença Não-Exclusiva para arquivar e tornar acessível pela BDPI, os seus documentos em formato digital. 
		Com a concessão desta licença não-exclusiva para arquivar e dar acesso ao seu trabalho, os docentes e investigadores continuam a reter todos os seus direitos de autor.
		</p>
		<br/>		
		
		<p><strong>29) A Política da BDPI autoriza disponibilização de artigos restritos?</strong></p>
		<p style="margin-left:5%;">
		Não. Artigos restritos tem o acesso ao documento na íntegra proibido (documentos sob copyright).
		</p>
		<br/>
		
		<p><strong>30) Produção intelectual oriundas de bases de dados de acesso restrito e assinadas pela USP podem ser disponibilizadas na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Sim, porém o acesso ao texto completo será restrito ao IP USP.
		</p>
		<br/>
		
		<p><strong>31) Posso publicar um artigo numa revista e ao mesmo tempo na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Sim, a publicação do artigo na BDPI, apenas aumenta a visibilidade, acessibilidade, difusão e preservação do mesmo. Contudo, o autor do artigo precisa pertencer à comunidade USP.
		</p>
		<br/>
		
		<p><strong>32) Como se dá a alteração de status para artigos embargados?</strong></p>
		<p style="margin-left:5%;">
		Decorrido o prazo de proteção ao documento pelo período determinado de tempo, a alteração de status se dá automaticamente.
		</p>
		<br/>
		
		<p><strong>33) A minha dissertação de mestrado foi publicada por uma editora que a colocou no circuito comercial. Posso publicá-la também na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Sim, desde que o livro contenha a informação de que a obra ou parte dela poderá ser reproduzida em meio digital ou solicitada autorização prévia e por escrito do Editor.
		</p>
		<br/>

		<p><strong>34) Artigo originário de tese recebe o link da tese?</strong></p>
		<p style="margin-left:5%;">
		Sim, o link da tese poderá ser disponibilizado no campo URL.
		</p>
		<br/>
		
		<p><strong>35) Por que motivo uma editora ou o publicador de uma revista permite a publicação de artigos em acesso aberto?</strong></p>
		<p style="margin-left:5%;">
		Pelo fato de que editora ou publicador integram o movimento de acesso livre ao conhecimento científico que, atualmente integra vários países, entre os quais o 
		Brasil por parte dos pesquisadores, agências de fomento à pesquisa, editores de revistas científicas, pelo governo e adoção de políticas nacionais de distribuição de 
		softwares gratuitos de editoração de revistas eletrônicas.
		</p>
		<br/>
		
		<p><strong>36) Artigos na versão revisada pré-print poderão ser inseridos na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Sim, pré-print podem ser inseridos na BDPI.
		</p>
		<br/>
		
		<p><strong>37) E se o editor proibir o auto-arquivo do pré-print?</strong></p>
		<p style="margin-left:5%;">
		O pré-print é auto-arquivado na fase em que ainda não existe nenhum acordo de transferência de copyright e o autor detém o direito exclusivo. 
		</p>
		<br/>
		
		<p><strong>38) Artigos em versão revisada por pares poderão ser inseridos na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Sim, artigos revisados por pares podem ser disponibilizados na BDPI. Assim como pós- print e a versão publicada.
		</p>
		<br/>
		
		<p><strong>39) Como é realizado o acesso à BDPI?</strong></p>
		<p style="margin-left:5%;">
		O acesso à BDPI é feito pelo número USP e a mesma senha utilizada pela comunidade nos sistemas USP.
		</p>
		<br/>
		
		<p><strong>40) Como encontrar a informação desejada na BDPI?</strong></p>
		<p style="margin-left:5%;">
		A BDPI dispõe de “Busca” e “Busca avançada” para recuperação da informação. O usuário poderá ter acesso aos documentos pelo autor, título do documento, assunto, revista, agência de fomento. 
		Documentos de acesso restrito ao IP USP poderão ser recuperados pelos computadores existentes nas bibliotecas da USP ou acesso VPN.
		</p>
		<br/>
		
		<p><strong>41) Posso enviar os resultados de pesquisa na BDPI por e-mail?</strong></p>
		<p style="margin-left:5%;">
		Os resultados de buscas feitas nas opções de “Busca” ou “Busca Avançada” não poderão ser salvos e encaminhados por e-mail para utilização posterior. 
		</p>
		<br/>
		
		<p><strong>42) O que é preservação digital?</strong></p>
		<p style="margin-left:5%;">
		Emprego de mecanismos que permitem o armazenamento em repositórios de objetos digitais e que garantem a perenidade dos seus conteúdos. Compreende o planejamento, a alocação de recursos e a 
		aplicação de métodos e tecnologias para assegurar que a informação digital de valor contínuo permaneça acessível e utilizável.
		</p>
		<br/>
		
		<p><strong>43) A quem encaminho dúvidas sobre submissão da produção, sobre a BDPI em geral?</strong></p>
		<p style="margin-left:5%;">
		Caso ocorra algum problema com a submissão do item ou outra particularidade, o usuário poderá entrar em contato com o 
		Departamento Técnico do Sistema Integrado de Bibliotecas (DT/SIBi) pelo e-mail: <a href="atendimento@sibi.usp.br">atendimento@sibi.usp.br</a>
		</p>
		<br/>
		
		<p><strong>44) Livros de autores USP que não sejam de acesso aberto poderão ser inseridos na BDPI?</strong></p>
		<p style="margin-left:5%;">
		Sim, poderão ser colocados os arquivos de capa, sumário e resenha (caso exista) em “Arquivos do item”.
		</p>
		<br/>
		
         </div>
                    </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
                </div>
				
				</dspace:layout>