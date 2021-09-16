#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { SRATOOLS_PREFETCH } from '../../../../modules/sratools/prefetch/main.nf' addParams( options: [:] )

workflow test_sratools_prefetch {

    input = [ id:'ERR2815334', single_end:false ] // meta map

    SRATOOLS_PREFETCH ( input )
}
