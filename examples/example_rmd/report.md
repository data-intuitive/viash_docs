---
title: Report
output: pdf_document
params:
  title: "My title"
  mean: 0
  sd: 1
---



This is an example report.

## Input parameters 


{% highlight text %}
## Error in paste0(" * ", names(params), ": ", params, "\n", collapse = ""): object 'params' not found
{% endhighlight %}

## Results

{% highlight r %}
df <- tibble(
  x = rnorm(100, mean = params$mean, sd = params$sd),
  y = rnorm(100, mean = params$mean, sd = params$sd),
  l = sample(letters, 100, replace = TRUE)
)
{% endhighlight %}



{% highlight text %}
## Error in rnorm(100, mean = params$mean, sd = params$sd): object 'params' not found
{% endhighlight %}



{% highlight r %}
ggplot(df) + 
  geom_text(aes(x, y, label = l)) +
  labs(title = params$title) +
  theme_bw()
{% endhighlight %}



{% highlight text %}
## Error:   You're passing a function as global data.
##   Have you misspelled the `data` argument in `ggplot()`
{% endhighlight %}
