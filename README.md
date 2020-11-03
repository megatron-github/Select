# Select
An introduction to Smalltalk

The Böhm-Jacopini theorem [1] states that any computer program can be implemented as the combination of three basic constructs: sequence of statements, selection (branching) and iteration (looping or recursion). Edsger W. Dijkstra proposed a selection construct for procedural languages, now known as Dijkstra’s guarded-if. This construct consists of several blocks of code, each guarded by a boolean condition. When the guarded-if is evaluated, all of the guard conditions are evaluated. Then, from those that evaluate as true, one of the associated blocks is selected arbitrarily and evaluated.

Here is an example, in which we compare two variables a and b, and assign c to 1 if a < b; or to 2 if a >= b.
if a < b → c := 1
▯ a >= b → c := 2
fi

When a = b, either might be chosen arbitrarily.
if a <= b → c := 1
▯ a >= b → c := 2
fi

We might extend Dijkstra’s construct to allow an “else guard,” which would identify a statement to evaluate
only in the case that none of the previous guards were true. Here, we’ll set c to 1 for 푎 ≤ 10, to 2 for
푎 > 20, or to 3 for 10 < 푎 ≤ 20.
if a <= 10 → c := 1
▯ a > 20 → c := 2
else → c := 3
fi

• any: Evaluate all the guards. Evaluate any one of the blocks with a true guard. If no guard is true,
evaluate the block of the else clause if it is present.
• first: Evaluate the guards in order, from first to last. Upon encountering the first true guard, evaluate
its associated block and stop evaluating guards. If no guard is true, evaluate the block of the else
clause if it is present. Note that this is like the familiar if … else if … else semantics.
• all: Evaluate the guards, in order, from first to last. After each guard evaluation, when the guard is
true, evaluate its associated block. If no guard is true, evaluate the block of the else clause if it is
present.
• exclusive: Evaluate all the guards. If exactly one guard is true, evaluate its associated block. If no
guard is true, evaluate the block of the else clause, if it is present. If more than one guard is true, or if
no guard is true and no else clause is present, signal an error.





