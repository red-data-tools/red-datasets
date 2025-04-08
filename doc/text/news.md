# News

## 0.1.9 - 2025-04-08

### Improvements

  * `Datasets::Penguins`: Changed to use `POST` for downloading data
    from EDI.

## 0.1.8 - 2025-02-07

### Improvements

  * Suppressed "literal string will be frozen" warnings.

    * Patch by Tsutomu Katsube

  * `Datasets::HouseOfCouncillor`: Added.

    * [GH-143](https://github.com/red-data-tools/red-datasets/issues/143)

    * [GH-181](https://github.com/red-data-tools/red-datasets/issues/181)

    * Patch by Tsutomu Katsube

  * `Datasets::HouseOfRepresentative`: Added.

    * [GH-143](https://github.com/red-data-tools/red-datasets/issues/142)

    * [GH-181](https://github.com/red-data-tools/red-datasets/issues/184)

    * Patch by Tsutomu Katsube

### Thanks

  * Tsutomu Katsube


## 0.1.7 - 2023-05-29

### Improvements

  * `Datasets::NagoyaUniversityConversationCorpus`: Avoid using
    endless range for old Ruby.

## 0.1.6 - 2023-05-24

### Improvements

  * Added support for lazy loading by `require "datasets/lazy"`.

  * `Datasets::NagoyaUniversityConversationCorpus`: Added.
    [GH-168][https://github.com/red-data-tools/red-datasets/issues/168]
    [Patch by matsuura]

  * `Datasets::Wikipedia`: Added support for downloading in background.

### Thanks

  * matsuura

## 0.1.5 - 2022-09-22

### Improvements

  * `Datasets::PMJTDatasetList`: Added.
    [GitHub#107][Patch by okadak]

  * `Datasets::AozoraBunko`: Added.
    [GitHub#108][Patch by Masa]

  * Added how to develop to README
    [GitHub#117][Patch by abcdefg-1234567]

  * `Datasets::FuelEconomy`: Added.
    [GitHub#114][Patch by Benson Muite]

  * `Datasets::Geolonia`: Added.
    [GitHub#118][Patch by abcdefg-1234567]

  * `Datasets::Diamonds`: Added.
    [GitHub#110][Patch by Benson Muite]

  * `Datasets::ITACorpus`: Added.
    [GitHub#119][Patch by abcdefg-1234567]

  * `Datasets::KuzushijiMNIST`: Added.
    [GitHub#125][Patch by abcdefg-1234567]

  * Updated list of datasets in README.
    [GitHub#129][Patch by Benson Muite]

  * `Datasets::CaliforniaHousing`: Added.
    [GitHub#123][Patch by Benson Muite]

  * Added support for Ruby 3.1.
    [GitHub#130][Patch by Benson Muite]

  * `Datasets::AFINN`: Added.
    [GitHub#120][Patch by Benson Muite]

  * `Datasets::LivedoorNews`: Added.
    [GitHub#127][Patch by abcdefg-1234567]

  * `Datasets::SeabornDataList`: Added.
    [GitHub#134][Patch by Hirokazu SUZUKI]

  * `Datasets::WikipediaKyotoJapaneseEnglish`: Added.
    [GitHub#135][Patch by abcdefg-1234567]

  * Renamed Rdatasets to Rdataset.
    [GitHub#148][Patch by Hirokazu SUZUKI]

  * Removed support for Ruby 2.6.

  * Add missing license information.

  * `Datasets::QuoraDuplicateQuestionPair`: Added.
    [GitHub#149][Patch by otegami]

### Fixes

  * Fixed key from nil to :index in `Datasets::SeabornData`.
    [GitHub#133][Patch by Hirokazu SUZUKI]

  * Fixed `Datasets::Rdatasets#each` to change "NA" to nil.
    [GitHub#139][Patch by Hirokazu SUZUKI]

  * Fix `Datasets::Rdatasets#each` with mixed data of numeric and string.
    [GitHub#140][Patch by Hirokazu SUZUKI]

### Thanks

  * okadak

  * Masa

  * Benson Muite

  * abcdefg-1234567

  * Hirokazu SUZUKI

  * Sutou Kouhei

  * otegami

## 0.1.4 - 2021-07-13

### Improvements

  * `Datasets::SudachiSynonymDictionary`: Stopped depending on `LANG`.

## 0.1.3 - 2021-07-09

### Improvements

  * `Datasets::SeabornData`: Added.

  * `Datasets::SudachiSynonymDictionary`: Added.

## 0.1.2 - 2021-06-03

### Improvements

  * `Datasets::Rdatasets` and `Datasets::RdatasetsList`: Added.

  * `Datasets::Penguins`: Changed for compatibility with seaborn's
    penguins dataset.

## 0.1.1 - 2021-04-11

### Improvements

  * Added support for Ruby 3.0.

  * `Datasets::Communities`: Added.
    [GitHub#64][Patch by Yasuo Honda]

  * `Datasets::EStatJapan`: Added.
    [GitHub#90][Patch by Kunihiko Miyoshi]

  * `Datasets::Penguins`: Added.
    [GitHub#100][Patch by Kenta Murata]

  * `Datasets::CLDRPlurals`: Added.

### Thanks

  * Yasuo Honda

  * Kunihiko Miyoshi

  * Kenta Murata

## 0.1.0 - 2020-02-04

### Improvements

  * Added support for Ruby 2.7.
    [GitHub#82][GitHub#83][Patch by Yasuo Honda]

  * `Datasets::Hepatitis`: Added.
    [GitHub#70][Patch by KazuhiroYoshimoto]

  * `Datasets::Downloader`: Added support for query.

### Thanks

  * Yasuo Honda

  * KazuhiroYoshimoto

## 0.0.9 - 2019-09-09

### Improvements

  * `Datasets::LIBSVMDatasetList`: Improved performance.

  * `Datasets::Mushroom`: Added.
    [GitHub#33][Patch by Yasuo Honda]

  * `Datasets::Table#n_columns`: Added.

  * `Datasets::Table#n_rows`: Added.

  * `Datasets::Table#[]`: Added support for index access.

  * `Datasets::Table#coolumn_names`: Added.

  * `Datasets::Table#size`: Added.

  * `Datasets::Table#length`: Added.

  * `Datasets::Table#each_column`: Added.

  * `Datasets::Table#each_record`: Added.

  * `Datasets::Table#find_record`: Added.

### Thanks

  * Yasuo Honda

### Improvements

## 0.0.8 - 2019-03-24

### Improvements

  * Improved README.
    [GitHub#40][Patch by kojix2]

  * `Datasets::PostalCodeJapan`: Added.

  * `Datasets::LIBSVMDatasetList`: Added.

  * `Datasets::LIBSVM`: Added.

### Thanks

  * kojix2

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
