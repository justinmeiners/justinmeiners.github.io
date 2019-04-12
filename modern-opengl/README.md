Modern OpenGL
-------------
**05/01/2017**

If you're looking for an easy way to do 3D its probably [SceneKit](https://developer.apple.com/documentation/scenekit) or Unity,
but I assume you want to learn how things work.

Everything you know and love in OpenGL is gone. `glTranslate`, `glLookAt`, `glRotate`, `glVertex`, `glLight`, etc.
The reasoning is that these all describe a specific way of doing things, and OpenGL wanted to be as general as possible so that you can make whatever you want.

For example `glLight` has a built in algorithm for lighting. What if you want to make your own? You can’t. 

The solution is to make everything programmable. Instead of having fixed GPU procedures, the GPU becomes flexible so you can write code which runs on the GPU that replaces the fixed procedures.
These programs are called shaders.

## Shaders

There are two kinds of shaders you need to worry about.

**Vertex Shader:** takes input data, outputs vertex information (position, color, etc)

The outputs from this vertex shader are interpolated across the triangle (or line) you are drawing, and the results are inputed into the fragment shader.

**Fragment Shader:** takes input data, and interpolated vertex information, and outputs a color.

Shaders are written in a C like language and compiled into native GPU code.
I would say the first thing you need to do is practice writing some shaders, so you can get an idea of what data you need to give them.

The modern OpenGL API has been totally stripped down. It basically consists of creating shaders, providing them with data, and executing them.
That is it. There is nothing else in OpenGL.

## Data

So here is the kind of data you need to prepare for OpenGL. This is done in your main code.

### vertex positions, vertex colors, vertex normals.

You use vertex buffers to upload this data to the GPU. Basically you can make a vertex struct:

```
struct vertex
{
    Vec3 position, normal, color
}
```

and  then describe its structure, and then upload an array of them. You could make one vertex buffer for your sphere and then reuse it for each ball.

### Textures

You upload images using `glTexImage`. This APIs has stayed mostly the same as old OpenGL.

### Matrices

Since OpenGL has no translate, rotate, etc. You need to create your own transformation matrices for every object in the scene. 

This has a few components:

- **model matrix** - this is the translation/rotation for each individual model.
- **view matrix** - this describes the camera in the scene (`gluLookAt`)
- **projection matrix** - this is the “3D lense” which projects 3D coordinates onto the 2D screen.

Basically you have to calculate all of these yourself, pass them to your vertex shader, and then use them to translate the vertex positions.

Usually the projection and matrices are constant for one draw of the scene, you create them at the beginning and pass them with everything.
Then for each model you need to construct a new model matrix, describing its current state.

### Recommended Resources

- [Learn OpenGL](https://learnopengl.com/)
- [Learning Modern 3D Graphics Programming](https://paroj.github.io/gltut/)


