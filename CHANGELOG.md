## 0.11.0 (June 8, 2021)

ENHANCEMENTS:

* Add support disabling CloudWatch Logs resources (thanks @AlexanderIakovlev)

## 0.10.0 (April 30, 2021)

ENHANCEMENTS:

* Update config variables to support objects instead of maps values
* Update README & examples

FIXES:

* Remove `availability_zone_count` constraint

## 0.9.1 (April 22, 2021)

ENHANCEMENTS:

* Add pre-commit config file
* Add .gitignore file
* Update README

FIXES:

* Add AWS provider requirement (>= 3.35.0)

## 0.9.0 (April 12, 2021)

ENHANCEMENTS:

* Add `custom_endpoint` support
* Update examples

## 0.8.0 (January 24, 2021)


ENHANCEMENTS:

* Add support for conditional creation

FIXES:

* Update examples

## 0.7.1 (January 24, 2021)

FIXES:

* Fix `master_user_name` reference in locals (thanks @rafaelmariotti)

## 0.7.0 (January 8, 2021)

ENHANCEMENTS:

* Add retention configuration variable for Cloudwatch log group (thanks @elpaquete)

## 0.6.1 (October 28, 2020)

FIXES:

* Change default values for warm storage

## 0.6.0 (October 26, 2020)

ENHANCEMENTS:

* Add support for warm storage (thanks @jlfowle and @neilsmith1000)

## 0.5.1 (September 17, 2020)

FIXES:

* Fix `advanced_security_options` example. In order to use `master_user_arn`, the value for `internal_user_database_enabled` must be set to `false`.

## 0.5.0 (September 3, 2020)

ENHANCEMENTS:

* Add `domain_endpoint_options` support
* Update advaced security options examples
* Move advaced security options examples to its own folders
* Add READMEs to each example folder

## 0.4.1 (August 24, 2020)

FIXES:

* Bug/fix variable lookups for `master_user_password` and `dedicated_master_type` (thanks @mcook-bison)

## 0.4.0 (July 15, 2020)

ENHANCEMENTS:

* Add `advanced_security_options` block
* Add examples for `advanced_security_options` block

FIXES:

* Change "false" for the bool value

## 0.3.0 (June 26, 2020)

FIXES:

* Add Service Link role creation flag (default to `true`)


## 0.2.1 (May 2, 2020)

UPDATE:

* Update README

## 0.2.0 (May 2, 2020)

ENHANCEMENTS:

* Add support for customizable update timeout

UPDATES:

* Update public and vpc examples


## 0.1.2 (April 1, 2020)

UPDATES:

* Add Terraform logo in README

## 0.1.1 (November 21, 2019)

IMPROVEMENTS:

* Fix deprecation warning for Terraform >= 0.12.14

## 0.1.0 (October 28, 2019)

FEATURES:

* Module implementation
