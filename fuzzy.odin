package fuzzyodin

import "core:math"
import "core:slice"

fuzzy :: proc(input: string, dictionary: ^[dynamic]string, results: int = 100) -> []string
{
    scores := make(map[int][dynamic]string)
    defer delete(scores)
    max_score := 0
    for word in dictionary {
        score := levenshtein_dp(input, word)
        if score in scores {
            append(&scores[score], word)
        } else {
            scores[score] = make([dynamic]string)
            append(&scores[score], word)
            max_score = max(max_score, score)
        }
    }

    top := make([dynamic]string)
    for i in 0..=max_score {
        if i in scores == false do continue
        words := scores[i]
        slice.sort(words[:])
        append(&top, ..words[:])

        if results != -1 && len(top) > results {
            break
        }
    }

    if results == -1 || results > len(top) do return top[:]
    return top[:results]
}

// Levenshtein distance
// dynamic programming matrix impl
@private
levenshtein_dp :: proc(a, b: string) -> int
{
    mat_position :: proc(i, j: int, mat: ^[]int, m, n: int) -> int
    {
        if min(i, j) == 0 do return max(i, j)
        return mat[(i-1)*n+(j-1)]
    }

    m, n := len(a), len(b)
    mat := make([]int, m*n)

    if m == 0 do return n
    if n == 0 do return m

    for i in 1..=m {
        for j in 1..=n {
            if min(i, j) == 0 {
                mat[i*n+j] = max(i, j)
                continue
            }

            third := mat_position(i - 1, j - 1, &mat, m, n)
            if a[i-1] != b[j-1] do third += 1

            val := min(
                mat_position(i-1, j, &mat, m, n) + 1, 
                mat_position(i, j - 1, &mat, m, n) + 1, 
                third
            )

            mat[(i-1)*n+(j-1)] = val
        }
    }

    return mat[len(mat)-1]
}