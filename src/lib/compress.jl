# ~ Compression ~
const __COMPRESSION_TABLE = UInt8['+'; '-'; '0':'9'; 'A':'Z'; 'a':'z']

@assert length(__COMPRESSION_TABLE) == 64

__COMPRESS(i::Integer) = __COMPRESSION_TABLE[i+1]

function compress(x::Vector{U}) where {U}
    n = length(x)
    m = n ÷ 6
    k = n % 6
    u = Vector{UInt8}(undef, m + 2)

    for i = 1:m+1
        l = 0
        for j = 1:ifelse(i <= m, 6, k)
            l += x[6*(i-1)+j] << (j - 1)
        end
        u[i] = __COMPRESS(l)
    end

    u[end] = __COMPRESS(k)

    return String(u)
end

# ~ Uncompression ~
const __UNCOMPRESSION_MISS = UInt8('.')

function __UNCOMPRESSION_FUNC(x::Char)
    if x == '+'
        0x01
    elseif x == '-'
        0x02
    elseif '0' <= x <= '9'
        0x03 + UInt8(x - '0')
    elseif 'A' <= x <= 'Z'
        0x0d + UInt8(x - 'A')
    elseif 'a' <= x <= 'z'
        0x27 + UInt8(x - 'a')
    else
        __UNCOMPRESSION_MISS
    end
end

const __UNCOMPRESSION_TABLE = __UNCOMPRESSION_FUNC.(Char.(1:126))

__UNCOMPRESS(i::UInt8) =  __UNCOMPRESSION_TABLE[i] - 0x01

function uncompress(s::String, U::Type{<:Integer}=Int)
    u = UInt8.(collect(s))
    m = length(u) - 2
    k = __UNCOMPRESS(u[end])
    x = Vector{U}(undef, 6 * m + k)

    for i = 1:m+1
        l = __UNCOMPRESS(u[i])
        for j = 1:ifelse(i <= m, 6, k)
            x[6*(i-1)+j] = l & 0x01 # mod 2
            l = l >> 1
        end
    end

    return x
end