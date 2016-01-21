# History of hydra-editor releases

## 1.2.0
* 2016-01-18: Support Blacklight 6 [Justin Coyne]

## 1.1.0
* 2015-10-09: multiple? shouldn't raise errors when confronted with non-properties [Justin Coyne]
* 2015-09-17: Add an instance method version of multiple? [Justin Coyne]
* 2015-09-17: Update build matrix [Justin Coyne]
* 2015-09-17: Make add and remove button the same size [Justin Coyne]
* 2015-09-17: Use property instead of deprecated has_attributes [Justin Coyne]
* 2015-09-17: Pin bootstrap-sass to 3.3.4.1 for rails 4.1 build [Justin Coyne]
* 2015-06-10: Use html-safe translation to avoid raw() call [Jeremy Echols]
* 2015-04-23: Add <kbd> tags for more semantic form instructions [Jeremy Echols]
* 2015-04-21: Allow overriding jetty port [Jeremy Echols]
* 2015-04-21: Add form instructions for screen readers [Jeremy Echols]
* 2015-04-17: Don't hardcode a version of hydra-head in the test app [Justin Coyne]
* 2015-04-16: Split option-building from field-building [Jeremy Echols]
* 2015-04-14: Make [ENTER] default to submit the form [Jeremy Echols]

## 1.0.3
* 2015-04-02: Updated README with info on how to set form labels [val99erie]
* 2015-03-30: Add documentation to Form#model_attributes. (ci skip) [Justin Coyne]
* 2015-03-30: Presenter should be able to know the cardinality of associations [Justin Coyne]

## 1.0.2
* Update javascript to be more selective about which fields cause an error when blank

## 0.0.2
* Requiring active-fedora >= 6.3.0 in order to have the .required? method on ActiveFedora::Base:q

## 0.1.0
* RecordsControllerBehavior made more easily reusable outside of RecordsController.

### 0.1.1
* Correctly account for modifications made by initialize_fields when processing form data. Fixes #14.

