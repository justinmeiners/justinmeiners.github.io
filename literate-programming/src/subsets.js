function subsets(set) {
    if (set.length == 0) { return [[]]; }
    const element = set.pop();
    const smaller = subsets(set);
    return smaller
        .concat( smaller.map(s => s.concat([element])) );
}

console.log( subsets([1, 2, 3, 4]) );
