---
title: "Week 3 Assessment — Data Visualization with ggplot2
author: "Aminah Brown-Roopnarine"
date: "2026-09-27"
output: pdf_document
---
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)
library(ggplot2)
library(dplyr)
library(tidyr)
library(cowplot)
library(ggpubr)
library(readr)
```
## Exercise 1 — Reproducing and combining ggplot2 figures

# The two figures

```{r load-data}
nh <- read_csv("cleaned_NHANES.csv")
# Adjust the column names below to match the actual cleaned dataset
# (e.g., age, gender, ethnicity)
```

```{r fig1}
# Figure 1: Histogram of age by gender
p1 <- nh %>%
  ggplot(aes(x = age, fill = gender)) +
  geom_histogram(binwidth = 5, position = "dodge", alpha = 0.7) +
  scale_fill_manual(values = c("salmon", "#008080")) +
  labs(
    title = "Distribution of Age by Gender",
    x = "Age (years)",
    y = "Count"
  ) +
  theme_minimal()
  theme(plot.title = element_text(size = 12))

p1
```

```{r fig2}
# Figure 2: Stacked bar chart of ethnicity by gender (100% stacked)
p2 <- nh %>%
  ggplot(aes(x = ethnicity_2, fill = gender)) +
  geom_bar(position = "fill") +
  scale_fill_manual(values = c("salmon", "#008080")) +
  labs(
    title = "Proportion of Ethnicities by Gender",
    x = "Ethnicity",
    y = "Proportion"
  ) +
  theme_minimal()
  theme(plot.title = element_text(size = 12))
  
p2
```
# Combination of Both Plots

```{r combine}
# With cowplot

combined_cowplot <- plot_grid(p1, p2, labels = c("A", "B"), ncol = 2)

combined_cowplot

# With ggpubr

p2 <- p2 + theme(axis.text.x = element_text(angle = 45, hjust = 1))
combined_ggpubr <- ggarrange(p1, p2, labels = c("A", "B"),
                             ncol = 2, widths = c(1.3, 1.5),
                             common.legend = TRUE, legend = "bottom")
combined_ggpubr
```

# Comparing `plot_grid()` and `ggarrange()`

`plot_grid()` (cowplot) is lightweight and gives fine control over axis alignment and the A/B labels. It is excellent when you want perfectly aligned panels.

`ggarrange()` (ggpubr) offers extra features: automatic legend alignment, shared axis labels, and richer layout options.

Based on the core uses of these respective functions, ggarrange() has a better layout for both of these plots.


For these two plots, `ggarrange()` generally produces a cleaner result because it aligns the two panels automatically and lets you share a common legend — reducing redundancy since both figures use the same gender colors. To elaborate, ggarrange() has “common. legend = TRUE”, which neatly gives you a single "gender" legend instead of two. plot_grid() doesn't do this automatically. Additionally, it aligns the panels nicely, allowing for axis alignment to look polished while finalizing the figure. 

## Exercise 2 (20%) — Visualizing key characteristics

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)
library(ggplot2)
library(dplyr)
library(readr)
```

# The four plots

```{r load-data}
nh <- read_csv("cleaned_NHANES.csv")
# Adjust column names to match your actual cleaned dataset
```

### Age

```{r ex2-age}
p_age <- nh %>%
  ggplot(aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "white") +
  labs(
    title = "Distribution of participant age",
    x = "Age (years)",
    y = "Count"
  ) +
  theme_minimal()

p_age
```

### Gender

```{r ex2-gender}
p_gender <- nh %>%
  ggplot(aes(x = gender, fill = gender)) +
  geom_bar() +
  scale_fill_manual(values = c("#FA8072", "#008080")) +
  labs(
    title = "Distribution of participants by gender",
    x = "Gender",
    y = "Count"
  ) +
  theme_minimal()

p_gender
```

### First ethnicity variable

```{r ex2-eth1}
p_eth1 <- nh %>%
  ggplot(aes(x = ethnicity, fill = ethnicity)) +
  geom_bar() +
  labs(
    title = "Distribution of the ethnicity variable",
    x = "Ethnicity",
    y = "Count"
  ) +
  theme_minimal()

p_eth1
```

### Second ethnicity variable

```{r ex2-eth2}
p_eth2 <- nh %>%
  ggplot(aes(x = ethnicity2, fill = ethnicity2)) +
  geom_bar() +
  labs(
    title = "Distribution of the second ethnicity variable",
    x = "Ethnicity",
    y = "Count"
  ) +
  theme_minimal()

p_eth2
```

## Missing values

```{r missing}
sum(is.na(nh$age))
sum(is.na(nh$gender))
sum(is.na(nh$ethnicity))
sum(is.na(nh$ethnicity2))
```

## Describing the distributions

**Age:** roughly uniform across the adult range (the NHANES sample is designed to be representative), with missing values as reported above.

**Gender:** near-balanced split between males and females.

**Ethnicity:** uneven distribution, with some groups much more represented than others. Missing values as reported above.

## Saving the plots

```{r save-plots}
ggsave("age_plot.png", p_age, width = 8, height = 5)
ggsave("gender_plot.png", p_gender, width = 8, height = 5)
ggsave("ethnicity_plot.png", p_eth1, width = 8, height = 5)
```

## Comparing the two ethnicity variables

NHANES contains `RIDRETH1` (4 categories) and `RIDRETH3` (6 categories, adding other races and multi-racial). **Keep the 6-category variable**, because it is more detailed and reflects NHANES's current classification. Remove the 4-category variable.

```{r remove-eth}
nh <- nh %>% select(-ethnicity_old)  # use the actual column name
```


```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
