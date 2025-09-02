// Stage files to their final locations
process STAGE_FILE {
    debug true
    label 'aws'

    tag "$file_id"

    input:
    tuple val(file_uri), val(file_id), path(file)

    output:
    tuple val(file_uri), val(file_id), val("${upload_location}/${file.name}")

    script:
    upload_location = Utils.get_publish_dir(params, file_id)
    """
    set -euo pipefail

    # normalize s3 uri: collapse s3:/// → s3:// and any // in path
    dest=\$(echo "${upload_location}/${file.name}" \
      | sed -E 's|^s3:/+|s3://|; s|//+|/|g')

    aws s3 cp "${file}" "\$dest"
    """
}
