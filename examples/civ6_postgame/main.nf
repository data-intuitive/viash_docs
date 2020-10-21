nextflow.preview.dsl=2

import java.nio.file.Paths

include  plot_map       from  './target/nextflow/civ6_save_renderer/plot_map/main.nf'       params(params)
include  combine_plots  from  './target/nextflow/civ6_save_renderer/combine_plots/main.nf'  params(params)
include  convert_plot   from  './target/nextflow/civ6_save_renderer/convert_plot/main.nf'   params(params)
include  parse_header   from  './target/nextflow/civ6_save_renderer/parse_header/main.nf'   params(params)
include  parse_map      from  './target/nextflow/civ6_save_renderer/parse_map/main.nf'      params(params)
include  rename         from  './utils.nf'

workflow {

    if (params.debug == true)
        println(params)

    if (!params.containsKey("input") || params.input == "") {
        exit 1, "ERROR: Please provide a --input parameter pointing to .Cif6Save file(s)"
    }

    def input_ = Channel.fromPath(params.input)

    def listToTriplet = { it -> [ "all", it.collect{ a -> a[1] }, params ] }

    input_ \
        | map{ it -> [ it.baseName , it ] } \
        | map{ it -> [ it[0] , it[1], params ] } \
        | ( parse_header & parse_map ) \
        | join \
        | map{ id, parse_headerOut, params1, parse_mapOut, params2 ->
            [ id, [ "yaml" : parse_headerOut, "tsv": parse_mapOut ], params1 ] } \
        | plot_map \
        | convert_plot \
        | rename \
        | toList \
        | map( listToTriplet ) \
        | combine_plots

}

