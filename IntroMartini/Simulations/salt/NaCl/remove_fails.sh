#!/bin/bash

# Root directory (optional argument, defaults to current directory)
ROOT_DIR="${1:-.}"
LOG_DELETED="issues.txt"
# Loop through all proteins
for protein_dir in "$ROOT_DIR"/*/; do
    # Skip non-directories
    [ -d "$protein_dir" ] || continue

    # Loop through trial directories
    for trial_dir in "$protein_dir"/trial*/; do
        [ -d "$trial_dir" ] || continue

        run_out="${trial_dir}/run_prod.out"

        if [[ -f "$run_out" ]]; then
            # Read the last non-empty line of the file
            last_line=$(tac "$run_out" | grep -m1 .)

            if [[ "$last_line" == GROMACS\ reminds\ you:* ]]; then
                echo "Keeping $trial_dir"
            else
                echo "Deleting $trial_dir (missing GROMACS quote)"
                echo "$protein_name $trial_name" >> "$LOG_DELETED"
		rm -rf "$trial_dir"
            fi
        else
            echo "Deleting $trial_dir (no run_prod.out)"
            rm -rf "$trial_dir"
        fi
    done
done

