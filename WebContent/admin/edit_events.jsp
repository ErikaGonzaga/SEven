<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="br.ufc.pet.entity.Evento" %>
<%@page import=" br.ufc.pet.util.UtilSeven" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../ErroAutenticacaoUser.jsp" %>

<%

            Evento evento = (Evento) session.getAttribute("evento");
            session.removeAttribute("evento");
            String men = (String) session.getAttribute("men");
            session.removeAttribute("men");
            String comando = "Alterar";

            String sigla = (String)session.getAttribute("siglaEvento");
            session.removeAttribute("siglaEvento");
            if(sigla==null)
                sigla="";

            String nome = (String)session.getAttribute("nomeEvento");
            session.removeAttribute("nomeEvento");
            if(nome==null)
                nome="";

            String tema = (String)session.getAttribute("tema");
            session.removeAttribute("tema");
            if(tema == null)
                tema="";
 
            String inicioIn = (String)session.getAttribute("inicioInscricao");
            session.removeAttribute("inicioInscricao");
            if(inicioIn == null)
                inicioIn="";

            String fimIn = (String)session.getAttribute("fimInscricao");
            session.removeAttribute("fimInscricao");
            if(fimIn == null)
                fimIn="";

            String descricao = (String)session.getAttribute("descricao");
            session.removeAttribute("descricao");
            if(descricao == null)
                descricao="";

            String limiteDeAtividadesPorParticipante = (String)session.getAttribute("limiteDeAtividadesPorParticipante");
            session.removeAttribute("limiteDeAtividadesPorParticipante");
            if(limiteDeAtividadesPorParticipante == null)
                limiteDeAtividadesPorParticipante="";

            String inicioEvento = (String)session.getAttribute("inicioEvento");
            session.removeAttribute("inicioEvento");
            
            String gratis = (String)session.getAttribute("gratuito");
            int flag = 0;
            if(gratis == null)
                gratis = "";
            if(gratis.equals("true")){
                flag = 1;
                pageContext.setAttribute("gratuit", flag);
            }else{
                pageContext.setAttribute("gratuit", flag); 
            }
            
            if(inicioEvento == null)
                inicioEvento="";
            
            String fimEvento = (String)session.getAttribute("fimEvento");
            session.removeAttribute("fimEvento");
            if(fimEvento == null)
                fimEvento="";

            if (evento != null) {
                comando = "Alterar";
                sigla = evento.getSigla();
                nome = evento.getNome();
                tema = evento.getTema();
                
                inicioIn = UtilSeven.treatToString(evento.getInicioPeriodoInscricao());
                fimIn = UtilSeven.treatToString(evento.getFimPeriodoInscricao());
                limiteDeAtividadesPorParticipante = evento.getLimiteAtividadePorParticipante()+"";
                descricao = evento.getDescricao();
                inicioEvento = UtilSeven.treatToString(evento.getInicioPeriodoEvento());
                fimEvento = UtilSeven.treatToString(evento.getFimPeriodoEvento());
                
            }
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link href="../css/estilo.css" rel="stylesheet" type="text/css" />
        <link rel="shortcut icon" href="../imagens/favicon.png" type="image/x-icon"/>
        <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="../css/ripples.min.css" />
        <link rel="stylesheet" href="../css/bootstrap-material-datetimepicker.css" />
        <link href='http://fonts.googleapis.com/css?family=Roboto:400,500' rel='stylesheet' type='text/css' />
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
        <title>SEven</title>
        <script language="javascript" src="../jquery/jquery-1.10.2.js"></script>
        <script language="javascript" src="../jquery/jquery-ui-1.10.4.custom.min.js"></script>
        <script src="../bootstrap/js/bootstrap.min.js"></script>
        <script src="../js/ripples.min.js"></script>
        <script src="../js/material.min.js"></script>
        <script type="text/javascript" src="../js/moment-with-locales.min.js"></script>
	<script type="text/javascript" src="../js/bootstrap-material-datetimepicker.js"></script>
	<script type="text/javascript" src="../js/datetimepicker.js"></script>
        <script type="text/javascript" src="../Script.js"> </script>               
    </head>
    <body>

        <div id="container-admin-add-event">

                <%-- Incluindo o Menu --%>
                <%@include file="admin_menu.jsp" %>
          
           
                <h1 class="title-register"> <%=comando%> Evento</h1><hr>
                <%if (men != null) {%>
                <div class="alert alert-danger text-center" role="alert"><%=men%></div>
                <%}%>
                 <%@include file="/error.jsp" %>
                <form action="../ServletCentral?comando=CmdAdicionarEvento&operacao_evento=<%=evento == null ? 0 : evento.getId()%>" method="post">
                   <div class="row">
                      <div class = "col-md-offset-2 col-lg-8">
                             <div class="form-group">
                                <label for="text_a">Nome do Evento</label>
                                <input data-toggle="tooltip" title="Nome do Evento" class="form-control" type="text" name="nome_evento" placeholder="Nome" value="<%=nome%>" />
                             </div>
                        <div class="row">
                          <div class = "col-lg-2">      
                            <div class="form-group">
                            <label for="text_a">Sigla</label>
                                <input data-toggle="tooltip" title="Sigla do Evento" class="form-control" type="text" name="sigla_evento" placeholder="Sigla" value="<%=sigla%>" />
                             </div>
                          </div>   
                            <div class = "col-lg-6">       
                              <div class="form-group">
                                <label for="text_a">Tema do Evento</label>
                                <input data-toggle="tooltip" title="Tema do Evento" class="form-control" type="text" name="tema_evento" placeholder="Tema" value="<%=tema%>" />
                             </div>
                            </div>
                           <div class = "col-lg-4"> 
                              <c:set var = "est"  scope="page" value ="${gratuit}"/>
                              <label>O evento é gratuito?</label><br />
                              <c:if test = "${est == 1}">
                                   <label class="radio-inline">
                                    <input type="radio"  name="gratuito" value="true" id="inlineRadio1" checked/> Sim
                                   </label>
                                   <label class="radio-inline">
                                    <input type="radio"  name="gratuito" value="false" id="inlineRadio2" /> Não
                              </label>    
                              </c:if>
                              <c:if test = "${est == 0}">
                                    <label class="radio-inline">
                                    <input type="radio"  name="gratuito" value="true" id="inlineRadio1"/> Sim
                                    </label>
                                    <label class="radio-inline">
                                    <input type="radio"  name="gratuito" value="false" id="inlineRadio2" checked/> Não
                               </label> 
                              </c:if>
                         
                          </div> 
                        </div> 
                      <div class="row">     
                         <div class = "col-lg-3">    
                           <div class="form-group">
                             <label for="text_a">Data do Início do Evento</label>                           
                                 <input type="text" id="date-start-event" name="inicio_evento" value="<%=inicioEvento%>" class="form-control" data-toggle="tooltip" title="Data de Início do Evento" placeholder="Início do evento"/>
                                 <!--<input data-toggle="tooltip" title="Data de Início do Evento" class="form-control" type="text" id="data_initial" name="inicio_evento" placeholder="Inicio do evento" maxlength="10" value="<%=inicioEvento%>" onkeypress="return formataData(this,event)"/>-->
                           </div>
                         </div>  
                         <div class = "col-lg-3">       
                            <div class="form-group">
                               <label for="text_a">Data Final do Evento</label>
                                    <input type="hidden" name="fim_evento_hidden" value="<%=fimEvento%>"/> 
                                    <input type="text" id="date-end-event" name="fim_evento" value="<%=fimEvento%>" class="form-control" data-toggle="tooltip" title="Data de Fim do Evento" placeholder="Fim do evento"/>
                                <!--<input data-toggle="tooltip" title="Data de Fim do Evento" class="form-control" id="data_finish" type="text" name="fim_evento" placeholder="Fim do evento " maxlength="10" value="<%=fimEvento%>" onkeypress="return formataData(this,event)"/>-->
                             </div>
                         </div> 
                         <div class = "col-lg-3">       
                            <div class="form-group">
                                <label for="text_a">Início das Incrições</label>
                                    <input type="hidden" name="inicio_periodo_inscricao_hidden" value="<%=inicioIn%>"/> 
                                    <input type="text" id="date-start-in" name="inicio_periodo_inscricao" value="<%=inicioIn%>" class="form-control" data-toggle="tooltip" title="Data de Início das Inscrições" placeholder="Início das inscrição"/>
                                <!--<input data-toggle="tooltip" title="Data de Início das Inscrições" class="form-control" id="data_initial_pi" type="text" name="inicio_periodo_inscricao" placeholder="Inicio do periodo de inscrição" maxlength="10" value="<%=inicioIn%>" onkeypress="return formataData(this,event)"/>-->
                             </div>
                         </div>
                         <div class = "col-lg-3">       
                            <div class="form-group">
                                <label for="text_a">Final das Incrições</label> 
                                    <input type="hidden" name="fim_periodo_inscricao_hidden" value="<%=fimIn%>"/> 
                                    <input type="text" id="date-end-in" name="fim_periodo_inscricao" value="<%=fimIn%>" class="form-control" data-toggle="tooltip" title="Data de Fim das Inscrições" placeholder="Fim das inscrição"/>
                                <!--<input data-toggle="tooltip" title="Data de Fim das Inscrições" class="form-control" id="data_finish_pi" type="text" name="fim_periodo_inscricao" placeholder="Fim do periodo de inscrição" maxlength="10" value="<%=fimIn%>" onkeypress="return formataData(this,event)"/>-->
                             </div>
                         </div> 
                      </div>      
                       <div class="form-group">
                             <input data-toggle="tooltip" title="Limite de Atividades por Participante" class="form-control" id="max_at" type="hidden" name="limite_de_atividades_por_participante" value="<%=limiteDeAtividadesPorParticipante%>" onkeypress="return validaNumerosSilencioso(event)"/> 
                            <!--<label for="text_a">Limite de Atividades por Participante</label> 
                              <input data-toggle="tooltip" title="Limite de Atividades por Participante" class="form-control" id="max_at" type="text" name="limite_de_atividades_por_participante" placeholder="Atividades por participante"  value="<%=limiteDeAtividadesPorParticipante%>" onkeypress="return validaNumerosSilencioso(event)"/>
                              <label for="max_at"><span class="label label-warning text-uppercase">Digite 0 (zero) para ilimitado</span></label>
                             -->
                       </div>                    
                      
                       <div class="form-group">
                             <label for="text_a">Descrição</label>
                             <textarea data-toggle="tooltip" title="Descrição Geral do Evento" id="text_a" class="form-control" cols="1" rows="4" name="descricao"><%=descricao%></textarea>  
                       </div>                                                                      
                   
                       <div class="text-center">  
                           <a href="javascript:history.back();" class="btn btn-default"><span aria-hidden="true">&larr;</span> Voltar</a>
                           <button data-toggle="tooltip" title="Alterar" type="submit" class="btn btn-default" onclick="return confirmarCadastrado()">Alterar</button>
                      </div> 
                    </div>
                  </div>        
                </form>
             </div>
        <%@include file="../footer.jsp"%>
    </body>
</html>
