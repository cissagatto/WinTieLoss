# Win-Tie-Loss

See the RUN.R file to check how the code works.

To calculate the win-tie-loss, a CSV file in the following format is required.

| datasets  | method 1 | method 2 | method ... | method M |
| dataset 1 |          |          |            |          |
| dataset 1 |          |          |            |          |
| .......   |          |          |            |          |
| dataset D |          |          |            |          |
 
Place it in the CSVs folder, or pass the path where your CSV is saved to the function.
Call compute.win.tie.loss(data, measure.type) to compute
Call plot.win.tie.loss(data, names.methods, name.file,width, height, bottom,left, top, right, size.font, wtl) to plot the 
