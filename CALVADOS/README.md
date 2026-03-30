## Running Simulations

### Single IDR

1. Modify `simple_single_IDR.py` with your sequence info:
   - **Line 15** — sequence name
   - **Line 16** — sequence
   - **Lines 17–19** — temperature, salt concentration, and pH *(optional)*

2. Submit the job:
```bash
   sbatch run_single_IDR.slurm
```

> **Note:** Runs on 4 CPUs. A 16-residue sequence takes ~7 minutes.

---

### Multiple IDRs

1. Create a CSV file named `sequences_to_sub.csv` with the following format:
```
   name,sequence
```

2. Submit all sequences:
```bash
   ./submit_all_seq.sh
```

> **Note:** Each sequence is submitted as an independent job.
