import numpy as np 
import sys 

numRepeats = int(sys.argv[1]) 
numResidues = numRepeats
buff = 1.15
re_slope = 0.6848945286555771 ##nu 
re_intercept = np.exp(-0.2964995939065522)

calc_re = re_intercept * ((numResidues)**(re_slope))


boxL = calc_re + buff
print(np.round(boxL,3))

