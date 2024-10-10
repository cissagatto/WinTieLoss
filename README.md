# Win-Tie-Loss Performance Analysis 

Welcome to the **Win-Tie-Loss Performance Analysis**, an easy-to-use R package for comparing multiple methods across different datasets. This tool calculates and visualizes the win-tie-loss outcomes between methods using a single command. Whether you're working on machine learning, bioinformatics, or any other domain where method comparison is crucial, this tool has you covered.

## Key Features

- **Automatic Win-Tie-Loss Calculation**: Quickly compute win-tie-loss comparisons across multiple methods.
- **Flexible Measure Types**: This type supports both maximization (e.g., precision) and minimization (e.g., hamming loss) objectives.
- **Customizable Visualizations**: Generate professional bar plots to visualize your results with complete control over layout and design.
- **Easy-to-Use**: Provide your data in CSV format, call the functions, and get your results.


## How to cite

```plaintext
@misc{WTL2024,
  author = {Elaine Cecília Gatto},
  title = {WinTieLoss: An R Package for Comparative Analysis of Machine Learning Methods},  
  year = {2024},
  doi = {10.13140/RG.2.2.17131.35366/1},
  note = {R package version 0.1.0. Licensed under CC BY-NC-SA 4.0},
  url = {https://github.com/cissagatto/WinTieLoss}
}
```

## What is a Win-Tie-Loss Chart?

A Win-Tie-Loss chart is a visual tool for comparing the performance of different algorithms or methods across multiple tasks or datasets. This type of chart summarizes how often a method "wins," "ties," or "loses" compared to other methods based on a specific performance metric.

## Concept and Context

In the context of **Machine Learning**, models are frequently compared to determine which offers the best performance in accuracy, recall, F1-score, or any other metric of interest. The Win-Tie-Loss chart is handy when dealing with multiple methods and datasets, as it provides a clear and aggregated view of how each method performs relative to others.

## Mathematical Formalization

To understand the mathematical concept behind a Win-Tie-Loss chart, consider a scenario where you have $M$ methods (or models) and $N$ datasets. Each method $m_{i}$ produces a performance metric $P_{i,j}$ on a dataset $D_{j}$.

1. **Method Combinations**: For each pair of methods $(m_{i},m_{k})$ where $i \neq k $, you compare the results $P_{i,j}$ and $P_{k,j}$ on each dataset $D_{j}$.
  
2. **Counting Wins, Ties, and Losses**:
    - **Win**: Method $m_{i}$ wins against method $m_{k}$ on dataset $D_{j}$ if $P_{i,j} > P_{k,j}$.
    - **Tie**: $m_{i}$ ties with $m_{k}$ on dataset $D_{j}$ if $P_{i,j} = P_{k,j}$.
    - **Loss**: $m_{i}$ loses to $m_{k}$ on dataset $D_{j}$ if $P_{i,j} < P_{k,j}$.

3. **Aggregating Results**: After comparing all method pairs and datasets, you count the total number of wins, ties, and losses for each method relative to the others.

Mathematically, we can define the counts $W_{i}$, $T_{i}$, and $L_{i}$ for method $m_{i}$ as follows:

- $W_{i} = \sum_{k \neq i} \sum_{j=1}^{N} \text{I}(P_{i,j} > P_{k,j})$
- $T_{i} = \sum_{k \neq i} \sum_{j=1}^{N} \text{I}(P_{i,j} = P_{k,j})$
- $L_{i} = \sum_{k \neq i} \sum_{j=1}^{N} \text{I}(P_{i,j} < P_{k,j})$

where $\text{I}(\cdot)$ is an indicator function that returns 1 if the condition inside is true and 0 otherwise.

### Interpretation in the Context of Machine Learning

In the context of Machine Learning, the Win-Tie-Loss chart helps answer important questions like:

- **Which method is consistently better?**: A method with more "wins" across different datasets can be considered more robust.
- **Are there comparable methods?**: Many "ties" might indicate that some methods perform similarly.
- **Which methods are consistently worse?**: A method with more "losses" might be inferior or unsuitable for the task at hand.

The chart provides a quick visualization of these aspects, making it easier to decide which model or algorithm to use in future tasks or experiments.

### Example of Application

Suppose you have three classification models $A$, $B$, and $C$, and you apply them to 10 different datasets. After calculating the performance metric for each model on each dataset, you compare the results. If model $A$ wins on $7$ datasets, ties on $2$, and loses on $1$, your Win-Tie-Loss chart may show that $A$ is the best model overall, while $B$ and $C$ have more losses or ties. In summary, a Win-Tie-Loss chart is an effective way to summarize and interpret comparisons between multiple methods in machine learning problems, highlighting the relative performance of the methods clearly and concisely.


## Instalation


```r
# install.packages("devtools")
library("devtools")
devtools::install_github("https://github.com/cissagatto/WinTieLoss")
library(WinTieLoss)
```


## Getting Started

### Step 1: Prepare Your Data

Prepare your dataset in a CSV format. The CSV should have the following structure:

| datasets  | method 1 | method 2 | method ... | method M |
| --------- | -------- | -------- | ---------- | -------- |
| dataset 1 |   0.85   |   0.80   |    ...     |   0.90   |
| dataset 2 |   0.88   |   0.82   |    ...     |   0.89   |
| ...       |   ...    |   ...    |    ...     |   ...    |
| dataset D |   0.90   |   0.85   |    ...     |   0.92   |

Save your CSV file in the `Data` folder or specify a custom path when calling the functions.

### Step 2: Compute Win-Tie-Loss

To compute the win-tie-loss, load your data and call the function.

```r

FolderRoot = "~/pathToYourRootFolder"
FolderData = "~/pathToYourDataFolder"
FolderResults = "~/pathToYourResultsFolder"

library(WinTieLoss)

name.file = "~/WinTieLoss/Data/clp.csv"
data = data.frame(read.csv(name.file))
data = data[,-1]
methods.names = colnames(data)

df_res.mes <- wtl.measures()
filtered_res.mes <- filter(df_res.mes, names == "clp")
measure.type = as.numeric(filtered_res.mes$type)

res = win.tie.loss.compute(data = data, measure.type)
res$method <- factor(res$method, levels = methods.names)
res <- res[order(res$method), ]

save = paste(FolderResults, "/clp.csv", sep="")
write.csv(res, save, row.names = FALSE)

```

- **`data`**: Your dataset in CSV format, read into a DataFrame.
- **`measure.type`**: 
  - `1` if a higher value indicates better performance (e.g., precision).
  - `0` if a lower value indicates better performance (e.g., hamming loss).

### Step 3: Visualize Your Results

Generate a bar plot to visualize your win-tie-loss comparison:

```r
wtl = c("win", "tie", "loss")
colnames(res) = wtl 

save = paste(FolderResults, "/clp.pdf", sep="")
win.tie.loss.plot(data = res, 
                  names.methods = methods.names, 
                  name.file = save, 
                  width = 18, 
                  height = 10, 
                  bottom = 2, 
                  left = 11, 
                  top = 0, 
                  right = 1, 
                  size.font = 2.0,
                  wtl = wtl)
```

- **`data`**: The result from `win.tie.loss.compute`.
- **`names.methods`**: A vector of method names to label your plot.
- **`name.file`**: The path and file name to save the plot as a PDF.
- **`width`, `height`**: Dimensions of the PDF.
- **`bottom`, `left`, `top`, `right`**: Margins for the plot.
- **`size.font`**: Font size for the plot labels.
- **`wtl`**: A vector with labels for "Win", "Tie", and "Loss" (you can change to your language).

### Semi-automated Analysis

If you wish, there are also functions to help you analyze the results. For example, if you compared 30 models using 50 datasets, it may be difficult 
to interpret the results. See the functions in the analyis.R script, they were written to perform some calculations. There are examples of how 
to use them in the example.R file, in the example folder.

### Documentation

For more detailed documentation on each function, check out the `~/WinTieLoss/docs` folder.
A complete example is available in `~/WinTieLoss/example` folder.


### Folder Structure

Ensure the following folder structure is set up:

- `FolderRoot`: Root directory of the project.
- `FolderData`: Directory where CSV data files are stored.
- `FolderResults`: Directory where results and plots are saved.


## 📚 **Contributing**

We welcome contributions from the community! If you have suggestions, improvements, or bug fixes, please submit a pull request or open an issue in the GitHub repository.


## Acknowledgment
- This study was financed in part by the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001.
- This study was financed in part by the Conselho Nacional de Desenvolvimento Científico e Tecnológico - Brasil (CNPQ) - Process number 200371/2022-3.
- The authors also thank the Brazilian research agencies FAPESP financial support.


## 📧 **Contact**

For any questions or support, please contact:
- **Prof. Elaine Cecilia Gatto** (elainececiliagatto@gmail.com)
  

# Links

| [Site](https://sites.google.com/view/professor-cissa-gatto) | [Post-Graduate Program in Computer Science](http://ppgcc.dc.ufscar.br/pt-br) | [Computer Department](https://site.dc.ufscar.br/) |  [Biomal](http://www.biomal.ufscar.br/) | [CNPQ](https://www.gov.br/cnpq/pt-br) | [Ku Leuven](https://kulak.kuleuven.be/) | [Embarcados](https://www.embarcados.com.br/author/cissa/) | [Read Prensa](https://prensa.li/@cissa.gatto/) | [Linkedin Company](https://www.linkedin.com/company/27241216) | [Linkedin Profile](https://www.linkedin.com/in/elainececiliagatto/) | [Instagram](https://www.instagram.com/cissagatto) | [Facebook](https://www.facebook.com/cissagatto) | [Twitter](https://twitter.com/cissagatto) | [Twitch](https://www.twitch.tv/cissagatto) | [Youtube](https://www.youtube.com/CissaGatto) |

---

Start making performance analysis with the Win-Tie-Loss Tool today! 🚀
