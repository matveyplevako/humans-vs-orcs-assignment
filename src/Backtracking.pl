quantity(Quantity) :-  % generates random number in range 5 to 20
	random_between(3, 9, Quantity).

quantity1(Quantity) :-  % generates random number in range 1 to 2
	random_between(1, 2, Quantity).

quantity2(Quantity) :-  % generates random number in range 1 to 20
	random_between(5, 13, Quantity).



generate_map([Humans, Orcks, Touchdown]) :-
	randseq(24, 24, Rand_Seq),
	quantity(Human_Num),
    quantity2(Orck_Num),
    quantity1(Touchdown_Num),
    split_seq3(Rand_Seq, Human_Num, Orck_Num, Touchdown_Num, [Humans, Orcks, Touchdown]).


backtracking_search([[0, 0]|BestPath], BestMoves) :-
    generate_map([Humans, Orcks, Touchdown]),
    draw_map(0, Humans, Orcks, Touchdown),
    setof([Moves, Path], backtracking_step([Humans, Orcks, Touchdown], 0, 0, 50, Path, [], Moves, 1), [[BestMoves, BestPath]|_]).
    

% Touchdown point
backtracking_step([_, _, Touchdown], I, J, _, [], _, 0, _) :-
    is_in(Touchdown, [I, J]).


% step up
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    I_1 is I + 1,
    H = [I_1, J],
    next_step_conditions([Humans, Orcks, Touchdown], MovesLeft, I, J, I_1, J, Used, H, Left, CurrentMove),
    backtracking_step([Humans, Orcks, Touchdown], I_1, J, Left, Path, [[I, J]|Used], PreviousMoves, Throws),
    Moves is PreviousMoves + CurrentMove.

% step down
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    I_1 is I - 1,
    H = [I_1, J],
    next_step_conditions([Humans, Orcks, Touchdown], MovesLeft, I, J, I_1, J, Used, H, Left, CurrentMove),
    backtracking_step([Humans, Orcks, Touchdown], I_1, J, Left, Path, [[I, J]|Used], PreviousMoves, Throws),
    Moves is PreviousMoves + CurrentMove.

% step left
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    J_1 is J - 1,
    H = [I, J_1],
    next_step_conditions([Humans, Orcks, Touchdown], MovesLeft, I, J, I, J_1, Used, H, Left, CurrentMove),
    backtracking_step([Humans, Orcks, Touchdown], I, J_1, Left, Path, [[I, J]|Used], PreviousMoves, Throws),
    Moves is PreviousMoves + CurrentMove.


% step right
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    J_1 is J + 1,
    H = [I, J_1],
    next_step_conditions([Humans, Orcks, Touchdown], MovesLeft, I, J, I, J_1, Used, H, Left, CurrentMove),
    backtracking_step([Humans, Orcks, Touchdown], I, J_1, Left, Path, [[I, J]|Used], PreviousMoves, Throws),
    Moves is PreviousMoves + CurrentMove.

% throw ball up
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], 1, 0, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   
% throw ball
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], 1, 1, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   
% throw ball
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], 0, 1, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   
% throw ball
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], -1, 1, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   
% throw ball
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], -1, 0, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   
% throw ball
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], -1, -1, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   
% throw ball
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], 0, -1, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   
% throw ball
backtracking_step([Humans, Orcks, Touchdown], I, J, MovesLeft, [H|Path], Used, Moves, Throws) :-
    throw_ball_common_part([Humans, Orcks, Touchdown], 1, -1, I, J, MovesLeft, H, Path, Used, Moves, Throws).
   


throw_ball_common_part([Humans, Orcks, Touchdown], Di, Dj, I, J, MovesLeft, H, Path, Used, Moves, Throws) :-
    Throws > 0,
    is_not_in(Touchdown, [I, J]),
    is_valid_move_and_left_moves(MovesLeft, Orcks, I, J),
    throw_ball([Humans, Orcks, Touchdown], Di, Dj, I, J, I_1, J_1),
    H = [I_1, J_1],
    Left is MovesLeft - 1,
    backtracking_step([Humans, Orcks, Touchdown], I_1, J_1, Left, Path, [[I, J]|Used], PreviousMoves, 0),
    Moves is PreviousMoves + 1.


next_step_conditions([Humans, Orcks, Touchdown], MovesLeft, I, J, I_1, J_1, Used, H, Left, CurrentMove) :-
    is_not_in(Touchdown, [I, J]),
    is_valid_move_and_left_moves(MovesLeft, Orcks, I, J),
    is_not_in(Used, H),
    Left is MovesLeft-1,
    (is_in(Humans, [I_1, J_1]) -> CurrentMove = 0; CurrentMove = 1).



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
    I >= 0, I < 5, J >= 0, J < 5, 
    is_not_in(Orcks, [I, J]).


is_in([Point|_], Point).

is_in([_|List], Point) :- 
    is_in(List, Point).

is_not_in([], _).

is_not_in([[X, Y]|List], [X1, Y1]) :- 
    [X, Y] \= [X1, Y1],
    is_not_in(List, [X1, Y1]).
    

draw_map(25, _, _, _).

draw_map(Count, Humans, Orcks, Touchdown) :-
    Count < 25,
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



split_seq3(_, 0, 0, 0, [[], [], []]). % terminal recursion case

% fill 1st list
split_seq3([H|Seq], N1, N2, N3, [[Place|List1], List2, List3]) :-
    N1 \== 0,
    N1_1 is N1 - 1,
    get_X_Y(H, Place),
    split_seq3(Seq, N1_1, N2, N3, [List1, List2, List3]).
    
% fill 2nd list
split_seq3([H|Seq], N1, N2, N3, [List1, [Place|List2], List3]) :-
    N1 == 0, N2 \== 0,
    N2_1 is N2 - 1,
    get_X_Y(H, Place),
    split_seq3(Seq, N1, N2_1, N3, [List1, List2, List3]).

% fill 3rd list
split_seq3([H|Seq], N1, N2, N3, [List1, List2, [Place|List3]]) :-
    N1 == 0, N2 == 0, N3 \== 0,
    N3_1 is N3 - 1,
    get_X_Y(H, Place),
    split_seq3(Seq, N1, N2, N3_1, [List1, List2, List3]).

get_X_Y(H, [A, B]) :-
    A is H//5,
    B is H mod 5.
    


