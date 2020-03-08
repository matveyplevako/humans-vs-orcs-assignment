quantity(Quantity) :-  % generates random number in range 1 to 20
	random_between(5, 20, Quantity).

quantity1(Quantity) :-  % generates random number in range 1 to 20
	random_between(1, 5, Quantity).

quantity2(Quantity) :-  % generates random number in range 1 to 20
	random_between(10, 20, Quantity).




generate_map([Humans, Orcks, Touchdown]) :-
	randseq(100, 100, Rand_Seq),
	quantity(Human_Num),
    quantity2(Orck_Num),
    quantity1(Touchdown_Num),
    split_seq3(Rand_Seq, Human_Num, Orck_Num, Touchdown_Num, [Humans, Orcks, Touchdown]).


random_search([[0, 0]|List], Moves, Touchdown, ThrowPoint) :-
    generate_map([Humans, Orcks, Touchdown]),
    random_search_round(1000, [Humans, Orcks, Touchdown], List, Moves, ThrowPoint),
    (Moves \= 200 -> 
    true;(write('No solution'), nl, true)),
    draw_map(0, Humans, Orcks, Touchdown).


random_search_round(0, _, [], 200, -1).

random_search_round(Count, [Humans, Orcks, Touchdown], BestList, BestMoves, BestThrowPoint) :-
    Count > 0,
    (random_step([Humans, Orcks, Touchdown], 0, 0, 100, List, Moves, 1, ThrowPoint) -> true;
    Moves = 200, List = []),
    Count1 is Count - 1,
    random_search_round(Count1, [Humans, Orcks, Touchdown], PreviousList, PreviousMoves, PreviousThrowPoint),
    (Moves < PreviousMoves -> ((BestMoves is Moves), (BestList = List), (BestThrowPoint = ThrowPoint));
    ((BestMoves is PreviousMoves), (BestList = PreviousList), (BestThrowPoint = PreviousThrowPoint))).


random_step([_, _, Touchdown], I, J, 0, [], 0, _, -1) :-
    is_in(Touchdown, [I, J]).


random_step([Humans, Orcks, Touchdown], I, J, MovesLeft, List, FinalMoves, Throws, ThrowPoint) :-
    is_valid_move_and_left_moves(MovesLeft, Orcks, I, J),
    is_in(Touchdown, [I, J]),
    random_step([Humans, Orcks, Touchdown], I, J, 0, List, FinalMoves, Throws, ThrowPoint).

 
random_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|List], FinalMoves, Throws, ThrowPoint) :-
    is_valid_move_and_left_moves(MovesLeft, Orcks, I, J),
    is_not_in(Touchdown, [I, J]),
    (Throws == 1, random_between(1, 12, WillThrow), WillThrow == 1 ->  
	(CurrentMove = 1,
     ThrowsLeft = 0,
        					%  up    up-right right right-down  down    down-left   left   up-left      
    random_member([Di, Dj], [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]),
    throw_ball([Humans, Orcks, Touchdown], Di, Dj, I, J, I_1, J_1));
    (ThrowsLeft = Throws,
    random_member([Di, Dj], [[1, 0], [0, 1], [-1, 0], [0, -1]]),
    I_1 is I + Di,
    J_1 is J + Dj,
    (is_in(Humans, [I_1, J_1]) -> CurrentMove = 0; CurrentMove = 1))),
    Left is MovesLeft-CurrentMove,
    H = [I_1, J_1],
    random_step([Humans, Orcks, Touchdown], I_1, J_1, Left, List, PreviousMoves, ThrowsLeft, NextThrowPoint),
    (Throws == 1, WillThrow == 1 -> ThrowPoint = [I, J]; ThrowPoint = NextThrowPoint),
    FinalMoves is CurrentMove + PreviousMoves.





%direction 1:up, 2:, 3:right, 4:right-down,
% 5:down, 6:down-left, 7:left, 8:left-up
throw_ball([Humans, Orcks, Touchdown], Di, Dj, I, J, R_I, R_J) :-
    I_1 is I + Di,
    J_1 is J + Dj,
    is_valid_move(Orcks, I_1, J_1),
    is_not_in(Humans, [I_1, J_1]),
    throw_ball([Humans, Orcks, Touchdown], Di, Dj, I_1, J_1, R_I, R_J).

throw_ball([Humans, Orcks, _], Di, Dj, I, J, R_I, R_J) :-
    I_1 is I + Di,
    J_1 is J + Dj,
    is_valid_move(Orcks, I_1, J_1),
    is_in(Humans, [I_1, J_1]),
    R_I = I_1,
    R_J = J_1.




is_valid_move_and_left_moves(MovesLeft, Orcks, I, J) :-
    MovesLeft > 0, % check that we have moves left
    is_valid_move(Orcks, I, J). % check that we can move in this direciton
    
    
is_valid_move(Orcks, I, J) :-
    I >= 0, I < 10, J >= 0, J < 10, 
    is_not_in(Orcks, [I, J]).


is_in([Point|_], Point).

is_in([_|List], Point) :- 
    is_in(List, Point).

is_not_in([], _).

is_not_in([[X, Y]|List], [X1, Y1]) :- 
    [X, Y] \= [X1, Y1],
    is_not_in(List, [X1, Y1]).
    

draw_map(100, _, _, _).

draw_map(Count, Humans, Orcks, Touchdown) :-
    Count < 100,
    get_X_Y(Count, [I, J]),
    ((J == 0, I \= 0) -> nl; true),
    draw_point([I, J], Humans, Orcks, Touchdown),
    Count1 is Count + 1,
    draw_map(Count1, Humans, Orcks, Touchdown).


draw_point(Point, Humans, Orcks, Touchdown) :- 
    (   is_in(Touchdown, Point) ->  Message ='3';
    (   is_in(Humans, Point) ->  Message ='1';
    (   is_in(Orcks, Point) ->  Message ='2';
    (   (Point == [0, 0]) ->  Message ='S';
    	Message = '0'
    )))), write(Message).




split_seq3(_, 0, 0, 0, [[], [], []]).

split_seq3([H|Seq], N1, N2, N3, [[Place|List1], List2, List3]) :-
    N1 \== 0,
    N1_1 is N1 - 1,
    get_X_Y(H, Place),
    split_seq3(Seq, N1_1, N2, N3, [List1, List2, List3]).
    
split_seq3([H|Seq], N1, N2, N3, [List1, [Place|List2], List3]) :-
    N1 == 0, N2 \== 0,
    N2_1 is N2 - 1,
    get_X_Y(H, Place),
    split_seq3(Seq, N1, N2_1, N3, [List1, List2, List3]).

split_seq3([H|Seq], N1, N2, N3, [List1, List2, [Place|List3]]) :-
    N1 == 0, N2 == 0, N3 \== 0,
    N3_1 is N3 - 1,
    get_X_Y(H, Place),
    split_seq3(Seq, N1, N2, N3_1, [List1, List2, List3]).


get_X_Y(H, [A, B]) :-
    A is H//10,
    B is H mod 10.
    
