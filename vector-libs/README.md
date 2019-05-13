Notes on Vector Libraries
=========================

**05/12/2019**

A good vector math library is essential for graphics
and simulation programming.
However, implementing one that is flexible, efficient,
and easy to use is difficult.
Due to so many choices, experienced
programmers tend to write their own to accommodate their preference.

In this article I will survey a few of the most popular techniques and offer some design advice.
I will specifically focus on math theory and C implementations.

## Math

Before diving into the code.
It's helpful to review some of the math
to understand what we are aiming for. One thing to watch for
is operations that can be defined in terms of each other.
Rarely do I see libraries take advantage of this.

**Vector Operations**

On vectors in `R^N`

- addition `v + w` 
- subtraction `v - w`. Defined by addition: `a - b = a + (-b)`
- multiplication `v * w`
- scaling `a * v`
- normalization. Defined by length and scaling: `1/|v| * v`
    
From `R^N -> R`

- dot product `<v, w>`
- length `|v|`. Defined by dot product `sqrt(<v,v>)`
- angle. Defined by dot product and length `acos(<a,b>/|a||b|)`

Only on specific dimension, such as `R^2` or `R^3`

- cross product `a X b`
- angle (in the plane)

**Matrix Operations**

On all matrices `M(n x m)`

- addition `A + B`
- subtraction `A - B`
  Defined by addition `A - B = A + (-B)`
- scaling `bA`
- multiplication `AB`

On square matrices `M(n x n)`

- determinant `det(A)`
- inverse `A^-1`

Between vectors and matrices

- multiplication `Av`

Most programs use 2, 3, and 4
element vectors, and only a few operations
are specific to a given dimension.
So a lot of code can be condensed by writing algorithms
on N dimensional vectors.

Matrix operations are also very general.
But a few should be kept to a specific 
dimension (usually 3x3 or 4x4).
You do not want to implement a
general inverse or determinant function.

## 1. Simple Structs

    typedef struct
    {
        float x, y, z;
    } vec3;

    vec3 vec3_add(vec3 a, b)
    {
        vec3 r;
        r.x = a.x + b.x;
        r.y = a.y + b.y;
        r.z = a.z + b.z;
        return r;  
    }

This works well for smaller programs.
The best part is that expressions look nice (`a + 2.0*(b-d)`):

    vec3_add(a, vec3_scale(2.0, vec_sub(b, c)));

But, we have to copy this definition for every dimension.
We also have to avoid any algorithms that use
index or iteration.
Matrix vector multiplication gets ugly.

If you only have a few functions that need
indexing and you can index into a pointer to the first member:

    vec3 a;
    float* v = &a.x;
    v[0];

**Examples**

- [vec math](https://github.com/justinmeiners/pre-rendered-backgrounds/blob/master/source/engine/core/vec_math.h)

- [stb vec](https://github.com/nothings/obbg/blob/master/src/stb_vec.h)

## 2. Arrays

For `N` dimensional vectors
we might try to write functions which
operate on arrays of floats.
This is nice because it does not 
introduce another data structure, so 
other functions and vector libraries play nice with each other.

Unfortunately, C does not allow you to return
an array from the stack. You can only return a pointer
which must point to some valid region.
So either we do something horrible like `malloc` in each operation,
or pass in arrays for the return value.
Passing in arrays works, but it destroys the ability
to comfortably write simple expressions such as `a + 2.0*(b-d)`:

    void vecn_add(int n, float* a, float* b, float* ret);

    // intermediate results everywhere
    float temp[3];
    vecn_sub(3, b, d, temp);

    float temp2[3];
    vecn_scale(3, 2.0, temp, temp2);

    float final[3];
    vecn_add(3, a, temp2, final);

Plain arrays may be appropriate for matrices since they are not typically
involved in complex expressions. 
Matrices and large vectors, which would be inefficient to copy around
would also be a good use case.

Depending on the application you may not want
to sacrifice performance by introducing loops and branching
into every operation. As long as the dimensions
are input as a literals or macros, the small loops
should be unrolled at compile time.

**Examples:**

- [Accelerate](https://developer.apple.com/documentation/accelerate/vdsp)
- [linmath](https://github.com/datenwolf/linmath.h)

## 3. Struct + Union

A workaround to return an array from a function is to include it in a struct.
The tradeoff is that the size must be fixed and element access is a bit
uglier as it requires at least an extra letter.

    typedef struct
    {
        float e[3];
    } vec3;

    vec3 v;
    v.e[0] = 1;

The access syntax can be cleaned up with a union
but, [anonymous structs/unions](https://gcc.gnu.org/onlinedocs/gcc/Unnamed-Fields.html)
are a GCC extension and are non-standard.

    typedef union
    {
        float v[3];
        struct
        {
            float x;
            float y;
            float z; 
        }; 
    } vec3;

This gives you safe iterative access and nice named members,
but it is hard to combine with generic functions.
Either you use functions which operate on the internal arrays
and deal with the intermediate results.
Or, define fixed dimension functions which wrap
the generic ones:

    vec3 vec3_add(vec3 a, vec3 b);
    {
        vec3 temp;
        vecn_add(3, a.v, b.v, temp.v);
        return temp;
    }

I don't love this option.
If I need to write wrapper functions I might as well go back to method 1
and copy implementations around.

**Examples:**

- [Math 3D](https://github.com/arkanis/single-header-file-c-libs/blob/master/math_3d.h) (See Matrices)

## 4. Macros

Some clever macros can help you get the best of both worlds, and
parameterize the scalar types. This can be combined with 
an array or union data structure.
But, writing multi-line macros isn't very fun.

    #define DEFINE_VEC(T, N, SUF) \
    \
    void vec##N####SUF##_add(const T *a, const T *b,  T *r) \
    { \
        for (int i = 0; i < N; ++i) \
            r[i] = a[i] + b[i]; \
    } \

Then define the types you need:

    DEFINE_VEC(float, 2, f);
    DEFINE_VEC(float, 3, f);
    DEFINE_VEC(float, 4, f);

Usage:

    vec3f_add(a, b);

Functions which only apply to a specific dimension
can be defined outside of the macro:

    void vec3f_cross(const float* a, const float* b, float* r)
    {
        // ...
    }

**Examples:**

- [linmath](https://github.com/datenwolf/linmath.h)

## Closing Thoughts

In typical C fashion, I believe it is misguided to try to write
the *one true* vector library to serve all purposes.
These libraries are bloated and must choose tradeoffs which
don't fit your use case. Instead use the examples
above to write to tailor make vector functions as needed.

For further reading, see [On Vector Math Libraries](http://www.reedbeta.com/blog/2013/12/28/on-vector-math-libraries/).
It focuses on C++ and has a few other handy tips.
You can also read a [discussion](https://github.com/arkanis/single-header-file-c-libs/issues/3)
which led to these notes.

