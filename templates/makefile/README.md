# Makefile templates

### basic\_c\_project / basic\_cpp\_project

Does typical Makefile stuff for C/C++ projects with a structure like this:

```
/project
|
|_/src
| |
| |_one.[c|cpp]
| |_two.[c|cpp]
| |_three.[c|cpp]
|
|_Makefile
|_...
```

Will create a build folder where all the compiled object files and the target
executable will be created. Automatically discovers source files from the
source directory when building.

Clean up the generated files with `make clean`, run the executable with `make
run`.

Is certainly missing things like including header files as dependencies, doing
anything more complicated than running the executable with no arguments, but
eh; it gets the job done more or less.
