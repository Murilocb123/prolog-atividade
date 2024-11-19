% Base de Conhecimento

% Base de treinos e exercicios especificos para diferentes objetivos e niveis de experiencia.
treino('Treino de Hipertrofia', 
       ['Supino reto: 4x10', 'Agachamento: 4x8', 'Remada curvada: 4x10', 'Rosca direta: 3x12']) :-
    objetivo(ganhar_massa),
    experiencia(intermediario).

treino('Treino para Iniciantes - Ganho de Massa', 
       ['Supino reto: 3x12', 'Agachamento: 3x12', 'Puxada aberta: 3x12', 'Rosca direta: 2x15']) :-
    objetivo(ganhar_massa),
    experiencia(iniciante).

treino('Treino de Perda de Peso com Tempo Limitado', 
       ['Circuito: Burpees (30s), Agachamento com salto (30s), Flexoes (30s)', 'Descanso: 1 min', 'Repetir: 4 rodadas']) :-
    objetivo(emagrecer),
    disponibilidade(tempo_limitado).

treino('Treino de Condicionamento Avancado', 
       ['Corrida intervalada: 6x (2 min rapido + 1 min descanso)', 'Levantamento terra: 4x8', 'Kettlebell swings: 4x12']) :-
    objetivo(condicionamento),
    experiencia(avancado).

% Regras auxiliares para fazer perguntas de sim ou nao.
perguntar(Pergunta, Fato) :-
    format('~w (s/n): ', [Pergunta]),
    read(Resposta), nl,
    (   Resposta = s -> assertz(Fato)  % Armazena o fato se a resposta for "s".
    ;   Resposta = n -> true           % Ignora se a resposta for "n".
    ;   write('Por favor, responda apenas com "s" ou "n".'), nl,
        perguntar(Pergunta, Fato)).

% Programa principal
% Faz perguntas, identifica o objetivo, experiencia e disponibilidade, e recomenda um treino.
verificar_treino :-
    limpa_respostas_treino,  % Garante que respostas anteriores nao interfiram.
    perguntar('Seu objetivo e ganhar massa?', objetivo(ganhar_massa)),
    perguntar('Seu objetivo e emagrecer?', objetivo(emagrecer)),
    perguntar('Seu objetivo e melhorar o condicionamento fisico?', objetivo(condicionamento)),
    perguntar('Seu nivel de experiencia e iniciante?', experiencia(iniciante)),
    perguntar('Seu nivel de experiencia e intermediario?', experiencia(intermediario)),
    perguntar('Seu nivel de experiencia e avancado?', experiencia(avancado)),
    perguntar('Voce tem tempo limitado para treinar?', disponibilidade(tempo_limitado)),
    perguntar('Voce tem tempo suficiente para treinar?', disponibilidade(tempo_suficiente)),
    (   treino(Nome, Exercicios),
        format('Treino recomendado: ~w~n', [Nome]),
        write('Exercicios:~n'),
        listar_exercicios(Exercicios), nl,
        fail  % Permite continuar listando outros treinos que correspondam.
    ;   write('Nao foi possivel encontrar um treino que atenda as suas preferencias.~n') ),
    limpa_respostas_treino.  % Limpa os dados apos a execucao.

% Funcao para exibir exercicios formatados.
listar_exercicios([]).
listar_exercicios([Exercicio | Resto]) :-
    format('- ~w~n', [Exercicio]),
    listar_exercicios(Resto).

% Limpeza de respostas do usuario.
limpa_respostas_treino :-
    retractall(objetivo(_)),
    retractall(experiencia(_)),
    retractall(disponibilidade(_)).
