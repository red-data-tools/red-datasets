# News

## 0.0.7 - 2018-11-21

### Improvements

  * `Datasets::Table#dictionary_encode`: Added.
    [GitHub#22]

  * `Datasets::Table#label_encode`: Added.

  * `Datasets::Dictionary`: Added.

  * `Datasets::Wine`: Added.
    [GitHub#26][Patch by Ryuta Suzuki]

  * `Datasets::FashionMNIST`: Added.
    [GitHub#27][Patch by chimame]

  * `Datasets::Iris::Record#label`: Renamed from `#class`. This is an
    incompatible change.

  * `Datasets::Adult`: Added.
    [GitHub#30][Patch by Yasuo Honda]

### Thanks

  * Ryuta Suzuki

  * chimame

  * Yasuo Honda

## 0.0.6 - 2018-07-25

### Improvements

  * `Datasets::MNIST`: Added.

  * `Datasets::PennTreebank`: Added.

## 0.0.5 - 2018-06-06

### Improvements

  * `Datasets::Table#[]`: Added.

  * `Datasets::Table#fetch_values`: Added.

  * `Datasets::Table#each`: Added.

  * `Datasets::CIFAR`: Added pixels data to `Datasets::Table`.

### Fixes

  * Fixed indent of sample codes in README.
    [GitHub#11][Patch by FURUSAWA Tomohiro]

### Thanks

  * FURUSAWA Tomohiro

## 0.0.4 - 2018-05-03

### Improvements

  * `Datasets::Dataset`: Made enumerable.

  * `Datasets::CIFAR`: Added the CIFAR dataset.
    [GitHub#7][GitHub#8][GitHub#9][GitHub#10]
    [Patch by Yusaku Hatanaka]

### Thanks

  * Yusaku Hatanaka

## 0.0.3 - 2018-03-27

### Improvements

  * `Datasets::Metadata#licenses`: Renamed from `#license`. This is a
    broken change.

  * `Datasets::Wikipedia`: Added missing license information.

  * Progress: Stopped progress bar when the process goes to background.

  * Progress: Added rest time and throughput information.

  * Progress: Added dynamic terminal width change support.

  * Progress: Added continuous download support.

  * `Datasets::Dataset#to_table`: Added.

  * `Datasets::Table`: Added.

## 0.0.2 - 2018-02-06

### Improvements

  * `Datasets::Wikipedia`: Added a dataset for Wikipedia.

## 0.0.1 - 2018-01-08

### Improvements

  * `Datasets::Iris`: Added a dataset for iris.
