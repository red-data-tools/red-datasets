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

Here is an example to access CIFAR dataset by `#each`:

**CIFAR-10**

```ruby
require "datasets"

cifar = Datasets::CIFAR.new(n_classes: 10, type: :train)
cifar.metadata
#=> #<struct Datasets::Metadata name="CIFAR-10", url="https://www.cs.toronto.edu/~kriz/cifar.html", licenses=nil, description="CIFAR-10 is 32x32 image dataset">licenses=nil, description="CIFAR-10 is 32x32 image datasets">
cifar.each do |record|
  p record.pixels
  # => [59, 43, 50, 68, 98, 119, 139, 145, 149, 143, .....]
  p record.label
  # => 6
end
```

**CIFAR-100**

```ruby
require "datasets"

cifar = Datasets::CIFAR.new(n_classes: 100, type: :test)
cifar.metadata
#=> #<struct Datasets::Metadata name="CIFAR-100", url="https://www.cs.toronto.edu/~kriz/cifar.html", licenses=nil, description="CIFAR-100 is 32x32 image dataset">
cifar.each do |record|
  p record.pixels
  #=> [199, 196, 195, 195, 196, 197, 198, 198, 199, .....]
  p record.coarse_label
  #=> 10
  p record.fine_label
  #=> 49
end
```

## License

The MIT license. See `LICENSE.txt` for details.
