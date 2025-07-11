import sys
import numpy as np

def estimate_solute_fraction(box_length, conc):

    # Convert box volume from nm^3 to liters (1 nm^3 = 1e-24 L)
    box_volume_L = (box_length ** 3) * 1e-24

    # Avogadro's number (molecules per mol)
    NA = 6.022e23

    # Calculate number of NEW_U molecules needed for the target concentration
    num_sug = conc * NA * box_volume_L

    return num_sug

box_length = float(sys.argv[1])
conc = float(sys.argv[2]) #!in molar 
frac = estimate_solute_fraction(box_length, conc)
print(int(frac))
