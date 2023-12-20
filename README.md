Yes, this entire repository is made with assembly code. Why? that's a great
question. One day I decided to learn lower level programming, and after messing
around with C/C++ I felt I could learn something by going even lower. This is
where I ended, now I have quite some trivial projects written in assembly and
a few non-trivial others. I've learned a lot, also spent a lot of time to make
some of those projects.

Every file have quite a few comments explaining what the code does, they are
mainly there so I can refer back to them when I need, but you might find them
useful, I mean, if you ever care enough to try and build something on assembly
yourself.

Computers are really amazing piece of technology, its fascinating to me how many
abstractions were made on top of each other so we got what we have today. Its
crazy to me that trivial tasks such as finding a substring inside another string
requires a lot of processing internally. Assembly teachs you to think differently
from what you're used to, its not like other languages. You can easily mess up
the control-flow of the program and small bugs cause a really bad headache to fix.

To me, the hardest part of this journey is finding actual good resources, nobody
is trying to write assembly guides, documentation, or any piece of content that
is updated with modern systems, screw it, even if it was just 10 years old it
would be a great resource, but everything is just ancient knowledge and you
really, and I mean really have to dig the internet to find useful information.
I mean, seriously, I challenge you to start doing assembly and don't get stuck
in the first couple of hours. Everything besides writing "Hello, World!" is just
non existent. Ok, maybe thats an over exaggeration, but there is definitely a
lack of content.

To be honest, I don't even blame anyone for this, I mean, who would be the crazy
dude that would be bored on an afternoon and think: "well, I should really learn
assembly". No sane person would do that, right?

If you are wondering, I did start by making the classic Hello, World! It felt
very very difficult, but in reality it really is very simple, but feels very
cryptic if you have absolute no clue about how assembly works, you just see
a bunch of weird looking declarations, `mov` this, `%rax` that, and somehow it
just works. But once you figure how to make syscalls, its such a breeze writing
anything to stdout.

But besides being very very hard, assembly is also very refreshing in a way,
maybe I'm just crazy, but something about learning something that is just so
different, difficult, ancient gives a really warm feeling.

Oh and let's not even get started on how debugging assembly is just different,
gdb will be your best friend, and worst enemy at the same time, expect to
compare memory addresses with literal values, perform 64 bits operations on
32 bits data, try to access memory that you don't own and segfaults, misstype a
`$` instead of a `%` on a register, or otherwise on a value, try to change a
label by value not reference, lose track of your jumps, `break label_name>`,
`step`, `step`, `step`...

Oh this is as magic as it is tragic, I love computers.
