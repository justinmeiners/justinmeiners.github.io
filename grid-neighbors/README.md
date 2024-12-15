Iterating grid cell neighbors
===========================
**10/27/22**

Suppose we need to iterate over the neighbors of a cell in a 2D grid:
    
    * * *
    * - *
    * * *
    
This can be done with the following well known pattern:

    void all_neighbors() {
        for (int i = -1; i <= 1; ++i) {
            for (int j = -1; j <= 1; ++j) {
                if (i == 0 && j == 0) continue;
                std::cout << i << ", " << j << std::endl;
            }
        }
    }

But what if we just want to iterate the horizontal and vertical neighbors, skipping the diagonal?

       *
     * - *
       *

Most programs explicilty repeat the operation 4 times, or use a table.
But there is a trick to do it in a loop. 
Think of the neighbor as a vector offset, and then rotate it 90 degrees, 4 times.

    template <typename I>
    void rotate_2d(I& a, I& b) {
        std::swap(a, b);
        b = -b;
    }

    void direct_neighbors() {
        int i = 1;
        int j = 0;
        for (int k = 0; k < 4; ++k) {
            std::cout << i << ", " << j << std::endl;
            rotate_2d(i, j);
        }
    }

Try it out!

    int main() {
        std::cout << "diagonal" << std::endl;
        all_neighbors();
        std::cout << "square" << std::endl;
        direct_neighbors();
    }
