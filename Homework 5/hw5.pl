:- module(hw5, [catomic_number/2, ion/2, molecule/2]).
:- [catoms].

electron_count([], 0).
electron_count([H|T], Sum) :-
	electron_count(T, Rest),
	Sum is Rest + H.

catomic_number(Name, CNum) :-
	number(CNum),
	catom(Name, _, _, Electrons),
	electron_count(Electrons, CNum), !.

catomic_number(Name, CNum) :-
	catom(Name, _, _, Electrons),
	electron_count(Electrons, CNum).

% Find the last element of a list.
last([E], E).
last([_|T], Last) :- last(T, Last).

% Charge of the electrons list
charge(Electrons, Charge) :-
    last(Electrons, Valence),
    Valence > 4,
    Charge is Valence-8, !.
charge(Electrons, Charge) :-
    last(Electrons, Valence),
    Charge is Valence, !.


ion(Name, Charge) :-
    catom(Name, _, _, Electrons),
    charge(Electrons, Charge).

totalCharge([], 0).
totalCharge(CatomList, Charge) :-
    CatomList = [H|T],
    catom(H, _, _, Electrons),
    charge(Electrons, ChargeOfH),
    totalCharge(T, ChargeOfRest),
    Charge is ChargeOfH + ChargeOfRest, !.

totalCatomicNumber([], 0).
totalCatomicNumber(CatomList, TotalCnum) :-
    CatomList = [H|T],
    catom(H, _, _, _),
    catomic_number(H, CNum),
    totalCatomicNumber(T, CNumOfRest),
    TotalCnum is CNum + CNumOfRest, !.

sublist([], _).
sublist([X|XS], [X|XSS]) :- sublist(XS, XSS).
sublist([X|XS], [_|XSS]) :- sublist([X|XS], XSS).

addWithOrder(List, Name) :-
    List == [],
    List is [Name].
addWithOrder(List, Name) :- % Insert to front
    catomic_number(Name, CNum),
    List = [H|_],
    catomic_number(H, ListNum),
    CNum =< ListNum,
    append(Name, List, List).
addWithOrder(List, Name) :- % Recursive call
    catomic_number(Name, _),
    List = [_|T],
    addWithOrder(T, Name).

molecule(CatomList, TotalCNum) :-
    is_list(CatomList),
    totalCharge(CatomList, 0),
    totalCatomicNumber(CatomList, TotalCNum).

molecule(CatomList, TotalCNum) :-
    Catoms = [],
    catom(Name, _, _, Electrons),
    electron_count(Electrons, Count), % catomic_number
    addWithOrder(Catoms, Name),
    write(Count),
    sublist(SL, Catoms),
    totalCharge(SL, 0),
    totalCatomicNumber(SL, TotalCNum),
    CatomList = SL.
