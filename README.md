# Win-Tie-Loss Tool 

Welcome to the **Win-Tie-Loss Tool**, an easy-to-use R package for comparing multiple methods across different datasets. This tool allows you to calculate and visualize the win-tie-loss outcomes between methods using a single command. Whether you're working on machine learning, bioinformatics, or any other domain where method comparison is crucial, this tool has you covered.

## Key Features

- **Automatic Win-Tie-Loss Calculation**: Quickly compute win-tie-loss comparisons across multiple methods.
- **Flexible Measure Types**: Supports both maximization (e.g., precision) and minimization (e.g., hamming loss) objectives.
- **Customizable Visualizations**: Generate professional bar plots to visualize your results with full control over layout and design.
- **Easy-to-Use**: Simply provide your data in CSV format, call the functions, and get your results.


## How to cite

```plaintext
@misc{WinTieLoss2024,
  author = {Elaine Cecília Gatto},
  title = {WinTieLoss: A package to compare methods},  
  year = {2024},
  note = {R package version 0.1.0. Licensed under CC BY-NC-SA 4.0},
  url = {https://github.com/cissagatto/WinTieLoss}
}
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

To compute the win-tie-loss metrics, load your data and call the function. Don't forget to install the package.

```r
library(WinTieLoss)
result <- win.tie.loss.compute(data, measure.type)
```

- **`data`**: Your dataset in CSV format, read into a DataFrame.
- **`measure.type`**: 
  - `1` if a higher value indicates better performance (e.g., precision).
  - `0` if a lower value indicates better performance (e.g., hamming loss).

### Step 3: Visualize Your Results

Generate a bar plot to visualize your win-tie-loss comparison:

```r
win.tie.loss.plot(data = result, 
                  names.methods = c("method1", "method2", "method3"),
                  name.file = "~/Plots/measure1.pdf",
                  width = 10, height = 7,
                  bottom = 5, left = 4, top = 2, right = 2,
                  size.font = 1, 
                  wtl = c("Win", "Tie", "Loss"))
```

- **`data`**: The result from `win.tie.loss.compute`.
- **`names.methods`**: A vector of method names to label your plot.
- **`name.file`**: The path and file name to save the plot as a PDF.
- **`width`, `height`**: Dimensions of the PDF.
- **`bottom`, `left`, `top`, `right`**: Margins for the plot.
- **`size.font`**: Font size for the plot labels.
- **`wtl`**: A vector with labels for "Win", "Tie", and "Loss" (you can change to your language).

## Example Use Case

Imagine you're comparing the performance of several machine learning models on different datasets. After computing the results using `win.tie.loss.compute`, you can easily generate a visual comparison highlighting which methods perform best overall. 


### Documentation

For more detailed documentation on each function, check out the `~/WinTieLoss/docs`folder



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

Start making informed decisions with the Win-Tie-Loss Tool today! 🚀
