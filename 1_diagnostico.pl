% Base de Conhecimento

% Definição de sintomas como fatos. O usuário irá confirmar ou negar esses sintomas durante a execução.
sintoma(febre).
sintoma(tosse).
sintoma(dor_de_cabeca).
sintoma(cansaco).
sintoma(dor_de_garganta).
sintoma(dor_muscular).

% Regras para diagnósticos com base nos sintomas informados.
doenca(gripe) :-
    verifica(febre),
    verifica(tosse),
    verifica(cansaco).

doenca(infeccao_viral) :-
    verifica(febre),
    verifica(dor_de_garganta),
    verifica(dor_muscular).

doenca(enxaqueca) :-
    verifica(dor_de_cabeca),
    \+ verifica(febre). % Exemplo de uso da negação (ausência de febre)

% Diagnóstico genérico caso nenhum outro seja identificado.
doenca(desconhecida) :-
    \+ doenca(_). % Nenhuma das condições anteriores foi atendida.

% Regras auxiliares
% Essa regra interage com o usuário para perguntar sobre os sintomas e armazenar as respostas.
verifica(Sintoma) :-
    (   ja_sabe(Sintoma) -> true  % Se já sabemos a resposta para o sintoma, não pergunta novamente.
    ;   format('Voce esta com ~w? (s/n): ', [Sintoma]), % Pergunta ao usuário.
        read(Resposta), nl,
        (   Resposta = s -> assertz(ja_sabe(Sintoma))  % Armazena como fato se a resposta for sim.
        ;   assertz(nao_sabe(Sintoma)), fail)).        % Armazena a negação como fato, se for não.

% Limpa os fatos temporários após a execução do sistema.
limpa_respostas :-
    retractall(ja_sabe(_)),
    retractall(nao_sabe(_)).

% Programa principal
% Faz perguntas, identifica a doença e dá uma recomendação.
diagnostico :-
    limpa_respostas,  % Garante que as respostas anteriores não interfiram.
    (   doenca(Doenca), Doenca \= desconhecida -> 
        format('O diagnostico mais provavel é: ~w.~n', [Doenca])
    ;   write('Nao foi possível identificar a condição. Consulte um médico para mais detalhes.~n') ),
    limpa_respostas. % Limpa novamente após a conclusão.