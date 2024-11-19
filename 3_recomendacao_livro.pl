% Base de Conhecimento

% Base de livros categorizados por genero e topicos de interesse.
livro('1984', ficcao, politica, 'Um romance distopico de George Orwell que explora os perigos de um governo totalitario.').
livro('Sapiens', historia, ciencia, 'Uma analise fascinante da historia da humanidade por Yuval Noah Harari.').
livro('O Pequeno Principe', ficcao, filosofia, 'Uma historia encantadora de Antoine de Saint-Exupery sobre amizade, amor e perda.').
livro('Pai Rico, Pai Pobre', autoajuda, financas, 'Um guia de Robert Kiyosaki sobre como alcancar a independencia financeira.').
livro('A Breve Historia do Tempo', ciencia, universo, 'Uma introducao as teorias do tempo e espaco por Stephen Hawking.').

% Regras para recomendar livros com base no genero e nos interesses do usuario.
recomendar(Titulo, Sinopse) :-
    livro(Titulo, Genero, Topico, Sinopse),
    verifica_genero(Genero),
    verifica_topico(Topico).

% Regras auxiliares para verificar os generos e interesses.
verifica_genero(Genero) :-
    (   ja_sabe_genero(Genero) -> true  % Se ja sabemos a preferencia de genero, usa essa informacao.
    ;   format('Voce gosta de livros do genero ~w? (s/n): ', [Genero]),
        read(Resposta), nl,
        (   Resposta = s -> assertz(ja_sabe_genero(Genero))  % Armazena a resposta como fato.
        ;   assertz(nao_sabe_genero(Genero)), fail)).

verifica_topico(Topico) :-
    (   ja_sabe_topico(Topico) -> true  % Se ja sabemos a preferencia de topico, usa essa informacao.
    ;   format('Voce tem interesse em livros sobre ~w? (s/n): ', [Topico]),
        read(Resposta), nl,
        (   Resposta = s -> assertz(ja_sabe_topico(Topico))  % Armazena a resposta como fato.
        ;   assertz(nao_sabe_topico(Topico)), fail)).

% Limpa as respostas do usuario ao final do processo.
limpa_respostas :-
    retractall(ja_sabe_genero(_)),
    retractall(nao_sabe_genero(_)),
    retractall(ja_sabe_topico(_)),
    retractall(nao_sabe_topico(_)).

% Programa principal
% Faz perguntas ao usuario, identifica preferencias e recomenda livros.
verificar_livros :-
    limpa_respostas,  % Garante que as respostas anteriores nao interfiram.
    (   recomendar(Titulo, Sinopse) ->
        format('Recomendacao: ~w~nSinopse: ~w~n', [Titulo, Sinopse]),
        fail  % Permite que o sistema continue recomendando outros livros que correspondam.
    ;   write('Nao foram encontradas mais recomendacoes com base em suas preferencias.~n') ),
    limpa_respostas.  % Limpa os dados ao final.
