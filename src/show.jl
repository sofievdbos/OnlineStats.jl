# Ex:  `name(randn(5))`         prints `Array{Float64, 1}`
# Ex:  `name(randn(5), false)`  prints `Array`
function name(o, withparams = true)
    s = replace(string(typeof(o)), "OnlineStats.", "")
    if !withparams
        s = replace(s, r"\{(.*)", "")
    end
    s
end

indent(io,::IO, nspaces, s = ">") = print(io, repeat(" ", nspaces) * s)

# first line of Series or Bootstrap
header(io::IO, s::AbstractString) = print(io, "▦ $s" )

# second line, the weight
function print_weight(io::IO, W)
    print(io, "┣━━ ")
    println(io, W)
end

function print_item(io::IO, name, value, newline)
    print(io, "    > " * @sprintf("%-16s", name), " : ", value)
    newline && println(io)
end
print_item(io::IO, o::OnlineStat, newline) = print_item(io, name(o, false), value(o), newline)






#----------------------------------------------------------# Default OnlineStat show method
Base.show(io::IO, o::OnlineStat) = (print(io, name(o)); show_fields(io, o))


function show_fields(io::IO, o)
    nms = fields_to_show(o)
    print(io, "(")
    for nm in nms
        print(io, "$nm = $(getfield(o, nm))")
        nm != nms[end] && print(io, ", ")
    end
    print(io, ")")
end
fields_to_show(o::OnlineStat) = fieldnames(o)
