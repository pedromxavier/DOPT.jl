# DOPT - Determinant Optimality

The D-OPT problem for a given matrix ``A \in \mathbb{R}^{m \times n}`` and a positive
integer ``s \le m`` is stated as:

```math
\begin{array}{rl}
       \max & \log\det A' \cdot \text{diagm}(x) \cdot A \\
\text{s.t.} & x \in \mathbb{B}^{m} \\
            & \sum_{i} x_{i} = s
\end{array}
```

## API

### Solution Methods

```@docs
DOPT.MetaHeuristic
DOPT.AntColony
DOPT.SimulatedAnnealing
DOPT.LocalSearch
DOPT.IteratedLocalSearch
DOPT.PathRelinking
```

```@docs
DOPT.init
DOPT.solve
```

### Metrics
```@docs
DOPT.gap
```

### Instances & Results
```@docs
DOPT.read_instance
DOPT.read_solution
DOPT.update_solution!
```
