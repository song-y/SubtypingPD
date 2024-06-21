#!/bin/bash

##### UTILS #####

step=$1
ses_id=$2

if [ "$ses_id" = "1" ]; then
    ses_id="ses-01"

elif [ "$ses_id" = "2" ]; then
    ses_id="ses-02"

elif [ "$ses_id" = "0" ]; then
    :

else
    echo "2nd argument shoud be 1, 2 or 0"

fi

if [ "$step" = "l" ]; then
    log_file="/home/songy/scratch/repos/freesurferProcessing/output/long/log.txt"

elif [ "$step" = "b" ]; then
    log_file="/home/songy/scratch/repos/freesurferProcessing/output/base/log.txt"

elif [ "$step" = "c" ]; then
    log_file="/home/songy/scratch/repos/freesurferProcessing/output/${ses_id}/log.txt"

else 
    echo "First argument should be c, b or l"
    exit 

fi 

file_pattern_nii="*.nii.gz"
data_file_extension=".nii.gz"
mapfile -t subjects_list < subjects.txt

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"  # Display on the terminal
}

set_up_freesurfer() {
    
    # Set up FreeSurfer environment variables
    log "Setting up Freesurfer environment variables"

    export FREESURFER_HOME="/home/songy/projects/def-hanganua-ab/freesurfer"
    export SUBJECTS_DIR="/home/songy/scratch/repos/freesurferProcessing/output" # output path

    raw_data_path="/home/songy/projects/def-hanganua-ab/datasets/pcan_calgary/rawdata/bids"

    # Source the FreeSurfer setup script
    log "Running SetUpFreeSurfer.sh"
    source "$FREESURFER_HOME/SetUpFreeSurfer.sh"

    log "Finished setting up Freesurfer"
}

get_acquisition_type() {
    local file_name="$1"
    local prefix_sub_id="$2"_
    local prefix_ses_id="$3"_

    # Isolate acquisition type
    local acquisition_type="${file_name#"$prefix_sub_id"}" # remove prefix_sub_id from filename
    acquisition_type="${acquisition_type#"$prefix_ses_id"}" # remove prefix_ses_id from filename
    acquisition_type="${acquisition_type%"$data_file_extension"}" # remove file extension 

    echo "$acquisition_type"
}

create_base_template() {

    # Iterate through subjects
    for sub_id in "${subjects_list[@]}"; do

        sub_path="${SUBJECTS_DIR}/${sub_id}"
        output_path="${SUBJECTS_DIR}/base"

        # Base : create the within-subject template 
        log "Creating within-subject template for $sub_id (base)"
#        recon-all -base "$sub_id" -tp "${sub_path}/ses-01" -tp "${sub_path}/ses-02" -sd "$output_path" -all
        log "Finished creating within-subject template for $sub_id (base)"

     done 
}

longitudinal_reconstruction() {
        
    # Iterate through subjects
    for sub_id in "${subjects_list[@]}"; do

        sub_path="${SUBJECTS_DIR}/${sub_id}/${ses_id}"
        output_path="${SUBJECTS_DIR}/long"

        # Longitudinal processing
        log "Starting longitudinal processing for $sub_id $ses_id"
 #       recon-all -long "$sub_path" "$sub_id" -sd "$output_path" -all -qcache
        log "Finished longitudinal processing for $sub_id $ses_id"    

    done

    log "Finished longitudinal reconstruction for all subjects for $ses_id"
}

cross_sectional_reconstruction() {

    log "Starting cross-sectional reconstruction for $ses_id"

    # Iterate through subjects
    for sub_id in "${subjects_list[@]}"; do

        cd "${raw_data_path}/${sub_id}/${ses_id}" 
            
        # Find all data files for current subject
        data_files_of_sub=( $(find . -type f -name "$file_pattern_nii") ) 

        log "Found ${#data_files_of_sub[@]} files for $sub_id"

        # Iterate through data files of current subject
        for data_file_path in "${data_files_of_sub[@]}"; do
            
            file_name=$(basename "$data_file_path")
            acquisition_type=$(get_acquisition_type "$file_name" "$sub_id" "$ses_id")

            # Set up output dir
            output_path="${SUBJECTS_DIR}/${ses_id}/${sub_id}/${acquisition_type}"
            mkdir -p "$output_path"
            log "Created output dir for $sub_id, file $acquisition_type at $output_path"
            
            log "Starting cross-sectional reconstruction for $sub_id file $file_name"
  #          recon-all -s "$sub_id" -i "$data_file_path" -sd "$output_path" -all -qcache
            log "Finished cross-sectional reconstruction for $sub_id file $file_name"
        
        done
        log "Finished reconstruction of all acquisitions for $sub_id"
        
    done
    log "Finished cross-sectional reconstruction for $ses_id"
}

##### MAIN #####

# Script usage : 
#   CROSS-SECTIONAL processing : sh fs_processing.sh c NO_SESSION [1 or 2]
#   BASE : create within-subject template for long processing : sh fs_processing.sh b 0
#   LONGITUDINAL processing : sh fs_processing.sh l NO_SESSION [1 or 2]

log "Freesurfer processing starting for step $step, session $ses_id"

# 1. Set up freesurfer env var
set_up_freesurfer

# 2. Run appropriate step
if [ "$step" = "c" ]; then
    cross_sectional_reconstruction 

elif [ "$step" = "b" ]; then
    create_base_template

elif [ "$step" = "l" ]; then
    longitudinal_reconstruction

fi

log "Processing finished for step $step, session $ses_id, exiting script"
