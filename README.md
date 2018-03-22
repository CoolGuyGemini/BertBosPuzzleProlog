# BertBosPuzzleProlog
A Prolog program that generates solutions to the Bert Bos Puzzle.

The Bert Bos Puzzle is a simple puzzle game, which served as the inspiration to the 1995 Tiger Electronics game "Lights Out". The rules, as described Gertjan van Noord, are as follows:

"The puzzle consists of a square of n x n blue tiles. The back side of each tile is red. The object of the puzzle is to turn every tile, so that the whole square becomes red.
However, when a tile is turned, its four neighbors also turn. With every turn, therefore, five tiles swap color."

The main predicate bertgame/2 will generate the correct click patterns for the top row. The comment above that predicate provides an explanation as to how to solve the puzzle from that point on.

If you'd like to test these solutions for yourself, you may visit http://mathcs.pugetsound.edu/~tmullen/pages/bertspel/
This page also provides the puzzle explanations and hints for solving it, in case you'd like to figure out the trick for yourself.

This code was originally written as a homework assignment for Professor Anthony Mullen at the University of Puget Sound. Credit for the idea belongs to him, but the code itself was written entirely on my own.
