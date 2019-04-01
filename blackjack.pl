%Play Instructions:
%Open the application once for every playthrough. 
%Starting command: deal.
%Follow screen instructions. 

:- dynamic points/2.
:- dynamic previousCard/3.
:- dynamic cardNumber/2.

cardNumber(player, 0).
cardNumber(dealer, 0).

victory(21).
limit(17).

points(player, 0).
points(dealer, 0).

card('Ace', X):- X = 1.
card('Two', X):- X = 2.
card('Three', X):- X = 3.
card('Four', X):- X = 4.
card('Five', X):- X = 5.
card('Six', X):- X = 6.
card('Seven', X):- X = 7.
card('Eight', X):- X = 8.
card('Nine', X):- X = 9.
card('Ten', X):- X = 10.
card('Jack', X):- X = 10.
card('Queen', X):- X = 10.
card('King', X):- X = 10.

deal:- cls, write('Welcome to Blackjack_Prolog. \n'), playerTurn.
playerTurn:- write('\n'), write('Ask for another card? \n 1. Hit \n 2. Stand'),write('\n'), read(D),decide(D).
decide(D):- D == 1, cls, hit(player); D == 2, dealerTurn.
dealerTurn:- write('\n\nThe house is playing...\n\n'), hit(dealer).
hit(P):- write('Revealing card...\n'), obtainCard(P).

obtainCard(P):- random_member(Card,['Ace','Two','Three','Four'
                                     ,'Five','Six','Seven','Eight',
                                     'Nine','Ten','Jack','Queen','King']),
                   getSuit(Suit), atom_concat(Card, Suit, C), write(C),
                   cardNumber(P, Num), assert(previousCard(P, C, Num)),
                   NewNum is Num + 1, retract(cardNumber(P, _)),
                   assert(cardNumber(P, NewNum)), write('\n\n'),
                   write('Cards: '), showRecursiveCard(P, Num),
                   card(Card, Y), addResult(P, Y).

getSuit(Suit):- random_member(Suit, [' of Clubs', ' of Diamonds', ' of Hearts', ' of Spades']).

addResult(P,Y):- points(P,Old), chooseAceValue(Y, Old, New),
                      retract(points(P, _)), X is Old + New,
                      assert(points(P, X)),
                      write('Total: '), write(X), write('\n\n'), possibleEnd(P, X).

chooseAceValue(Y, Old, New):- Y \== 1, New = Y;
                                 Old >= 11, Y == 1, New = 1;
                                 Old < 11, Y == 1, New = 11.

showRecursiveCard(P, Num) :- previousCard(P, T, Num), Num == 0, write(T), write('\n');
                        previousCard(P, T, Num), Num \==0, write(T), write(', '),
                        NewNum is Num-1, showRecursiveCard(P, NewNum).


possibleEnd(P, X):- victory(V), X > V, P == player, end1;
                    victory(V), X = V, P == player, write('¡21! House plays.'), dealerTurn;
                    victory(V), X < V, P == player, playerTurn;
                    victory(V), X > V, P == dealer, end2;
                    victory(V), limit(L), X >= L, X =< V, P == dealer, end;
                    limit(L), X < L, P == dealer, hit(P).

end:- points(player, X), points(dealer, Y), write('\nResult: \nPlayer: '),
        write(X), write('     Dealer: '), write(Y), write('\n\n'), finalCalculation(X, Y).

finalCalculation(X, Y):- X > Y, end3;
               X < Y, end4;
               X = Y, end5.

end1:- write('Bust! The house wins.').
end2:- write('The house has gone over 21! Victory!.').
end3:- write('You were closer to 21 than the house, Victory!').
end4:- write('Not enough points! House wins.').
end5:- write('Draw! The house wins.').

cls:- write('\e[2J').


