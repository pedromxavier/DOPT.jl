# DOPT - Determinant Optimality

The binary D-OPT problem for a given matrix ``A \in \mathbb{R}^{m \times n}`` and a positive
integer ``s \le m`` is stated as:

```math
\begin{array}{rl}
       \max & \log\det A' \cdot \text{diagm}(\mathbf{x}) \cdot A \\
\text{s.t.} & \sum_{i} \mathbf{x}_{i} = s \\
            & \mathbf{x} \in \mathbb{B}^{m}
\end{array}
```

## Some insights

### Neighborhood

### Objective value

One could write ``f(\mathbf{x}) = \log\det A' \cdot \text{diagm}(\mathbf{x}) \cdot A`` as

```math
\log\det \sum_{i = 1}^{m} \mathbf{x}_{i} \mathbf{a}_{i} \mathbf{a}_{i}'
```

where ``\mathbf{a}_{i}`` is the ``i``-th row of ``A``.
This allows one to pre-compute the "objective matrix" ``X = \sum_{i = 1}^{m} \mathbf{x}_{i} \mathbf{a}_{i} \mathbf{a}_{i}`` to speed up the evaluation of the objective function after walking to a neighbor state.