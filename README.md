# Win-Tie-Loss

See the RUN.R file to check how the code works.

To calculate the win-tie-loss, a CSV file in the following format is required.

| datasets  | method 1 | method 2 | method ... | method M |
| --------- | -------- | -------- | ---------- | -------- |
| dataset 1 |          |          |            |          |
| dataset 2 |          |          |            |          |
| .......   |          |          |            |          |
| dataset D |          |          |            |          |
 
Place it in the CSVs folder, or pass the path where your CSV is saved.

Call compute.win.tie.loss(data, measure.type) to compute

Measury type must be:
- 1: if the best value for the measure is 1.0 (as precision, for example)
- 0: if the best value for the measure is 0.0 (as hamming loss, for example)

Call plot.win.tie.loss(data, names.methods, name.file, width, height, bottom, left, top, right, size.font, wtl) to plot
