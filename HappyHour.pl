:- use_module(library(plunit)).
:- use_module(library(clpfd)).

%% Feito por Marcos Vinicius Peres
%  ra94594

%% desafio(?Amigo1, ?Amigo2, ?Amigo3, ?Amigo4) is nondet
%
% Verdadeiro se Amigo1, Amigo2, Amigo3, Amigo4 são estruturas da forma amigo(N, B, C, I),
% onde N é um nome da pessoa, B é o nome de uma cerveja que a pessoa gosta, C é a quantidade de Chopes que a pessoa
% bebeu e I é a idade da pessoa, que atendem as restrições do seguinte problema de lógica:
%
% Quatro amigos se reuniram num pub após o trabalho para beber e jogar conversa fora. 
% Use a lógica e descubra o nome, a idade, a cerveja favorita e quantos chopes cada um deles bebeu.
% Mais alguns fatos sobre os quatros amigos:
%
% 1. O amigo de 25 anos bebeu menos chopes do que Hugo.
% 2. Mateus bebeu mais chopes do que o amigo que gosta da cerveja norte-americana.
% 3. Sobre os amigos que gostam de cerveja alema e de cerveja belga, 
%    um tem 27 anos e o outro é o Hugo, não necessariamente nessa ordem.
% 4. Aquele que gosta da cerveja norte-americana não tem 24 anos nem 31 anos.
% 5. O amigo que bebeu 3 chopes gosta da cerveja belga.
% 6. Paulo bebeu 3 chopes.
% 7. Quem gosta da cerveja alema é o Fabio ou o amigo de 24 anos.
% 8. O amigo que bebeu 4 chopes não tem 24 anos.

desafio(Amigo1, Amigo2, Amigo3, Amigo4) :- 
    
    % existe um HappyHour com quatro amigos.
    HappyHour = [Amigo1, Amigo2, Amigo3, Amigo4],
    
    Amigo1 = amigo(_, _, _, _), % Nome, Cerveja, Chopes, Idade
    Amigo2 = amigo(_, _, _, _),
    Amigo3 = amigo(_, _, _, _), 
    Amigo4 = amigo(_, _, _, _),

    % Nome dos amigos.
    member(amigo(fabio, _, _, _), HappyHour),
    member(amigo(hugo, _, _, _), HappyHour),
    member(amigo(mateus, _, _, _), HappyHour),
    member(amigo(paulo, _, _, _), HappyHour),

    % Cerveja que determinado amigo mais gosta.
    member(amigo(_, alema, _, _), HappyHour),
    member(amigo(_, belga, _, _), HappyHour),
    member(amigo(_, holandesa, _, _), HappyHour),
    member(amigo(_, norte-americana, _, _), HappyHour),

    % Quantidade de Chopes que cada amigo consumil.
    member(amigo(_, _, 2, _), HappyHour),
    member(amigo(_, _, 3, _), HappyHour),
    member(amigo(_, _, 4, _), HappyHour),
    member(amigo(_, _, 5, _), HappyHour),

    % Idade de cada amigo. 
    member(amigo(_, _, _, 24), HappyHour),
    member(amigo(_, _, _, 25), HappyHour),
    member(amigo(_, _, _, 27), HappyHour),
    member(amigo(_, _, _, 31), HappyHour),

    % 6. Paulo bebeu 3 chopes.
    member(amigo(paulo, _, 3, _), HappyHour),

    % 5. O amigo que bebeu 3 chopes gosta da cerveja belga
    member(amigo(_, belga, 3, _), HappyHour),

    % 8. O amigo que bebeu 4 chopes não tem 24 anos.
    member(amigo(_, _, 4, Idade_diferente_24), HappyHour),
    Idade_diferente_24 #\= 24,

    % 7. Quem gosta da cerveja alema é o Fabio ou o amigo de 24 anos.
    (member(amigo(fabio, alema, _, _), HappyHour);
        member(amigo(_, alema, _, 24), HappyHour)),

    % 4. Aquele que gosta da cerveja norte-americana não tem 24 anos nem 31 anos.
    member(amigo(_, norte-americana, _, Idade_diferente_24_e_31), HappyHour),
    Idade_diferente_24_e_31 #\= 24,
    Idade_diferente_24_e_31 #\= 31,

    % 1. O amigo de 25 anos bebeu menos chopes do que Hugo.
    menos_chopes(HappyHour, amigo(_, _, _, 25), amigo(hugo, _, _, _)),

    % 2. Mateus bebeu mais chopes do que o amigo que gosta da cerveja norte-americana.
    mais_chopes(HappyHour, amigo(mateus, _, _, _), amigo(_, norte-americana, _, _)),

    % 3. Sobre os amigos que gostam de cerveja alema e de cerveja belga, 
    % um tem 27 anos e o outro é o Hugo, não necessariamente nessa ordem.
    ((member(amigo(_, alema, _, 27), HappyHour), 
        member(amigo(hugo, belga, _, _), HappyHour));
        (member(amigo(hugo, alema, _, _), HappyHour),
         member(amigo(_, belga, _, 27), HappyHour))).

%% mais_chopes(?HappyHour, ?A1, ?A2) is nondet
%
%  Verdadeiro se A1 e A2 estão na lista do HappyHour e
%  o amigo A1 bebeu mais chopes do que o amigo A2.

:- begin_tests(mais_chopes).

test(menos_chopes_test_1 , nondet) :-
    A = amigo(marcos, _, 20, _),
    B = amigo(vinicius, _, 15, _),
    mais_chopes([A, B], A, B).

test(menos_chopes_test_2, I = 20) :-
    A = amigo(marcos, _, I, _),
    B = amigo(vinicius, _, 15, _),
    mais_chopes([A, B], A, B), !.

test(menos_chopes_test_3, fail) :-
    A = amigo(marcos, _, 10, _),
    B = amigo(vinicius, _, 15, _),
    mais_chopes([A, B], A, B).

:- end_tests(mais_chopes).

mais_chopes(HappyHour, A1, A2) :- 
    A1 = amigo(_, _, C1, _),
    A2 = amigo(_, _, C2, _),
    C1 #> C2,
    member(A1, HappyHour),
    member(A2, HappyHour).


%% menos_chopes(?HappyHour, ?A1, ?A2) is nondet
%
%  Verdadeiro se A1 e A2 estão na lista do HappyHour e
%  o amigo A1 bebeu menos chopes do que o amigo A2.

:- begin_tests(menos_chopes).

test(menos_chopes_test_1 , nondet) :-
    A = amigo(marcos, _, 10, _),
    B = amigo(vinicius, _, 15, _),
    menos_chopes([A, B], A, B).

test(menos_chopes_test_2, I = 10) :-
    A = amigo(marcos, _, I, _),
    B = amigo(vinicius, _, 15, _),
    menos_chopes([A, B], A, B), !.

test(menos_chopes_test_3, fail) :-
    A = amigo(marcos, _, 20, _),
    B = amigo(vinicius, _, 15, _),
    menos_chopes([A, B], A, B).

:- end_tests(menos_chopes).

menos_chopes(HappyHour, A1, A2) :- 
    A1 = amigo(_, _, C1, _),
    A2 = amigo(_, _, C2, _),
    C1 #< C2,
    member(A1, HappyHour),
    member(A2, HappyHour).