import Documenter, DocumenterCitations
import NullBroadcasts

bib = DocumenterCitations.CitationBibliography(joinpath(@__DIR__, "refs.bib"))

mathengine = Documenter.MathJax(
    Dict(:TeX => Dict(:equationNumbers => Dict(:autoNumber => "AMS"), :Macros => Dict())),
)

format = Documenter.HTML(
    prettyurls = !isempty(get(ENV, "CI", "")),
    mathengine = mathengine,
    collapselevel = 1,
)

Documenter.makedocs(;
    plugins = [bib],
    sitename = "NullBroadcasts.jl",
    format = format,
    checkdocs = :exports,
    clean = true,
    doctest = true,
    modules = [NullBroadcasts],
    pages = Any["Home"=>"index.md", "API"=>"api.md", "References"=>"references.md"],
)

Documenter.deploydocs(
    repo = "github.com/CliMA/NullBroadcasts.jl.git",
    target = "build",
    push_preview = true,
    devbranch = "main",
    forcepush = true,
)
