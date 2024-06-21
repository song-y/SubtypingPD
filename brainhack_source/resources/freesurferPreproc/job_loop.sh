mapfile -t subjects_list < subjects.txt

for sub_id in "${subjects_list[@]}"; do

	sbatch freesurferPreproc_job.sh "$sub_id"

done


