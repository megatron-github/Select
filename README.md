# Select
An introduction to Smalltalk

The Böhm-Jacopini theorem [1] states that any computer program can be implemented as the combination of three basic constructs: sequence of statements, selection (branching) and iteration (looping or recursion). Edsger W. Dijkstra proposed a selection construct for procedural languages, now known as Dijkstra’s guarded-if. This construct consists of several blocks of code, each guarded by a boolean condition. When the guarded-if is evaluated, all of the guard conditions are evaluated. Then, from those that evaluate as true, one of the associated blocks is selected arbitrarily and evaluated.

Here is an example, in which we compare two variables a and b, and assign c to 1 if a < b; or to 2 if a >= b. <br />
if a < b → c := 1 <br />
▯ a >= b → c := 2 <br />
fi

When a = b, either might be chosen arbitrarily. <br />
if a <= b → c := 1 <br />
▯ a >= b → c := 2 <br />
fi

We might extend Dijkstra’s construct to allow an “else guard,” which would identify a statement to evaluate
only in the case that none of the previous guards were true. <br />
if a <= 10 → c := 1 <br />
▯ a > 20 → c := 2 <br />
else → c := 3 <br />
fi

Implementation:

• any: Evaluate all the guards. Evaluate any one of the blocks with a true guard. If no guard is true, evaluate the block of the else clause if it is present.
• first: Evaluate the guards in order, from first to last. Upon encountering the first true guard, evaluate its associated block and stop evaluating guards. If no guard is true, evaluate the block of the else clause if it is present. Note that this is like the familiar if … else if … else semantics.
• all: Evaluate the guards, in order, from first to last. After each guard evaluation, when the guard is true, evaluate its associated block. If no guard is true, evaluate the block of the else clause if it is present.
• exclusive: Evaluate all the guards. If exactly one guard is true, evaluate its associated block. If no guard is true, evaluate the block of the else clause, if it is present. If more than one guard is true, or if no guard is true and no else clause is present, signal an error. 
switch: item: The object can receive at most one of these messages, and it stores the item. This message must be the first one received, and thus (a) it precedes the case:then: messages, and (b) it cannot follow any if:then: messages.
• case: collectionBlock then: thenBlock: This message has a behavior similar to if:then:

Select first <br />
if: [a = 1] then: [cout << 'one!'; nl]; <br />
if: [a > 0] then: [cout << 'positive!'; nl]; <br />
end <br />

Select all <br />
if: [a = 1] then: [cout << 'one!'; nl]; <br />
if: [a > 0] then: [cout << 'positive!'; nl]; <br />
end <br />

Select all <br />
if: [a = 1] then: [cout << 'one!'; nl]; <br />
if: [a > 0] then: [cout << 'positive!'; nl]; <br />
else: [cout << 'not positive!'; nl]; <br />
end 

Select exclusive <br />
if: [a = 1] then: [cout << 'one!'; nl]; <br /> 
if: [a > 0] then: [cout << 'positive!'; nl]; <br />
else: [cout << 'not positive!'; nl]; <br />
end <br />

Select any switch: 5; <br />
case: [1 to: 5] then: [cout << '5 is in this collection'; nl]; <br />
case: [Set with: 2] then: [cout << 'but not this one'; nl]; <br />
case: [1 to: 9 by: 2] then: [cout << 'could be!!'; nl]; <br />
else: [cout << 'definitely not.'; nl]; <br />
end <br />







