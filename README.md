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

Measure type must be:
- 1: if the best value for the measure is 1.0 (as precision, for example)
- 0: if the best value for the measure is 0.0 (as hamming loss, for example)

Call plot.win.tie.loss(data, names.methods, name.file, width, height, bottom, left, top, right, size.font, wtl) to plot, where
- data: dataframe from csv file
- names.methods: the method's names that you are comparing (example : c("method1", "method2", "method3))
- name.file: the full path where you want your file to be save (example: name.file = "~/Plots/measure1.pdf")
- width: pdf width value
- height: pdf height value
- bottom: par margin bottom value
- left: par margin left value
- top: par margin top value
- right: par margin right value
- size.font: par font size value
- wtl: a vector like c("win", "tie", loss") in your language or just use in English like this one.


  
