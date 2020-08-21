# Condition Interpreter

This project is a utility in apex that can evaluate user defined conditions, for example it can be used to perform in memory matching based on rules defined by a user.

## Installation

The simplest installation option would be to install the unlocked package using one of the following links

1. [Production](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000001hcuRQAQ)
2. [Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000001hcuRQAQ)

Alternatively this can be done in the command line using `sfdx force:package:install --package 04t4K000001hcuRQAQ`

## Usage

Usage is highlighted in the ConditionInterpreterTest class, the conditions can be defined and stored in a custom object / custom metadata.

The project came about with seeing that many managed packages in Salesforce development use some kind of custom object (/custom metadata) to perform some kind matching logic to records in the system to apply some kind of rules to those. Seeing as this was a widely used process I thought it would be good to have some kind of reusable option for achieving this. The classes that I have written here is withdrawn from whichever option is chosen for users to define the criteria (wheather it is in a custom object, custom metadata or on a page).

## Future Phases

* Include logic to create a dynamic soql based on the conditions so that only the records that are being refrenced get queried
