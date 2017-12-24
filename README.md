# README

## Name

Red Datasets

## Description

Red Datasets provides classes that provide common datasets such as iris dataset.

You can use datasets easily because you can access each dataset with multiple ways such as `#each` and Apache Arrow Record Batch.

## Install

```console
% gem install red-datasets
```

## Usage

Here is an example to access iris dataset by `#each`:

```ruby
require "datasets"

iris = Datasets::Iris.new
iris.each do |record|
  p [
     record.sepal_length,
     record.sepal_width,
     record.petal_length,
     record.petal_width,
     record.class,
  ]
  # [5.1, 3.5, 1.4, 0.2, "Iris-setosa"]
  # [7.0, 3.2, 4.7, 1.4, "Iris-versicolor"]
end
```

## License

The MIT license. See `LICENSE.txt` for details.
