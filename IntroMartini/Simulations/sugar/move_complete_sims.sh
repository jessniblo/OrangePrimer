
#!/bin/bash

# Root directory (optional, defaults to current directory)
ROOT_DIR="${1:-.}"

# Target directory for proteins ready to download
READY_DIR="${ROOT_DIR}/ready_to_download"

# Create the target directory if it doesn't exist
mkdir -p "$READY_DIR"

# Loop through all top-level directories (assumed to be proteins)
for protein_dir in "$ROOT_DIR"/*/; do
    # Skip the ready_to_download directory itself
    [[ "$protein_dir" == "$READY_DIR/" ]] && continue

    # Check for trial* directories
    if compgen -G "${protein_dir}trial*/" > /dev/null; then
        echo "moving $(basename "$protein_dir") to ready_to_download/"
        mv "$protein_dir" "$READY_DIR/"
    fi
done

