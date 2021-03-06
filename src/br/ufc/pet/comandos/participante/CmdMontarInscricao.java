package br.ufc.pet.comandos.participante;

import br.ufc.pet.entity.Atividade;
import br.ufc.pet.entity.Evento;
import br.ufc.pet.entity.Inscricao;
import br.ufc.pet.entity.ModalidadeInscricao;
import br.ufc.pet.entity.Participante;
import br.ufc.pet.interfaces.Comando;
import br.ufc.pet.services.InscricaoService;
import br.ufc.pet.services.ModalidadeInscricaoService;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 * @author Caio
 */
public class CmdMontarInscricao implements Comando {

    @Override
    public String executa(HttpServletRequest request, HttpServletResponse response) {

        HttpSession session = request.getSession();
        //montagem de um novo objeto inscricao
        Inscricao i = (Inscricao) session.getAttribute("inscricao");//caso de edição
        if (i == null) {
            i = new Inscricao();//caso nova inscrição
        }
        i.setEvento((Evento) session.getAttribute("eventoSelecionado"));
        i.setParticipante((Participante) session.getAttribute("user"));
        i.setDataRealizada(new Date());
        i.setDataPagamento(i.getEvento().getFimPeriodoInscricao());
        if (i.getAtividades() == null || i.getAtividades().isEmpty()) {//caso o participante nao selecione nenhuma atividade, é importante que esse array seja criado vazio
            session.setAttribute("erro", "Por favor, selecione alguma atividade.");
            return "/part/part_fazer_inscricao.jsp";
        }

        //checkagem de seleção do radio button de modalidade
        if (request.getParameter("tipo_inscricao") == null) {
            session.setAttribute("erro", "Por favor, após selecionar as atividades, certifique-se de marcar a opção modalidade antes de clicar em 'Inscrever-se'.");
            return "/part/part_fazer_inscricao.jsp";
        }

        //recupera do banco o objeto modalidade a partir da string do checkbox
        ModalidadeInscricaoService mis = new ModalidadeInscricaoService();
        ModalidadeInscricao m = mis.getModalidadeInscricaoById(Long.parseLong(request.getParameter("tipo_inscricao")));

        i.setModalidade(m);

        InscricaoService IS = new InscricaoService();
        //checkagem de unicidade da inscricao no evento por participante
        if (i.getId() == null) {//somente impede no caso de nova
            ArrayList<Inscricao> AI = IS.getAllInscricaoByParticipanteId(i.getParticipante().getId());
            for (Inscricao in : AI) {
                if (in.getEvento().getId().equals(i.getEvento().getId())) {//uma mensagem de erro é colocada na sessão para ser lida na proxima pagina
                    session.setAttribute("erro", "A inscrição não pôde ser realizada pois já consta um inscrição para seu usuario neste evento.");
                    return "/part/part_fazer_inscricao.jsp";
                }
            }
        }

        //teste de vagas
        if (i.getId() == null || i.getId() == 0L) {//caso de nova
            if (i.getAtividades() != null) {
                for (Atividade a : i.getAtividades()) {
                    try {
                        if (IS.getInscritosByAtividadeId(a.getId()) >= a.getVagas()) {//uma mensagem de erro é colocada na sessão para ser lida na proxima pagina
                            session.setAttribute("erro", "A inscrição não pôde ser realizada pois não há mais vagas na atividade " + a.getNome() + ".");
                            return "/part/part_fazer_inscricao.jsp";
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(CmdMontarInscricao.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        } else {//caso de edicao
            //teste de vagas com checagem de atividades anteriores
            ArrayList<Atividade> atividadesAnteriores = IS.getInscricaoById(i.getId()).getAtividades();
            if (i.getAtividades() != null) {//se houverem atividades
                for (Atividade a : i.getAtividades()) {//para cada atividade atual
                    try {
                        if (IS.getInscritosByAtividadeId(a.getId()) >= a.getVagas()) {//se ela estiver lotada
                            boolean vaga = false;//verifique se existe uma vaga reservada pela antiga inscricao
                            for (Atividade antiga : atividadesAnteriores) {//procure nas atividades anteriores
                                if (a.getId().equals(antiga.getId())) {//se estava nas anteriores
                                    vaga = true;
                                    break;
                                    //tudo bem, pois apesar de estar lotada uma das vagas já era a dele.
                                }
                            }
                            if (!vaga) {
                                //erro, pois foi acrescentada uma atividade que nao estava nas anteriores e ela está lotada.
                                session.setAttribute("erro", "A inscrição não pôde ser realizada pois não há mais vagas na atividade " + a.getNome() + ".");
                                return "/part/part_fazer_inscricao.jsp";
                            }
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(CmdMontarInscricao.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        }
        //coloca o objeto montado na sessão e vai pra confirmação
        session.setAttribute("inscricao", i);

        return "/part/part_confirmar_inscricao.jsp";
    }
}
