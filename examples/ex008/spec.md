---
doc_name: "Firmware Update Specification"
doc_id: "SPEC-1234"
revision: "A"
logo: "ex008/assets/logo.svg"

toc: true
toc-depth: 1
section-numbering: "1.1.1.1.1.1"
page-numbering: "1"

signatures:
  - name: ""
    function: "Originator"
    signature: ""
    date: ""
  - name: ""
    function: "Reviewer"
    signature: ""
    date: ""
  - name: ""
    function: "Approver"
    signature: ""
    date: ""

revision_history:
  - rev: "A"
    dco: "DCO-1234"
    change: "Initial release"
    originator: "Sebastian"
---

# Scope

This document specifies the firmware update flow.

# References

Applicable documents go here.

# Requirements

## General Requirements

### Firmware package validation

#### The update package shall be validated before any device is modified.

#### The system shall reject packages with an invalid signature.

### Recovery behavior

#### The device shall recover cleanly after power loss during staging.

##### Even deeper nesting of the specification
