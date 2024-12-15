A simple mesh adjacency data structure
======================

**06/25/2022**

Do you need a mesh adjacency structure?
Are you considering implementing [half edge][half-edge2] or [bmesh][bmesh]?
Here is a trick to consider first, that may save you some energy.

Take your mesh's indices array and reverse it:

    // f -> v
    uint32_t *index_to_vert = indices;

    // v -> f:
    multimap<uint32_t, uint32_t> vert_to_index;
    for (size_t i = 0; i < index_count; ++i)
    {
        vert_to_index.insert(make_pair(index_to_vert[i], i));
    }

This [multimap](https://en.cppreference.com/w/cpp/container/multimap) can handle most mesh traversal queries efficiently,
such as:

    // return number of faces a vertex belongs to
    size_t degree(uint32_t vert)
    {
        auto range = vert_to_index.equal_range(vert);
        return (size_t)(range.second - range.first);
    }

### Details

So what's going on here?
The original `indices` can be thought of as a map from faces to vertices (technically 3 indices for each triangle, but that's the idea). 

![face to vertex](face_to_vertex.png)

This new multimap goes in the opposite direction.
It maps vertices to faces. 
Because a single vertex may be shared between faces, the map does not have unique keys (hence `multi-`).

![vertex to face](vertex_to_face.png)

It is a little more cumbersome to write certain operations.
But this is mostly a matter of writing a few good helper functions.
Let's look at one more:

    vector<uint32_t> neighboring_faces(uint32_t face_index)
    {
        vector<uint32_t> neighbors;
        for (uint32_t f = 0; f < 3; ++f)
        {
            // visit vertex in this face
            uint32_t vert_index = indices[face_index * 3 + f];

            // find attached faces
            auto range = verts_to_faces.equal_range(vert_index);
            for_each(range.begin(), range.end(), [](auto i) {
                uint32_t neighbor_face_index = i / 3;
                if (neighbor_face_index == face_index) return;

                neighbors.push_back(neighbor_face_index);
            });
        }

        return neighbors;
        // TODO: remove duplicate results
        // TODO: you want to allocate a new vector for this. It's for illustrative purposes.
    }

### What are it's limitations?

This data structure is an easy to implement solution for traversing a mesh.
But if you need to *edit* the mesh, it usually won't help. 
Addding or remove a mesh element typically requires rebuilding part of the multimap, which is inefficient, and tedious.
As [Fabien describes][half-edge1], it's hard enough to maintain the invariants of a 3D mesh during editing, without this extra work.

Some editing algorithms may skim by.
One technique is to use the multimap to visit the mesh, marking which faces and vertices to delete,
and then throwing away the multimap and applying the changes.

It's probably less efficient than a half-edge mesh, which maintains direct pointers.
But the algorithmic complexity should be the same.

### No manifold requirements 

This technique has another advantageous property that's worth calling out.
Adjacency structures typically impose additional mathematical requirements on the mesh structure.
These can be tedious to verify, and hard to fix if the mesh wasn't constructed with them in mind.
For example half-edges only work if the mesh is a [*2-manifold with boundary*][manifold],
consequently edges have at most 2 faces attached.

But the multimap has no such requirement!
It can be constructed for any indexed triangle soup!

One caveat to is that several mesh processing algorithms still assume similar requirements,
so watch out for that.

### What if you can't use multimap?

The C++ **std::multimap** is a pretty complex data structure on its own,
and most standard libraries don't have an equivalent. 
So is it just hiding all the complexity?
No! You can implement a cheap version using a sorted array and binary search.

The construction is very similar, but we sort at the end:

    uint32_t *index_to_vert = indices;

    using ReverseIndex = pair<uint32_t, uint32_t>;
    ReverseIndex* vert_to_index = new ReverseIndex[index_count];

    for (uint32_t i = 0; i < index_count; ++i) {
        vert_to_index[i] = make_pair(index_to_vert[i], i);
    }

    sort(vert_to_face, vert_to_face + index_count);

Note that `index_to_vert` and `vert_to_index` have the same size.

The purpose of sorting is to enable binary search
(see [`lower_bound`][lower_bound], [`upper_bound`][upper_bound], and [`equal_range`][equal_range]).
The cost of a binary is `O(log(n))` which in practice is not much different than `O(1)`
(you can binary search a billion records in 32 steps).

Here is an example:

    // compute a smooth vertex normal
    vec3 average_normal(uint32_t v0)
    {
        auto key = make_pair(v0, 0);
        auto i = lower_bound(vert_to_face, vert_to_face + n, key);

        vec3 n;

        while (i != vert_to_face + n && i->first == v0)
        {
            uint32_t face_index = (i->second) / 3;
            n += face_normals[face_index];
            ++i;
        }
        return n.normalized();
     }


Hope that helps!

I have one other reason for liking this simple array representation.
In mathematical terms *functions* are sets of pairs.
Indicies is a subset of the cartresion product `F x V`.
The reverse index is build by swapping pairs from this set construction.
This new set is a subset of `V x F` and weakens from *function* to a  *relation*.

[half-edge1]: https://fgiesen.wordpress.com/2012/02/21/half-edge-based-mesh-representations-theory/
[half-edge2]: https://kaba.hilvi.org/homepage/blog/halfedge/halfedge.htm
[bmesh]: https://wiki.blender.org/wiki/Source/Modeling/BMesh/Design
[multimap]: https://en.cppreference.com/w/cpp/container/multimap
[manifold]: https://en.wikipedia.org/wiki/Manifold#Manifold_with_boundary
[equal_range]: https://en.cppreference.com/w/cpp/algorithm/equal_range
[lower_bound]: https://en.cppreference.com/w/cpp/algorithm/lower_bound
[upper_bound]: https://en.cppreference.com/w/cpp/algorithm/upper_bound
 
