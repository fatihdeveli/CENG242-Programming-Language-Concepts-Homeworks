:- module(hw5, [catomic_number/2, ion/2, molecule/2]).
:- [catoms].

electron_count([], 0).
electron_count([H|T], Sum) :-
	electron_count(T, Rest),
	Sum is Rest + H.


catomic_number(Name, CNum) :-
	catom(Name, _, _, Electrons),
	electron_count(Electrons, CNum).
	
ion(_, 0).
molecule(_, 0).
