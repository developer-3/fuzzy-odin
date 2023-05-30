# Fuzzy Searching for Odin

Fuzzy Searching for Odin is a library that utilizes the Levenshtein distance algorithm to compare strings and return the best matches. 

Using the library is simple.

```odin
package main

import fuzzy "fuzzyodin"
import "core:fmt"

main :: proc()
{
    // Load your terms you want to compare input to
    terms_to_compare := make([dynamic]string)
    defer delete(terms_to_compare)
    append(&terms_to_compare, "odin", "develop", "fuzzy")

    // Get input from the user via cli, search bar, etc...
    input := "dev"

    results := fuzzy.fuzzy(input, &terms_to_compare)
    defer delete(results)

    // fuzzy() has an optional results parameter
    // The default is 100 results

    // Example getting only 1 results
    results = fuzzy.fuzzy(input, &terms_to_compare, 1) // returns 10 results

    // You can also get all results by passing -1
    results = fuzzy.fuzzy(input, &terms_to_compare, -1) // returns all results

    // Now do whatever you like with the results!
    fmt.println(results)
}
```