"""
A simple tic-tac-toe implementation
"""

from enum import Enum
from typing import Optional, List
from itertools import product
from collections import Counter


class Player(Enum):
    """
    The "X" or "O" player - either on the board, or as information
    who is playing
    """
    X = 1
    O = 2

Board = List[List[Optional[Player]]]

def who_wins(board: Board) -> Optional[Player]:
    """
    Given a tic-tac-toe board, is any player winning?
    """
    players = (Player.X, Player.O)

    for row in board:
        for player in players:
            if row.count(player) == len(row):
                return player

    for column_index in range(len(board)):
        column = [row[column_index] for row in board]
        for player in players:
            if column.count(player) == len(column):
                return player

    diagonal = [row[-index - 1] for index, row in enumerate(board)]
    for player in players:
        if diagonal.count(player) == len(diagonal):
            return player

    second_diagonal = [row[index] for index, row in enumerate(board)]
    for player in players:
        if second_diagonal.count(player) == len(second_diagonal):
            return player

    return None


def optimal(board: Board, playing_as: Player) -> (int, int):
    """
    Gets the most optimal move for a given board
    """
    somebody_wins = who_wins(board)
    if somebody_wins:
        return None

    opponent = Player.X if playing_as == Player.O else Player.O

    all_spaces = product(range(len(board)), range(len(board)))

    empty_spaces = [(column, row) for (column, row) in all_spaces if not board[row][column]]

    for column, row in empty_spaces:
        board[row][column] = playing_as
        winner = who_wins(board)
        board[row][column] = None

        if winner == playing_as:
            return column, row

    for column, row in empty_spaces:
        board[row][column] = opponent
        winner = who_wins(board)
        board[row][column] = None

        if winner == opponent:
            return column, row

    later_opponent_wins = Counter()

    for column1, row1 in empty_spaces:
        for column2, row2 in empty_spaces:
            if (column1, row1) == (column2, row2):
                continue
            board[row1][column1] = opponent
            board[row2][column2] = opponent
            winner = who_wins(board)
            board[row2][column2] = None
            board[row1][column1] = None

            if winner == opponent:
                later_opponent_wins.update([ (column1, row1)] )
                later_opponent_wins.update([ (column2, row2)] )

    if len(later_opponent_wins) > 0:
        return later_opponent_wins.most_common(1)[0][0]

    if (1, 1) in empty_spaces:
        return 1, 1

    return empty_spaces[0]

def display_board(board: Board):
    """
    Displays a tic-tac toe board in nice boxes
    """
    print("  " + " ".join(f"  {i + 1}  " for i in range(len(board))))
    for i, row in enumerate(board):
        print("  " + "┌───┐ " * len(row))
        print(f"{i + 1} " + " ".join(f"│ {player.name} │" if player else "│   │" for player in row))
        print("  " + "└───┘ " * len(row))
    print("")

def ask_for(question, answers):
    """
    Repeatedly asks a user a question, until it matches one of the given answers
    """
    while True:
        answer = input(question)
        if answer in answers:
            return answer

def main():
    """
    Runs an interactive tic-tac-toe game
    """
    chosen_character = ask_for("Kółko czy krzyżyk? [O/X]: ", ("O", "X"))
    player_character = Player.O if chosen_character == "O" else Player.X

    board = [
        [None, None, None],
        [None, None, None],
        [None, None, None]]

    current_character = Player.X

    while not who_wins(board) and not all(all(row) for row in board):
        if current_character == player_character:
            while True:
                row = int(ask_for("Wiersz [1/2/3]: ", ("1", "2", "3"))) - 1
                column = int(ask_for("Kolumna [1/2/3]: ", ("1", "2", "3"))) - 1
                if not board[row][column]:
                    break
                print("To miejsce jest już zajęte")
            board[row][column] = current_character
        else:
            column, row = optimal(board, current_character)
            board[row][column] = current_character
        display_board(board)

        current_character = Player.X if current_character == Player.O else Player.O

    winner = who_wins(board)
    if winner:
        print(f"Wygrywa {winner.name}.")
    else:
        print("Remis.")

if __name__ == '__main__':
    main()
