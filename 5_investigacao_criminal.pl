% Base de Conhecimento

% Regras de suspeitos com base em evidências
suspeito('Jose') :-
    impressao_digital(lugar_crime),
    motivo(financeiro).

suspeito('Maria') :-
    testemunha(visto_discutindo),
    relacao(intima).

suspeito('Carlos') :-
    alibi(falso),
    motivo(vinganca).

% Regras para teorias do crime
teoria('Crime Passional') :-
    testemunha(visto_discutindo),
    relacao(intima).

teoria('Crime Planejado') :-
    impressao_digital(lugar_crime),
    motivo(vinganca),
    alibi(falso).

% Perguntas de evidências
perguntar_crime(Pergunta, Fato) :-
    format('~w (s/n): ', [Pergunta]),
    read(Resposta), nl,
    (   Resposta = s -> assertz(Fato)  % Armazena o fato se a resposta for "s".
    ;   Resposta = n -> true           % Ignora se a resposta for "n".
    ;   write('Por favor, responda apenas com "s" ou "n".'), nl,
        perguntar_crime(Pergunta, Fato)).

% Programa principal
% Faz perguntas e sugere suspeitos ou teorias do crime.
analisar_caso :-
    limpa_respostas_crime,  % Garante que respostas anteriores nao interfiram.
    perguntar_crime('Foram encontradas impressoes digitais no lugar do crime?', impressao_digital(lugar_crime)),
    perguntar_crime('Existe algum motivo financeiro relacionado ao caso?', motivo(financeiro)),
    perguntar_crime('Uma testemunha viu uma discussao entre vitima e suspeito?', testemunha(visto_discutindo)),
    perguntar_crime('Ha uma relacao intima entre a vitima e o suspeito?', relacao(intima)),
    perguntar_crime('Algum suspeito apresentou um alibi falso?', alibi(falso)),
    perguntar_crime('Ha evidencias de motivo de vinganca?', motivo(vinganca)),
    (   suspeito(Suspeito),
        format('Suspeito identificado: ~w~n', [Suspeito]),
        fail  % Permite listar todos os suspeitos possíveis.
    ;   teoria(Teoria),
        format('Teoria do crime sugerida: ~w~n', [Teoria]),
        fail
    ;   write('Nao foi possivel identificar suspeitos ou teorias com base nas evidencias fornecidas.~n') ),
    limpa_respostas_crime.  % Limpa os dados apos a execucao.

% Limpeza de fatos temporarios
limpa_respostas_crime :-
    retractall(impressao_digital(_)),
    retractall(motivo(_)),
    retractall(testemunha(_)),
    retractall(relacao(_)),
    retractall(alibi(_)).
