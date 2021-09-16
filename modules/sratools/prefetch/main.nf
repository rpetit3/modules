// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process SRATOOLS_PREFETCH {
    tag "$meta.id"
    label 'process_low'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), meta:meta, publish_by_meta:['id']) }

    conda (params.enable_conda ? "bioconda::sra-tools=2.11.0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/sra-tools:2.11.0--pl5262h314213e_0"
    } else {
        container "quay.io/biocontainers/sra-tools:2.11.0--pl5262h314213e_0"
    }

    input:
    val(meta)

    output:
    tuple val(meta), path("${meta.id}/"), emit: reads
    path "*.version.txt"          , emit: version

    script:
    def software = getSoftwareName(task.process)
    """
    prefetch \\
        --progress \\
        $options.args \\
        ${meta.id}

    echo \$(prefetch --version 2>&1) | sed 's/^.*version //; s/.*\$//' > ${software}.version.txt
    """
}
