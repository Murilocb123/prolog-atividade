% Base de Conhecimento

% Fatos: sintomas e problemas possíveis no veículo.
sintoma(motor_nao_liga).
sintoma(luzes_fracas).
sintoma(barulho_ao_frear).
sintoma(pedal_freio_macio).
sintoma(vazamento_oleo).
sintoma(cheiro_combustivel).
sintoma(aquecimento_motor).

% Regras de diagnóstico para identificar problemas comuns com base nos sintomas relatados.
problema(bateria_fraca) :-
    verifica(motor_nao_liga),
    verifica(luzes_fracas).

problema(freio_desgastado) :-
    verifica(barulho_ao_frear),
    verifica(pedal_freio_macio).

problema(vazamento_no_motor) :-
    verifica(vazamento_oleo),
    verifica(cheiro_combustivel).

problema(sobreaquecimento) :-
    verifica(aquecimento_motor),
    \+ verifica(vazamento_oleo). % Exemplo de uso da negação (ausência de vazamento de óleo)

% Diagnóstico genérico caso nenhum problema conhecido seja identificado.
problema(desconhecido) :-

    \+ problema(_). % Nenhuma das condições anteriores foi atendida.

% Regras auxiliares
% Pergunta ao usuário se um determinado sintoma está presente e armazena a resposta.
verifica(Sintoma) :-
    (   ja_sabe(Sintoma) -> true  % Verifica se já sabemos a resposta para o sintoma.
    ;   format('O veiculo apresenta o seguinte problema: ~w? (s/n): ', [Sintoma]),
        read(Resposta), nl,
        (   Resposta = s -> assertz(ja_sabe(Sintoma))  % Armazena a resposta positiva.
        ;   assertz(nao_sabe(Sintoma)), fail)).        % Armazena a resposta negativa.

% Limpa os fatos temporários após a execução.
limpa_respostas :-
    retractall(ja_sabe(_)),
    retractall(nao_sabe(_)).

% Programa principal
% Faz perguntas ao usuário, identifica o problema e sugere ações.
analise :-
    limpa_respostas,  % Limpa respostas anteriores.
    (   problema(Problema), Problema \= desconhecido ->
        % Sugere solução com base no problema identificado.
        (   Problema = bateria_fraca -> write('Sugestao: Verifique a bateria e os cabos de conexão.~n');
            Problema = freio_desgastado -> write('Sugestao: Leve o veiculo a um mecânico para revisar os freios.~n');
            Problema = vazamento_no_motor -> write('Sugestao: Verifique o motor e procure vazamentos visiveis.~n');
            Problema = sobreaquecimento -> write('Sugestao: Verifique o nivel do liquido de arrefecimento.~n')),
        format('O problema mais provavel e: ~w.~n', [Problema])
    ;   write('Nao foi possível identificar o problema. Leve o veículo a um mecânico para uma inspeção detalhada.~n') ),
    limpa_respostas. % Limpa novamente após a execução.
