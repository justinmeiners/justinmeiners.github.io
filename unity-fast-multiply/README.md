MultiplyPoint3x4 in Unity
===========================
**01/21/2020**

What is the difference between MultiplyPoint and MultiplyPoint3x4 in Unity3D?

What steps of a matrix multiplication could Unity possibly be skipping to make an optimization?
The optimization is possible because a scaling and rotation needs only a 3x3 matrix and another vector for the translation,
so part of the full 4x4 matrix is unused and can be ignored.

Here is the source code taken from the decompilation [here][1]:

    public Vector3 MultiplyPoint(Vector3 v)
    {
        Vector3 vector3;
        vector3.x =  ( m00 *  v.x +  m01 *  v.y +  m02 *  v.z) + m03;
        vector3.y =  ( m10 *  v.x +  m11 *  v.y +  m12 *  v.z) + m13;
        vector3.z =  ( m20 *  v.x +  m21 *  v.y +  m22 *  v.z) + m23;
        float num = 1f / ( ( m30 *  v.x +  m31 *  v.y +  m32 *  v.z) + m33); // this is 1/1=1 when m30, m31, m32 = 0 and m33 = 1
        vector3.x *= num; // so then multiplying by 1 is pointless..
        vector3.y *= num;
        vector3.z *= num;
        return vector3;
    }

This is a full 4x4 * 4x1 matrix multiplication, and then scaling the x y z of the result by the w of the result.

     | m_0_0 m_0_1 m_0_2 m_0_3 |     | x |
     | m_1_0 m_1_1 m_1_2 m_1_3 |  *  | y |
     | m_2_0 m_2_1 m_2_2 m_2_3 |     | z |
     | m_3_0 m_3_1 m_3_2 m_3_3 |     | 1 |


This `w` necessary for projective transformations, but not for rotation and scaling.
This is why they have the faster 3x4 version.
It assumes the `w` component of each column is 0 and skips that bottom row of multiplication and scaling, because the resulting `w` is always 1.

    public Vector3 MultiplyPoint3x4(Vector3 v)
    {
        Vector3 vector3;
        vector3.x =  ( m00 *  v.x +  m01 *  v.y +  m02 *  v.z) + m03;
        vector3.y =  ( m10 *  v.x +  m11 *  v.y +  m12 *  v.z) + m13;
        vector3.z =  ( m20 *  v.x +  m21 *  v.y +  m22 *  v.z) + m23;
        return vector3;
    }

This function is equivalent to multiplying matrices which look like:

     | m_0_0 m_0_1 m_0_2 m_0_3 |     | x |
     | m_1_0 m_1_1 m_1_2 m_1_3 |  *  | y |
     | m_2_0 m_2_1 m_2_2 m_2_3 |     | z |
     | 0     0     0     1     |     | 1 |

[1]: https://github.com/jameslinden/unity-decompiled/blob/master/UnityEngine/UnityEngine/Matrix4x4.cs
