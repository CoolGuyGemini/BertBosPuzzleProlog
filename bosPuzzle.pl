%Bert Bos Puzzle, Prolog Edition
%Bailey Docter

%Generates solutions for the Bert Bos puzzle.
%
%bertgame/2: bertgame(Size, Pattern).
%Given a Size x Size puzzle, instantiates Pattern as a list representing the 
%	click pattern of the first row*.
%
%*Once you know the click pattern of the first row, you can solve the puzzle
%	using the following method: From the top down on each row, for any blue
%	tile, click the tile directly beneath it.
%	
bertgame(Size, Pattern):-
    Size > 0,
    Size < 13,
    newGame(Size, Board),
    clickPattern(Size, Pattern),
    firstRow(Size, Pattern, Board, TestBoard),
    solve(TestBoard, FinalBoard, Size),
    isSolved(FinalBoard, Size).

%The two possible options for a given element in a click pattern.
option(click).
option(noClick).

%The new color for a tile after it has been turned.
swap(red, blue).
swap(blue, red).

%Checks to confirm whether or not a given puzzle has been solved.
%
%isSolved/2: isSolved(Puzzle, Size).
%Calls the helper predicate isSolved/3.
%
%isSolved/3: isSolved(Puzzle, Size, CurrentRow).
%Indexes through the puzzle, checking each row to see if it is all
%	red.
%
isSolved(L, S):- isSolved(L, S, 1), !.
isSolved(L, S, S):- isRed(S, S, L).
isSolved(L, S, N):-
    isRed(S, N, L),
    M is N + 1,
    isSolved(L, S, M).

%Attempts to solve a given puzzle, assuming the first row has already been
%	completed.
%
%solve/3: solve(Puzzle, FinishedPuzzle, Size).
%Calls the helper predicate solve/5.
%
%solve/5: solve(CurrentRow, CurrentColumn, Puzzle, FinishedPuzzle, Size).
%Indexes through each column and row, attempting to solve the given puzzle.
%
solve(BoardA, BoardB, Size):- solve(1, 1, BoardA, BoardB, Size), !.
solve(X, _, B, B, X).			%If all rows have been checked
solve(X, S, A, B, S):-			%If we have reached the end of a row
    isRed(X, S, A),
    Z is X + 1,
    solve(Z, 1, A, B, S).
solve(X, S, A, B, S):-
    isBlue(X, S, A),
    Z is X + 1,
    click(Z, S, A, C),
    solve(Z, 1, C, B, S).
solve(X, Y, A, B, S):-			%If neither of the above cases apply
    isRed(X, Y, A),
    Z is Y + 1,
    solve(X, Z, A, B, S).
solve(X, Y, A, B, S):-
    isBlue(X, Y, A),
    W is X + 1,
    Z is Y + 1,
    click(W, Y, A, C),
    solve(X, Z, C, B, S).

%Executes a click pattern for the first row.
%
%firstRow/4: firstRow(Size, Pattern, Board, AlteredBoard).
%Calls the helper predicate firstRow/5.
%
%firstRow/5: firstRow(Index, Size, Pattern, Board, AlteredBoard).
%Indexes through the first row, executing the given click pattern.
%
firstRow(Size, Pattern, A, B):- firstRow(1, Size, Pattern, A, B), !.
firstRow(X, Y, _, B, B):- X > Y.
firstRow(X, Y, [noClick|T], A, B):-
    X =< Y,
    Z is X + 1,
    firstRow(Z, Y, T, A, B).
firstRow(X, Y, [click|T], A, B):-
    X =< Y,
    Z is X + 1,
    click(1, X, A, C), !,
    firstRow(Z, Y, T, C, B).

%Generates a click pattern for a given puzzle size.
%
%clickPattern/2: (Size, Pattern).
%Creates a list of size Size containing elements click or noClick.
%
clickPattern(0, []):- !.
clickPattern(Size, [Option|T]):-
    NewSize is Size - 1,
    option(Option),
    clickPattern(NewSize, T).

%Creates an unaltered puzzle board.
%
%newGame/2: newGame(Size, Board).
%Calls the helper predicate newGame/3.
%
%newGame/3: newGame(Columns, Rows, Board).
%Indexes row-by-row to create an unaltered puzzle board.
%
newGame(Size, Board):-
    newGame(Size, Size, Board).
newGame(_Cs, 0, []):-!.
newGame(Cs, Rs, [R|T]):-
    NewRs is Rs - 1,
    newRow(Cs, R),
    newGame(Cs, NewRs, T).

%Creates an unaltered row of a given length.
%
%newRow/2: newRow(Length, Row).
%Creates a list representing an unaltered row of size Length.
%
newRow(0, []):-!.
newRow(Length, [blue|T]):-
    NewLength is Length - 1,
    newRow(NewLength, T).

%Executes a click on the puzzle board.
%
%click/4: click(Row, Column, Board, ClickedBoard).
%Turns all relevant tiles for a given click.
%
click(_, _, [[X]], [[Y]]):-
    swap(X, Y).
click(2, C, [A1, B1], [A2, B2]):-
    turn(C, A1, A2),
    turn(C, B1, T1),
    Left is C + 1,
    Right is C - 1,
    turn(Left, T1, T2),
    turn(Right, T2, B2).
click(1, C, [A1, B1|T], [A2, B2|T]):-
    turn(C, A1, T1),
    turn(C, B1, B2),
    Left is C + 1,
    Right is C - 1,
    turn(Left, T1, T2),
    turn(Right, T2, A2).
click(2, C, [A1, B1, C1|T], [A2, B2, C2|T]):-
    turn(C, A1, A2),
    turn(C, B1, T1),
    turn(C, C1, C2),
    Left is C + 1,
    Right is C - 1,
    turn(Left, T1, T2),
    turn(Right, T2, B2).
click(R, C, [H|T1], [H|T2]):-
    NewR is R - 1,
    click(NewR, C, T1, T2).

%Turns a tile in a given row.
%
%turn/3: turn(Index, Row, AlteredRow).
%Turns the tile at index Index in row Row.
%
turn(N, X, X):- N < 1.
turn(_, [], []).
turn(1, [A|T], [B|T]):- swap(A, B).
turn(N, [H|T1], [H|T2]):-
    N > 1,
    M is N - 1,
    turn(M, T1, T2).

%Determines if the given tile in the row or board is blue.
%
%isBlue/3: isBlue(RowIndex, ColumnIndex, Board).
%Determines if the given tile in the board is blue.
%
%isBlue/2: isBlue(Index, Row).
%Determines if the given tile in the row is blue.
%
isBlue(1, C, [H|_]):- isBlue(C, H).
isBlue(R, C, [_|T]):-
    R > 1,
    NewR is R - 1,
    isBlue(NewR, C, T).
isBlue(1, [blue|_]).
isBlue(N, [_|T]):-
    N > 1,
    M is N - 1,
    isBlue(M, T).

%Determines if the given tile in the board is red.
%
%isRed/3: isRed(RowIndex, ColumnIndex, Board).
%Determines if the given tile in the board is red.
%
isRed(R, C, L):- \+ isBlue(R, C, L).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Debug predicates

write_out([]).
write_out([H|T]):-
    write(H), nl,
    write_out(T).

newGameTest(Size):-
    newGame(Size, Board),
    write_out(Board).

clickTest(X, Y, Size):-
    newGame(Size, A),
    click(X, Y, A, B),
    write_out(B).

firstRowTest(X):-
    newGame(X, Board),
    clickPattern(X, Pattern),
    write(Pattern), nl, nl,
    firstRow(X, Pattern, Board, TestBoard),
    write_out(TestBoard).