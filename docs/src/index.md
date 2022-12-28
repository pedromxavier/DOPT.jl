# DOPT - Determinant Optimality

The D-OPT problem for a given matrix ``A \in \mathbb{R}^{m \times n}`` is stated as:

```math
\begin{array}{rl}
       \max & \log\det A' \cdot \text{diagm}(x) \cdot A \\
\text{s.t.} & x \in \mathbb{B}^{m}
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
