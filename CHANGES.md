| CHANGES of the Automata package |

## 1.17 (2026-07-16)

- some minor janitorial changes

## 1.16 (2024-08-30)

- Updates related to CI and Codecov (Thanks, Max)
- Streamlined UnionAutomata and IntersectionAutomaton (Thanks, Ruth)

## 1.15 (2022-03-20)

- Switch CI to use GitHub Actions (Thanks Max)
- Add Travis & Codecov support (Thanks Max)
- Fixed bug in ProductOfLanguages (pointed out by Christian Sievers)
- Fixed bug in FlowerAutomaton (pointed out by Lars Louder)

## 1.14 (2018-09-26)

- drawings are now produced in two steps: first the dot code (that is accessible to the user) and then the display
- added a test file

## 1.13 (2011-11-19)

- Corrected a bug in  FiniteRegularLanguageToListOfWords (Thanks to Andreas Distler for pointing out this bug)
- Corrected a problem with "DrawingsExtraFormat" (Thanks to Olexandr Konovalov for pointing out this problem)
- Corrected a problem with the "drawing" of automata with large alphabets (Thanks to Cameron Smith for pointing out this problem)

Some other minor changes in the code and in the manual have been also performed.

## 1.12 (2008-11-14)

- Corrected some inconsistencies concerning alphabets of automata and rational languages

## 1.11 (2008-05-31)

- Added the possibility to define dot's graph attributes, affecting all
  drawings;

- DrawAutomaton() and DrawSCCAutomaton():
  - As optional argument, we may define the text label of each state;
  - As optional argument, we may define sets of states to be colored
    in different colors;

- Corrected a bug in the function  IsContainedLang;
